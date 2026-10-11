// Ходит по старому приложению (демо-аккаунт) и нажимает на кнопки; прокси serve_record.mjs пишет ответы сервера.
// node explore.mjs <код приглашения> <число нажатий>
import { open } from '../old-stand/lib.mjs';
const code = process.argv[2] ?? 'AAAAAAAA';
const budget = Number(process.argv[3] ?? 200);
const BAD = /exit|log ?out|sign ?out|delete|remove|block|report|deactivate|выйти|удалить/i;
const { b, p } = await open();
await p.getByText('I have a demo code').click(); await p.waitForTimeout(2000);
await p.keyboard.type(code, { delay: 50 });
await p.getByRole('button', { name: 'Enter' }).click(); await p.waitForTimeout(8000);
const seen = new Set();
const nav = [[55, 800], [131, 800], [258, 800], [335, 800]];
const items = () => p.evaluate(() => [...document.querySelectorAll('flt-semantics[role=button],flt-semantics[role=switch],flt-semantics[role=tab],flt-semantics[role=link]')].map((e) => {
  const r = e.getBoundingClientRect();
  return { l: (e.getAttribute('aria-label') || e.textContent || '').slice(0, 60), x: r.x + r.width / 2, y: r.y + r.height / 2, w: r.width, h: r.height };
}).filter((i) => !(i.y < 60 && i.x > 240 && i.x < 340) && i.l.trim() !== '' && i.w > 8 && i.h > 8 && i.x > 0 && i.x < 390 && i.y > 0 && i.y < 844));
for (let n = 0; n < budget; n++) {
  const url = p.url();
  const list = (await items()).filter((i) => !BAD.test(i.l));
  const key = (i) => url + '|' + i.l;
  let pick = list.find((i) => !seen.has(key(i)) && i.y < 770);
  if (!pick) {
    // nothing new here: scroll, else go back, else jump to a tab
    await p.mouse.move(195, 400); await p.mouse.wheel(0, 700); await p.waitForTimeout(900);
    const again = (await items()).filter((i) => !BAD.test(i.l) && !seen.has(url + '|' + i.l) && i.y < 770);
    if (again.length === 0) {
      if (n % 3 === 0) { const t = nav[(n / 3 | 0) % nav.length]; await p.mouse.click(t[0], t[1]); }
      else await p.goBack().catch(() => {});
      await p.waitForTimeout(1500);
    }
    continue;
  }
  seen.add(key(pick));
  console.log(n, url.replace('http://localhost:8090', ''), '->', pick.l.replace(/\n/g, ' '));
  await p.mouse.click(pick.x, pick.y);
  await p.waitForTimeout(1300);
}
await b.close();
