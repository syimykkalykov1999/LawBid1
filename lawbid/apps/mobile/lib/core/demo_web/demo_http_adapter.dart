import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lawbid/core/demo_web/demo_accounts.dart';

/// Build-time switch for the server-less demo: `--dart-define=DEMO_MODE=true`.
/// In that build every API call is answered from `assets/demo/api.json`
/// (responses recorded from the old server's demo world), so the app opens
/// in a browser with no backend. Real flavors never set it.
const bool kDemoMode = bool.fromEnvironment('DEMO_MODE');

/// Answers every [Dio] request from recorded demo data.
///
/// Data layout (`assets/demo/api.json`): `{"attorney": {"GET /feed": body,
/// "GET /feed?limit=20": body, ...}, "client": {...}}`. A request is matched
/// by its exact path+query first, then by path alone. A page request with a
/// `cursor` that was not recorded gets an empty last page, so infinite
/// scrolling stops instead of repeating the first page. Writes succeed and
/// change nothing.
/// Test-server address for the web demo: `?api=https://host/api/v1` in the
/// page link, or `--dart-define=DEMO_SERVER_URL=...` at build time. Empty
/// means the built-in offline data answers every call.
String get demoServerUrl {
  final fromLink = Uri.base.queryParameters['api'];
  if (fromLink != null && fromLink.startsWith('http')) return fromLink;
  return const String.fromEnvironment('DEMO_SERVER_URL');
}

/// True when this demo build talks to [demoServerUrl] instead of the data.
bool get demoUsesServer => kDemoMode && demoServerUrl.isNotEmpty;

class DemoHttpClientAdapter implements HttpClientAdapter {
  DemoHttpClientAdapter();

  static Map<String, dynamic>? _data;
  static String _role = 'attorney';

  static Future<Map<String, dynamic>> _load() async {
    final cached = _data;
    if (cached != null) return cached;
    final raw = await rootBundle.loadString('assets/demo/api.json');
    return _data = jsonDecode(raw) as Map<String, dynamic>;
  }

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final data = await _load();
    final path = options.uri.path.replaceFirst(RegExp('^.*?/api/v1'), '');
    final method = options.method.toUpperCase();
    final body = await _readBody(requestStream);

    final mine = await _accountRoute(method, path, body);
    if (mine != null) return _ok(mine);

    final auth = _auth(method, path, body);
    if (auth != null) return _ok(auth);

    if (method != 'GET') return _ok(_write(data, method, path));

    final i18n = await _i18n(path, options.uri.queryParameters);
    if (i18n != null) return _ok(i18n);

