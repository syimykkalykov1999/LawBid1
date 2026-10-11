// Второй проход обхода API: подставляет в пути с {id} и {username} значения, найденные в уже записанных ответах.
// node crawl-detail.mjs <код> <роль> <openapi.json>   (после crawl-api.mjs: дописывает /tmp/api_<роль>.json)
import { readFileSync, writeFileSync } from 'node:fs';
import { call } from './login.mjs';
const [code, role, spec] = process.argv.slice(2);
const file = `/tmp/api_${role}.json`;
const out = JSON.parse(readFileSync(file, 'utf8'));
const token = (await call('POST', '/demo/invites/redeem', { body: { code } })).json.data.tokens.accessToken;
const templates = Object.entries(JSON.parse(readFileSync(spec, 'utf8')).paths)
  .filter(([p, v]) => v.get && p.includes('{') && !p.startsWith('/admin') && !p.startsWith('/demo') && !p.includes('/files/'))
  .map(([p]) => p);
const SEARCH = ['/search/attorneys?q=a', '/search/people?q=a', '/search/cases?q=a', '/search/posts?q=a', '/search/tags?q=a', '/saved-items?kind=post', '/reels?limit=20'];
for (const p of SEARCH) {
  const x = await call('GET', p, { token, demo: true });
  if (x.status === 200) out['GET ' + p] = { status: 200, body: x.json };
}
const UUID = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/;
function pool() {
  const ids = new Set(), names = new Set();
  const walk = (v) => {
    if (Array.isArray(v)) v.forEach(walk);
    else if (v && typeof v === 'object') {
      for (const [k, x] of Object.entries(v)) {
        if (typeof x === 'string' && UUID.test(x) && (k === 'id' || k.endsWith('Id'))) ids.add(x);
        if (typeof x === 'string' && k === 'username') names.add(x);
        walk(x);
      }
    }
  };
  Object.values(out).forEach((r) => walk(r.body));
  return { ids: [...ids], names: [...names] };
}
for (let round = 0; round < 2; round++) {
  const { ids, names } = pool();
  let added = 0;
  for (const t of templates) {
    const params = [...t.matchAll(/\{(\w+)\}/g)].map((m) => m[1]);
    if (params.length !== 1) continue;
    const cands = (params[0] === 'username' ? names : ids).slice(0, 40);
    let hits = 0;
    for (const c of cands) {
      if (hits >= 6) break;
      const path = t.replace(/\{\w+\}/, c);
      if (('GET ' + path) in out) { hits++; continue; }
      const x = await call('GET', path, { token, demo: true });
      if (x.status === 200) { out['GET ' + path] = { status: 200, body: x.json }; hits++; added++; }
    }
  }
  console.log(role, 'round', round, 'added', added);
}
writeFileSync(file, JSON.stringify(out));
console.log(role, Object.keys(out).length, 'entries');
