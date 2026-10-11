// Собирает assets/demo/api.json из обхода API и записи explore.mjs.
// node build-dataset.mjs <выход.json> attorney=/tmp/api_attorney.json,/tmp/rec_attorney.jsonl client=...
import { readFileSync, writeFileSync, existsSync } from 'node:fs';
const [out, ...roles] = process.argv.slice(2);
const strip = (u) => u.replace(/^.*?\/api\/v1/, '');
const canon = (path, q) => {
  const sp = new URLSearchParams(q);
  const keys = [...sp.keys()].sort();
  return keys.length ? `GET ${path}?${keys.map((k) => `${k}=${sp.get(k)}`).join('&')}` : `GET ${path}`;
};
const result = { shared: {} };
for (const spec of roles) {
  const [role, files] = spec.split('=');
  const map = {};
  for (const f of files.split(',')) {
    if (!existsSync(f)) continue;
    if (f.endsWith('.jsonl')) {
      for (const line of readFileSync(f, 'utf8').split('\n').filter(Boolean)) {
        const r = JSON.parse(line);
        if (r.method !== 'GET' || r.status !== 200) continue;
        const [path, q = ''] = strip(r.url).split('?');
        let body; try { body = JSON.parse(r.body); } catch { continue; }
        map[canon(path, q)] = body;
        if (!q.includes('cursor') && !(`GET ${path}` in map)) map[`GET ${path}`] = body;
      }
    } else {
      for (const [k, v] of Object.entries(JSON.parse(readFileSync(f, 'utf8')))) map[k] = v.body;
    }
  }
  result[role] = map;
}
// общие публичные ответы (одинаковы для обеих ролей)
for (const k of Object.keys(result.attorney ?? {})) {
  if (/^GET \/(countries|i18n\/|config\/bootstrap)/.test(k)) result.shared[k] = result.attorney[k];
}
// публичные ответы напрямую с локального сервера: переводы (en, ru), языки, страны
const API = process.env.API ?? 'http://localhost:3000/api/v1';
for (const p of ['/i18n/languages', '/i18n/bundle/en', '/i18n/bundle/ru', '/countries', '/config/bootstrap']) {
  const r = await fetch(API + p);
  if (r.ok) result.shared['GET ' + p] = await r.json();
}
writeFileSync(out, JSON.stringify(result));
console.log(out, Object.fromEntries(Object.entries(result).map(([k, v]) => [k, Object.keys(v).length])));
