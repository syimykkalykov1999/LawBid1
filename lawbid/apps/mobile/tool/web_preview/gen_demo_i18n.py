"""Builds assets/demo/i18n/*.json from shared/localization (xlsx + native names).

Same shape the API serves: languages.json and <code>.json (translations map).
Run from apps/mobile: python3 tool/web_preview/gen_demo_i18n.py
Needs openpyxl.
"""
import glob, json, os, re, sys
import openpyxl

root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..', '..'))
src = os.path.join(root, 'shared', 'localization')
out = os.path.join(root, 'apps', 'mobile', 'assets', 'demo', 'i18n')
os.makedirs(out, exist_ok=True)

bundles = {}  # code -> {key: text}
order = []

def load(path):
    wb = openpyxl.load_workbook(path, read_only=True)
    for ws in wb:
        rows = ws.iter_rows(values_only=True)
        head = next(rows, None)
        if not head or head[0] != 'key':
            continue
        for r in rows:
            if not r or not r[0]:
                continue
            for i, code in enumerate(head[1:], 1):
                if code and i < len(r) and r[i]:
                    if code not in bundles:
                        bundles[code] = {}
                        order.append(code)
                    bundles[code][str(r[0])] = str(r[i])

load(os.path.join(src, 'lawbid-app-translations.xlsx'))
for p in sorted(glob.glob(os.path.join(src, '*.xlsx'))):
    if not p.endswith('lawbid-app-translations.xlsx'):
        load(p)

names = {'en': ('English', False), 'ru': ('Русский', False)}
sql = open(os.path.join(src, 'set_language_names.sql'), encoding='utf-8').read()
for m in re.finditer(r"name_native = '([^']*)', is_rtl = (true|false) WHERE code = '([^']+)'", sql):
    names[m.group(3)] = (m.group(1), m.group(2) == 'true')

langs = []
for i, code in enumerate(order):
    n, rtl = names.get(code, (code, False))
    langs.append({'code': code, 'name_native': n, 'is_active': True, 'is_rtl': rtl, 'sort': i})
    json.dump(bundles[code], open(os.path.join(out, f'{code}.json'), 'w', encoding='utf-8'), ensure_ascii=False, separators=(',', ':'))
json.dump(langs, open(os.path.join(out, 'languages.json'), 'w', encoding='utf-8'), ensure_ascii=False, separators=(',', ':'))
print(f'{len(langs)} languages, {len(bundles["en"])} keys', file=sys.stderr)
