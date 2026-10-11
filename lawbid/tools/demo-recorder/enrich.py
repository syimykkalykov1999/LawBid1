"""Fills the empty parts of assets/demo/api.json with believable content.

Run after build-dataset.mjs:
  python3 tools/demo-recorder/enrich.py apps/mobile/assets/demo/api.json /tmp/old_api.json
(second argument: an earlier dataset whose feed still had posts).
Photos and the clip are bundled files, written as `demo-asset:<path>` and
turned into real URLs by DemoHttpClientAdapter.
Video: rabbit320.mp4 (Big Buck Bunny clip, CC BY 3.0, Blender Foundation).
"""
import copy, json, os, random, re, sys, uuid

path, old_path = sys.argv[1], sys.argv[2]
D = json.load(open(path))
OLD = json.load(open(old_path))
random.seed(7)
ART = os.path.join(os.path.dirname(os.path.abspath(path)), '..', 'practice_art')
art = set(os.listdir(ART))
NOW = '2026-10-11T18:00:00.000Z'

def uid(*parts):
    return str(uuid.uuid5(uuid.NAMESPACE_URL, 'lawbid-demo/' + '/'.join(map(str, parts))))

def iso(hours_ago):
    import datetime
    t = datetime.datetime(2026, 10, 11, 18, 0, tzinfo=datetime.timezone.utc) - datetime.timedelta(hours=hours_ago)
    return t.strftime('%Y-%m-%dT%H:%M:%S.000Z')

def empty(v):
    x = v.get('data') if isinstance(v, dict) else v
    return x == [] or x == {} or x is None

def shape(k):
    return re.sub(r'[0-9a-f]{8}-[0-9a-f-]{27}', '*', k.split('?')[0])

# ---------- posts ----------
base = copy.deepcopy(OLD['client']['GET /feed']['data'])
VIDEO = {2, 5, 8, 11, 14, 17}
PHOTO = {0, 4, 9, 13, 18}
CAROUSEL = {1, 6, 10, 15}

def pics(cat, n):
    names = [f for f in (f'{cat}.jpg', f'{cat}_2.jpg', f'{cat}_3.jpg') if f in art]
    return names[:n]

COMMENTS = [
    ('Thank you, this is exactly what I needed to read today.', 4),
    ('Does this also apply if the other side lives in a different state?', 2),
    ('Saved. Sending it to a friend who is going through this now.', 6),
    ('Clear and practical. More posts like this please.', 9),
    ('Great reminder. Documents first, emotions second.', 3),
    ('How long does this usually take from start to finish?', 1),
    ('I wish I had known this a year ago.', 7),
    ('Can I message you about my situation?', 0),
]

def photo_media(cat, n, idx):
    out = []
    for pos, name in enumerate(pics(cat, n)):
        u = f'demo-asset:assets/practice_art/{name}'
        out.append({'fileId': uid('media', idx, pos), 'position': pos, 'width': 1080, 'height': 720,
                    'url': u, 'previewUrl': u, 'mediumUrl': u})
    return out

def make_posts(role):
    me = D[role].get('GET /users/me', {}).get('data', {})
    posts = copy.deepcopy(base)
    for i, p in enumerate(posts):
        cat = (p.get('practice') or {}).get('categoryCode') or 'family_law'
        if i in PHOTO:
            p['media'] = photo_media(cat, 1, i)
        elif i in CAROUSEL:
            p['media'] = photo_media(cat, 3, i)
        elif i in VIDEO:
            thumb = (pics(cat, 1) or [None])[0]
            p['video'] = {'status': 'ready', 'playbackUrl': 'demo-asset:assets/demo/video/rabbit320.mp4',
                          'thumbnailUrl': f'demo-asset:assets/practice_art/{thumb}' if thumb else None,
                          'durationSec': 10, 'width': 320, 'height': 176, 'trimStartMs': None, 'trimEndMs': None}
        p['commentCount'] = 4 + (i % 3)
        p['createdAt'] = iso(3 + i * 7)
        if role == 'attorney' and i in (3, 8, 12) and me.get('id'):
            p['author'] = {'id': me['id'], 'role': 'attorney', 'username': me.get('username', 'casey.hughes'),
                           'firstName': me.get('firstName'), 'lastName': me.get('lastName'), 'avatarUrl': None,
                           'verifiedBadge': True, 'isFollowing': False}
            p['isMine'] = True
    return posts

def page(items):
    return {'data': items, 'meta': {'nextCursor': None}}