    final role = data[_role] as Map<String, dynamic>? ?? const {};
    final shared = data['shared'] as Map<String, dynamic>? ?? const {};
    final sources = <Map<String, dynamic>>[role, shared];
    final query = _canonicalQuery(options.uri.queryParameters);
    final exact = query.isEmpty ? 'GET $path' : 'GET $path?$query';
    for (final source in sources) {
      final Object? hit = source[exact];
      if (hit != null) return _ok(hit);
    }
    if (options.uri.queryParameters.containsKey('cursor')) {
      return _ok({
        'data': const <Object>[],
        'meta': {'nextCursor': null},
      });
    }
    for (final source in sources) {
      final Object? hit = source['GET $path'];
      if (hit != null) return _ok(hit);
    }
    final similar = _similar(sources, path);
    if (similar != null) return _ok(similar);
    if (_kind(data, path) == 'list') {
      return _ok({
        'data': const <Object>[],
        'meta': {'nextCursor': null},
      });
    }
    return _json(
      404,
      {
        'error': {
          'code': 'NOT_FOUND',
          'message': 'Not available in the demo.',
        },
      },
    );
  }

  static final _idSegment = RegExp(
    r'^([0-9a-fA-F-]{20,}|[0-9]+|c[a-z0-9]{20,})$',
  );

  static bool _hasId(String path) => path.split('/').any(_idSegment.hasMatch);

  /// `list` or `object`, from the API contract (written by enrich.py).
  static String? _kind(Map<String, dynamic> data, String path) {
    final kinds = data['kinds'] as Map<String, dynamic>? ?? const {};
    final parts = path.split('/');
    for (final entry in kinds.entries) {
      final pattern = entry.key.split('/');
      if (pattern.length != parts.length) continue;
      var ok = true;
      for (var i = 0; i < parts.length; i++) {
        if (!pattern[i].startsWith('{') && pattern[i] != parts[i]) {
          ok = false;
          break;
        }
      }
      if (ok) return entry.value as String;
    }
    return null;
  }

  static String _shape(String path) =>
      path.split('/').map((s) => _idSegment.hasMatch(s) ? '*' : s).join('/');

  /// A detail screen opened for an id the recording never saw gets the
  /// recorded detail of the same kind (another post, another profile).
  static Object? _similar(List<Map<String, dynamic>> sources, String path) {
    if (!_hasId(path)) return null;
    final shape = _shape(path);
    for (final source in sources) {
      for (final entry in source.entries) {
        if (!entry.key.startsWith('GET ') || entry.key.contains('?')) continue;
        if (_shape(entry.key.substring(4)) == shape) return entry.value;
      }
    }
    return null;
  }

  static final Map<String, Object> _i18nCache = {};

  /// Languages and bundles come from assets/demo/i18n (generated from
  /// shared/localization by tool/web_preview/gen_demo_i18n.py).
  static Future<Object?> _i18n(String path, Map<String, String> q) async {
    try {
      if (path == '/i18n/languages') {
        final raw =
            await rootBundle.loadString('assets/demo/i18n/languages.json');
        return {'data': jsonDecode(raw)};
      }
      const prefix = '/i18n/bundle/';
      if (path.startsWith(prefix)) {
        final lang = path.substring(prefix.length);
        final since = int.tryParse(q['since'] ?? '');
        if (since != null && since >= 1) {
          return {
            'data': {
              'lang': lang,
              'version': 1,
              'translations': const <String, Object>{}
            },
          };
        }
        final cached = _i18nCache[lang];
        if (cached != null) return cached;
        final raw = await rootBundle.loadString('assets/demo/i18n/$lang.json');
        return _i18nCache[lang] = {
          'data': {
            'lang': lang,
            'version': 1,
            'translations': jsonDecode(raw),
          },
        };
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  /// Sign-in and the account routes of numbers that registered in this
  /// browser (see [DemoAccounts]); null for everything else.
  static Future<Object?> _accountRoute(
    String method,
    String path,
    String body,
  ) async {
    Map<String, dynamic> json() {
      try {
        return jsonDecode(body) as Map<String, dynamic>;
      } catch (_) {
        return const <String, dynamic>{};
      }
    }

    if (method == 'POST' && path == '/auth/otp/verify') {
      final id = (json()['identifier'] as String?) ?? '';
      final acct = await DemoAccounts.signIn(id);
      if (acct == null) return null; // a ready-made account: _auth answers
      final role = DemoAccounts.roleOf(acct);
      if (role == 'client' || role == 'attorney') _role = role!;
      return {
        'data': _tokens(
          sub: acct['id'] as String,
          role: role,
          refresh: 'demo-refresh-${acct['id']}',
          isNewUser: acct['isNew'] == true,
        ),
      };
    }
    if (method == 'POST' && path == '/auth/refresh') {
      final token = (json()['refreshToken'] as String?) ?? '';
      const prefix = 'demo-refresh-';
      if (token.startsWith(prefix)) {
        final sub = token.substring(prefix.length);
        if (DemoAccounts.isCreated(sub)) {
          final acct = await DemoAccounts.select(sub);
          if (acct != null) {
            final role = DemoAccounts.roleOf(acct);
            if (role == 'client' || role == 'attorney') _role = role!;
            return {
              'data': _tokens(sub: sub, role: role, refresh: token),
            };
          }
        }
      }
      await DemoAccounts.select('');
      return null;
    }
    if (method == 'POST' && path == '/demo/invites/redeem') {
      await DemoAccounts.select('');
      return null;
    }
    return DemoAccounts.handle(method, path, json());
  }

  static Future<String> _readBody(Stream<Uint8List>? stream) async {
    if (stream == null) return '';
    final bytes = <int>[];
    await for (final chunk in stream) {
      bytes.addAll(chunk);
    }
    return utf8.decode(bytes, allowMalformed: true);
  }

  static String _canonicalQuery(Map<String, String> q) {
    final keys = q.keys.toList()..sort();
    return keys.map((k) => '$k=${q[k]}').join('&');
  }

  /// Sign-in endpoints: any phone number and the code 000000 get in. The
  /// last digit of the number picks the role (even: attorney, odd: client);
  /// a demo code starting with B opens the client, any other the attorney.
  static Map<String, dynamic>? _auth(String method, String path, String body) {
    if (method != 'POST') return null;
    Map<String, dynamic> json() {
      try {
        return jsonDecode(body) as Map<String, dynamic>;
      } catch (_) {
        return const {};
      }
    }

    switch (path) {
      case '/auth/otp/request':
        return {
          'data': {'sent': true},
        };
      case '/auth/otp/verify':
        final id = (json()['identifier'] as String?) ?? '';
        final last = int.tryParse(id.isEmpty ? '0' : id[id.length - 1]) ?? 0;
        _role = last.isOdd ? 'client' : 'attorney';
        return {'data': _tokensFor(_role)};
      case '/demo/invites/redeem':
        final code = ((json()['code'] as String?) ?? '').toUpperCase();
        _role = code.startsWith('B') ? 'client' : 'attorney';
        return {
          'data': {
            'account': {
              'id': 'demo-$_role',
              'role': _role,
              'displayName': _role == 'client' ? 'Ava Patel' : 'Casey Hughes',
              'createdAt': '2026-10-11T00:00:00.000Z',
              'lastSeenAt': '2026-10-11T00:00:00.000Z',
              'expiresAt': '2099-01-01T00:00:00.000Z',
            },
            'tokens': _tokensFor(_role),
          },
        };
      case '/auth/refresh':
        final token = (json()['refreshToken'] as String?) ?? '';
        if (token.startsWith('demo-refresh-')) {
          _role = token.substring('demo-refresh-'.length);
        }
        return {'data': _tokensFor(_role)};
    }
    return null;
  }

  static Map<String, dynamic> _tokens({
    required String sub,
    required String? role,
    required String refresh,
    bool isNewUser = false,
  }) {
    String b64(Object o) =>
        base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
    final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 900;
    final jwt = [
      b64({'alg': 'none', 'typ': 'JWT'}),
      b64({
        'sub': sub,
        'role': role,
        'sid': 'demo-session',
        'verified': true,
        'subscriptionStatus': 'active',
        'demo': true,
        'typ': 'access',
        'exp': exp,
      }),
      'demo',
    ].join('.');
    return {
      'accessToken': jwt,
      'refreshToken': refresh,
      'accessTokenExpiresIn': 900,
      'isNewUser': isNewUser,
    };
  }

  static Map<String, dynamic> _tokensFor(String role,
          {bool isNewUser = false}) =>
      _tokens(
        sub: 'demo-$role',
        role: role,
        refresh: 'demo-refresh-$role',
        isNewUser: isNewUser,
      );

  /// The answer the API contract promises for a write (written by
  /// enrich.py); an empty envelope when the route is unknown.
  static Object _write(Map<String, dynamic> data, String method, String path) {
    final writes = data['writes'] as Map<String, dynamic>? ?? const {};
    final parts = path.split('/');
    for (final entry in writes.entries) {
      final space = entry.key.indexOf(' ');
      if (entry.key.substring(0, space) != method) continue;
      final pattern = entry.key.substring(space + 1).split('/');
      if (pattern.length != parts.length) continue;
      var ok = true;
      for (var i = 0; i < parts.length; i++) {
        if (!pattern[i].startsWith('{') && pattern[i] != parts[i]) {
          ok = false;
          break;
        }
      }
      if (ok && entry.value != null) return entry.value as Object;
    }
    return <String, dynamic>{'data': <String, dynamic>{}};
  }

  static ResponseBody _ok(Object body) => _json(200, body);

  static ResponseBody _json(int status, Object body) {
    // `demo-asset:<key>` marks a bundled picture or clip; on the web it is
    // served from the same site under `<base>/assets/<key>`.
    final base = Uri.base.removeFragment().resolve('./').toString();
    return ResponseBody.fromString(
      jsonEncode(body).replaceAll('demo-asset:', '${base}assets/'),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json; charset=utf-8'],
      },
    );
  }
}
