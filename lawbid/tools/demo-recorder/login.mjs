// Вход на локальном сервере (OTP_DEV_FIXED_CODE=true, код 000000) и создание демо-аккаунта.
export const B = process.env.API ?? 'http://localhost:3000/api/v1';
export async function call(method, path, { token, demo, body } = {}) {
  const r = await fetch(B + path, {
    method,
    headers: {
      'content-type': 'application/json',
      ...(token ? { authorization: `Bearer ${token}` } : {}),
      ...(demo ? { 'x-lawbid-demo': '1' } : {}),
    },
    body: body ? JSON.stringify(body) : undefined,
  });
  let json = null;
  try { json = await r.json(); } catch {}
  return { status: r.status, json };
}
import { execFileSync } from 'node:child_process';
function sql(q) {
  return execFileSync('docker', ['exec', 'crdb', './cockroach', 'sql', '--insecure', '-d', 'lawbid', '--format=csv', '-e', q]).toString();
}
export async function loginDemo(phone, role) {
  await call('POST', '/auth/otp/request', { body: { channel: 'phone', identifier: phone } });
  const v = await call('POST', '/auth/otp/verify', { body: { channel: 'phone', identifier: phone, code: '000000' } });
  const token = v.json?.data?.accessToken;
  if (!token) throw new Error('verify failed ' + JSON.stringify(v));
  const uid = JSON.parse(Buffer.from(token.split('.')[1], 'base64url')).sub;
  sql(`INSERT INTO partners (user_id, status, demo_access, updated_at) VALUES ('${uid}', 'active', true, now()) ON CONFLICT (user_id) DO NOTHING`);
  const d = await call('POST', '/demo/accounts', { token, body: { role } });
  return { real: v.json.data, demo: d };
}