def comments_for(post, n):
    out = []
    for j in range(n):
        body, likes = COMMENTS[(hash_i(post['id']) + j) % len(COMMENTS)]
        au = post['author']
        out.append({'id': uid('c', post['id'], j), 'postId': post['id'], 'parentCommentId': None,
                    'author': {'kind': 'client' if j % 2 else 'attorney', 'attorneyId': None if j % 2 else au['id'],
                               'username': ['ava.patel', 'noah.kim', 'liam.ortiz', 'maya.cohen'][j % 4],
                               'displayName': ['Ava Patel', 'Noah Kim', 'Liam Ortiz', 'Maya Cohen'][j % 4],
                               'avatarUrl': None, 'verifiedBadge': False},
                    'body': body, 'mentions': [], 'likeCount': likes, 'replyCount': 0, 'likedByMe': False,
                    'canDelete': False, 'isMine': False, 'createdAt': iso(2 + j * 5)})
    return out

def hash_i(s):
    return sum(map(ord, s))

TAGS = ['divorce', 'familylaw', 'immigration', 'legaltips', 'realestate', 'estateplanning', 'criminaldefense', 'injury']
for role in ('attorney', 'client'):
    m = D[role]
    posts = make_posts(role)
    reels = [p for p in posts if p['video']]
    m['GET /feed'] = page(posts)
    m['GET /reels'] = page(reels)
    m['GET /search/latest-posts'] = page(posts)
    m['GET /search/posts'] = page(posts)
    m['GET /saved-items/posts'] = page([dict(p, savedByMe=True) for p in posts[:4]])
    m['GET /search/trending-tags'] = {'data': [{'tag': t, 'postsCount': 40 - i * 4} for i, t in enumerate(TAGS)], 'meta': {'nextCursor': None}}
    m['GET /search/tags'] = {'data': [{'tag': t, 'postsCount': 10 + i} for i, t in enumerate(TAGS)]}
    for t in TAGS:
        tagged = [p for p in posts if t in p['tags']] or posts[:6]
        m[f'GET /tags/{t}/posts'] = page(tagged)
    for p in posts:
        m[f'GET /posts/{p["id"]}'] = {'data': p}
        m[f'GET /posts/{p["id"]}/comments'] = page(comments_for(p, p['commentCount']))
    authors = {p['author']['id'] for p in posts}
    for k in list(m):
        mm = re.match(r'GET /attorneys/([0-9a-f-]{36})/posts', k)
        if mm and empty(m[k]):
            mine = [p for p in posts if p['author']['id'] == mm.group(1)] or posts[:5]
            m[k] = page(mine)
    # a post detail for ids never recorded: any post will do (adapter shape fallback)

# ---------- chat messages ----------
LINES = [
    ('them', 'Hello! I read your case summary and I think I can help.'),
    ('me', 'Thank you for getting back to me so quickly.'),
    ('them', 'Could you tell me the date of the first notice you received?'),
    ('me', 'It arrived on September 3rd by mail.'),
    ('them', 'Good. Please upload the notice and any emails you have about it.'),
    ('me', 'Done, I uploaded three documents just now.'),
    ('them', 'Received. I can call you Friday at 10 to go through the next steps.'),
    ('me', 'Friday at 10 would be great, thank you.'),
]
for role in ('attorney', 'client'):
    m = D[role]
    me = m.get('GET /users/me', {}).get('data', {}).get('id')
    for k in [k for k in m if k.startswith('GET /conversations') and isinstance(m[k].get('data'), list)]:
        for c in [x for x in m[k]['data'] if 'counterpart' in x]:
            cid, other = c['id'], c['counterpart']['id']
            msgs = []
            for j, (who, body) in enumerate(LINES):
                msgs.append({'id': uid('m', cid, j), 'conversationId': cid, 'senderId': me if who == 'me' else other,
                             'sentByAssistant': None, 'type': 'text', 'voice': None, 'attachment': None, 'sticker': None,
                             'call': None, 'body': body, 'contactMasked': False, 'clientMessageId': uid('cm', cid, j),
                             'createdAt': iso(30 - j * 3)})
            m[f'GET /conversations/{cid}/messages'] = page(list(reversed(msgs)))

# ---------- fill every other empty list from a same-shaped full one ----------
donors = {}
for role in ('attorney', 'client'):
    for k, v in D[role].items():
        if k.startswith('GET ') and not empty(v):
            donors.setdefault(shape(k), v)
filled = 0
for role in ('attorney', 'client'):
    for k, v in D[role].items():
        if k.startswith('GET ') and empty(v) and isinstance(v, dict) and isinstance(v.get('data'), list):
            d = donors.get(shape(k))
            if d:
                D[role][k] = copy.deepcopy(d)
                filled += 1

