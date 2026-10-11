// Tiny S3 stand-in for the test server (files on disk, nothing else).
// Speaks just what the API uses: HeadBucket, CreateBucket, HeadObject,
// GetObject (+ Range, response-content-disposition), PutObject, DeleteObjects
// and the browser form upload (POST policy). Signatures are NOT checked:
// test data only, keys are random. MinIO's free image is gone, hence this.
import { createServer } from 'node:http';
import { createHash } from 'node:crypto';
import { mkdir, readFile, writeFile, rm, stat } from 'node:fs/promises';
import { createReadStream } from 'node:fs';
import { join } from 'node:path';

const ROOT = process.env.S3_DATA_DIR ?? '/data';
const PORT = Number(process.env.S3_PORT ?? 9000);
const MAX = 64 * 1024 * 1024;
const slot = (bucket, key) => {
  const h = createHash('sha1').update(key).digest('hex');
  return join(ROOT, bucket.replace(/[^a-zA-Z0-9._-]/g, '_'), h.slice(0, 2), h);
};
const xmlEsc = (s) => s.replace(/[<>&'"]/g, (c) => ({ '<': '&lt;', '>': '&gt;', '&': '&amp;', "'": '&apos;', '"': '&quot;' })[c]);
const xmlUnesc = (s) => s.replace(/&(lt|gt|amp|apos|quot);/g, (_, n) => ({ lt: '<', gt: '>', amp: '&', apos: "'", quot: '"' })[n]);

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, HEAD, PUT, POST, DELETE, OPTIONS',
  'Access-Control-Allow-Headers': '*',
  'Access-Control-Expose-Headers': 'ETag, Content-Length, Content-Range',
  'Access-Control-Max-Age': '600',
};
const send = (res, status, body = '', headers = {}) => {
  res.writeHead(status, { ...cors, ...headers });
  res.end(body);
};
const err = (res, status, code, msg = code) =>
  send(res, status, `<?xml version="1.0" encoding="UTF-8"?><Error><Code>${code}</Code><Message>${xmlEsc(msg)}</Message></Error>`, { 'Content-Type': 'application/xml' });

async function body(req) {
  const chunks = [];
  let n = 0;
  for await (const c of req) {
    n += c.length;
    if (n > MAX) throw new Error('too large');
    chunks.push(c);
  }
  return Buffer.concat(chunks);
}

async function store(bucket, key, data, type) {
  const f = slot(bucket, key);
  await mkdir(join(f, '..'), { recursive: true });
  await writeFile(f, data);
  await writeFile(`${f}.json`, JSON.stringify({ key, size: data.length, type }));
  return createHash('md5').update(data).digest('hex');
}
async function meta(bucket, key) {
  try {
    return JSON.parse(await readFile(`${slot(bucket, key)}.json`, 'utf8'));
  } catch {
    return null;
  }
}

function parseMultipart(buf, boundary) {
  const fields = {};
  let file = null;
  const delim = Buffer.from(`--${boundary}`);
  let pos = buf.indexOf(delim);
  while (pos !== -1) {
    const next = buf.indexOf(delim, pos + delim.length);
    if (next === -1) break;
    const part = buf.subarray(pos + delim.length + 2, next - 2); // strip CRLF around
    const split = part.indexOf('\r\n\r\n');
    const head = part.subarray(0, split).toString('utf8');
    const data = part.subarray(split + 4);
    const name = /name="([^"]*)"/.exec(head)?.[1];
    if (/filename="/.test(head)) file = { data, type: /Content-Type:\s*([^\r\n]+)/i.exec(head)?.[1] };
    else if (name) fields[name] = data.toString('utf8');
    pos = next;
  }
  return { fields, file };
}

createServer(async (req, res) => {
  try {
    const url = new URL(req.url, 'http://x');
    const parts = url.pathname.split('/').filter(Boolean).map(decodeURIComponent);
    const bucket = parts[0];
    const key = parts.slice(1).join('/');
    if (req.method === 'OPTIONS') return send(res, 204);
    if (!bucket) return send(res, 200, 'lawbid test s3');

    if (!key) {
      if (req.method === 'PUT') { await mkdir(join(ROOT, bucket), { recursive: true }); return send(res, 200); }
      if (req.method === 'HEAD') return stat(join(ROOT, bucket)).then(() => send(res, 200), () => send(res, 404));
      if (req.method === 'POST' && url.searchParams.has('delete')) {
        const xml = (await body(req)).toString('utf8');
        const keys = [...xml.matchAll(/<Key>([\s\S]*?)<\/Key>/g)].map((m) => xmlUnesc(m[1]));
        for (const k of keys) await rm(slot(bucket, k), { force: true }).then(() => rm(`${slot(bucket, k)}.json`, { force: true }));
        return send(res, 200, '<?xml version="1.0" encoding="UTF-8"?><DeleteResult/>', { 'Content-Type': 'application/xml' });
      }
      if (req.method === 'POST') { // browser form upload
        const m = /boundary=(?:"([^"]+)"|([^;]+))/.exec(req.headers['content-type'] ?? '');
        if (!m) return err(res, 400, 'MalformedPOSTRequest');
        const { fields, file } = parseMultipart(await body(req), m[1] ?? m[2]);
        if (!file || !fields.key) return err(res, 400, 'MalformedPOSTRequest');
        const etag = await store(bucket, fields.key, file.data, fields['Content-Type'] ?? file.type ?? 'application/octet-stream');
        return send(res, 204, '', { ETag: `"${etag}"` });
      }
      return err(res, 405, 'MethodNotAllowed');
    }

    if (req.method === 'PUT') {
      const etag = await store(bucket, key, await body(req), req.headers['content-type'] ?? 'application/octet-stream');
      return send(res, 200, '', { ETag: `"${etag}"` });
    }
    if (req.method === 'GET' || req.method === 'HEAD') {
      const m = await meta(bucket, key);
      if (!m) return err(res, 404, 'NoSuchKey', 'The specified key does not exist.');
      const h = { 'Content-Type': m.type, 'Accept-Ranges': 'bytes' };
      const cd = url.searchParams.get('response-content-disposition');
      if (cd) h['Content-Disposition'] = cd;
      let start = 0, end = m.size - 1, status = 200;
      const r = /bytes=(\d*)-(\d*)/.exec(req.headers.range ?? '');
      if (r && m.size > 0) {
        if (r[1] === '') { start = Math.max(0, m.size - Number(r[2])); }
        else { start = Number(r[1]); if (r[2] !== '') end = Math.min(end, Number(r[2])); }
        if (start > end) return err(res, 416, 'InvalidRange');
        status = 206;
        h['Content-Range'] = `bytes ${start}-${end}/${m.size}`;
      }
      h['Content-Length'] = m.size === 0 ? 0 : end - start + 1;
      res.writeHead(status, { ...cors, ...h });
      if (req.method === 'HEAD' || m.size === 0) return res.end();
      return createReadStream(slot(bucket, key), { start, end }).pipe(res);
    }
    if (req.method === 'DELETE') {
      await rm(slot(bucket, key), { force: true });
      await rm(`${slot(bucket, key)}.json`, { force: true });
      return send(res, 204);
    }
    return err(res, 405, 'MethodNotAllowed');
  } catch (e) {
    console.error(e);
    if (!res.headersSent) err(res, 500, 'InternalError', String(e.message));
  }
}).listen(PORT, () => console.log(`test s3 on :${PORT}, data in ${ROOT}`));
