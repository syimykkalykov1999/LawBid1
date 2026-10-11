// Runs before the API on the test server (see deploy/README.md). Idempotent:
// migrations always, base seed once, translations whenever the files change.
import { execSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import { readFileSync, readdirSync } from 'node:fs';
import { join } from 'node:path';
import { PrismaClient } from '@prisma/client';

const L10N = process.env.L10N_DIR ?? '/app/shared/localization';
const run = (cmd) => execSync(cmd, { stdio: 'inherit', env: process.env });
const prisma = new PrismaClient();

run('npx prisma migrate deploy');

const [{ n }] = await prisma.$queryRaw`SELECT count(*)::int AS n FROM states`;
if (n === 0) run('node dist/prisma/seed.js');

async function setConfig(key, value) {
  await prisma.$executeRaw`INSERT INTO app_config (key, value, updated_at)
    VALUES (${key}, ${JSON.stringify(value)}::jsonb, now())
    ON CONFLICT (key) DO UPDATE SET value = EXCLUDED.value, updated_at = now()`;
}

// Translations: base file first, then the key updates, then language names.
const files = readdirSync(L10N).filter((f) => f.endsWith('.xlsx')).sort();
const ordered = [
  ...files.filter((f) => f === 'lawbid-app-translations.xlsx'),
  ...files.filter((f) => f === 'lawbid-chinese-traditional.xlsx'),
  ...files.filter((f) => f.endsWith('-keys-update.xlsx')),
];
const names = readFileSync(join(L10N, 'set_language_names.sql'), 'utf8');
const hash = createHash('sha256');
for (const f of ordered) hash.update(readFileSync(join(L10N, f)));
hash.update(names);
const digest = hash.digest('hex');
const rows = await prisma.$queryRaw`SELECT value FROM app_config WHERE key = 'test_server.l10n_hash'`;
if (rows[0]?.value !== digest) {
  for (const f of ordered) run(`node dist/src/cli/import-translations.js ${join(L10N, f)}`);
  for (const stmt of names.split(';').map((s) => s.trim()).filter((s) => s && !/^(--[^\n]*\n?)*(BEGIN|COMMIT)$/i.test(s))) {
    const body = stmt.replace(/^(--[^\n]*\n)+/g, '').trim();
    if (body) await prisma.$executeRawUnsafe(body);
  }
  await setConfig('test_server.l10n_hash', digest);
}

const origins = (process.env.WEB_ORIGINS ?? '').split(',').map((s) => s.trim()).filter(Boolean);
if (origins.length) await setConfig('web.allowed_origins', origins);

await prisma.$disconnect();