# ---------- lists with no donor ----------
TEMPLATES = [
    ('Fee agreement (hourly)', 'Plain-language hourly fee agreement with retainer terms.', 'fee_agreement.docx'),
    ('Demand letter', 'First demand letter for a money or property claim.', 'demand_letter.docx'),
    ('Residential lease', 'Standard residential lease with state-specific clauses.', 'residential_lease.pdf'),
    ('Power of attorney', 'General durable power of attorney.', 'power_of_attorney.pdf'),
    ('Settlement agreement', 'Mutual release and settlement agreement.', 'settlement_agreement.docx'),
]
for role in ('attorney', 'client'):
    m = D[role]
    tpl = [{'id': uid('tpl', i), 'title': t, 'description': d, 'fileName': f, 'mime': 'application/pdf' if f.endswith('pdf') else 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'sizeBytes': 48000 + i * 9000, 'practiceAreaId': None, 'practiceAreaKey': None, 'practiceAreaName': 'General', 'state': None,
            'language': 'en', 'audience': 'attorney', 'downloadCount': 120 - i * 17, 'updatedAt': iso(200 + i * 24), 'locked': False}
           for i, (t, d, f) in enumerate(TEMPLATES)]
    for k in [k for k in m if k.startswith('GET /document-templates') and empty(m[k])]:
        m[k] = page(tpl)
    if role == 'attorney':
        m['GET /payments/history'] = page([{
            'id': uid('pay', i), 'caseId': None, 'caseTitle': ct, 'kind': 'case_payment', 'requestId': None, 'status': 'paid',
            'amountCents': a, 'platformFeeCents': a // 20, 'processingFeeCents': a // 30, 'clientTotalCents': a + a // 30,
            'attorneyNetCents': a - a // 20, 'processingFeePayer': 'client', 'refundedCents': 0, 'currency': 'USD', 'note': None,
            'receiptUrl': None, 'disputeStatus': None, 'paidAt': iso(60 + i * 90), 'createdAt': iso(70 + i * 90),
            'client': {'id': uid('cl', i), 'name': n, 'username': n.lower().replace(' ', '.'), 'avatarUrl': None},
            'attorney': {'id': uid('at'), 'name': 'Casey Hughes', 'username': 'casey.hughes', 'avatarUrl': None}, 'refundable': False}
            for i, (ct, a, n) in enumerate([('Custody modification: ex relocating out of state', 250000, 'Ava Patel'),
                                           ('Lease dispute with landlord', 120000, 'Noah Kim'),
                                           ('Will and trust for a young family', 180000, 'Maya Cohen')])])
        m['GET /team/activity'] = page([{
            'id': uid('act', i), 'membershipId': uid('mem'), 'assistantName': 'Jordan Lee', 'action': a, 'targetType': 'case',
            'targetId': None, 'summary': s, 'createdAt': iso(5 + i * 20)}
            for i, (a, s) in enumerate([('bid_drafted', 'Drafted a bid for a custody case'), ('message_sent', 'Replied to a client message'), ('task_completed', 'Completed: send engagement letter')])])
    m['GET /support/tickets'] = page([{'id': uid('tk', 1), 'subject': 'How do I change my practice areas?', 'category': 'account',
                                       'status': 'resolved', 'unread': False, 'lastMessageAt': iso(100), 'createdAt': iso(120),
                                       'resolvedAt': iso(99), 'canReply': False}])

# which GET paths answer with a list (empty page is a valid answer) or an object
o = json.load(open(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', '..', 'packages', 'api-contract', 'openapi.json')))
def rschema(sc, depth=0):
    while '$ref' in sc and depth < 6:
        sc = o['components']['schemas'][sc['$ref'].split('/')[-1]]; depth += 1
    if 'allOf' in sc:
        merged = {'properties': {}}
        for x in sc['allOf']:
            merged['properties'].update(rschema(x, depth + 1).get('properties', {}))
        return merged
    return sc
kinds = {}
for pth, v in o['paths'].items():
    g = v.get('get')
    if not g: continue
    r = g['responses'].get('200')
    try:
        sc = rschema(r['content']['application/json']['schema'])
        data = rschema(sc['properties']['data'])
        kinds[pth.replace('/api/v1', '')] = 'list' if data.get('type') == 'array' else 'object'
    except Exception:
        pass
D['kinds'] = kinds

json.dump(D, open(path, 'w'), ensure_ascii=False, separators=(',', ':'))
print('donor-filled', filled, 'size', os.path.getsize(path))
