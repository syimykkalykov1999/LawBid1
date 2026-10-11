// GET-запросы без параметров пути по списку OpenAPI, от имени демо-аккаунта. node crawl-api.mjs <код> <роль> <openapi.json>
import { readFileSync, writeFileSync } from 'node:fs';
import { call } from './login.mjs';
const [code, role, spec] = process.argv.slice(2);
const r = await call('POST', '/demo/invites/redeem', { body: { code } });
const token = r.json.data.tokens.accessToken;
const paths = Object.entries(JSON.parse(readFileSync(spec, 'utf8')).paths)
  .filter(([p, v]) => v.get && !p.includes('{') && !p.startsWith('/admin') && !p.startsWith('/health') && !p.startsWith('/demo'))
  .map(([p]) => p);
const out = {};
for (const p of paths) {
  const x = await call('GET', p, { token, demo: true });
  if (x.status === 200) out['GET ' + p] = { status: 200, body: x.json };
  else console.log(x.status, p);
}
writeFileSync(`/tmp/api_${role}.json`, JSON.stringify(out));
console.log(role, Object.keys(out).length, 'ok of', paths.length);
