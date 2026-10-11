import { chromium } from '/opt/node22/lib/node_modules/playwright/index.mjs';
export async function open(dark=false) {
  const b = await chromium.launch({ executablePath: '/opt/pw-browsers/chromium', args:['--no-sandbox','--use-gl=swiftshader','--enable-unsafe-swiftshader'] });
  const p = await b.newPage({ viewport: { width: 390, height: 844 }, deviceScaleFactor: 2, colorScheme: dark?'dark':'light' });
  await p.goto('http://localhost:8090/', { waitUntil: 'load' });
  await p.waitForTimeout(8000);
  await p.evaluate(() => document.querySelector('flt-semantics-placeholder')?.click());
  await p.waitForTimeout(1500);
  return { b, p };
}
export const labels = (p) => p.evaluate(() => [...document.querySelectorAll('flt-semantics')].map(e=>(e.getAttribute('role')||'')+':'+(e.getAttribute('aria-label')||e.textContent).slice(0,80)).filter(x=>x.length>1).slice(0,40));
