import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart' show rootBundle;

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

    final auth = _auth(method, path, body);
    if (auth != null) return _ok(auth);

    if (method != 'GET') return _ok(_write(method, path));

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
        return {'data': _tokens(_role, isNewUser: false)};
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
            'tokens': _tokens(_role),
          },
        };
      case '/auth/refresh':
        final token = (json()['refreshToken'] as String?) ?? '';
        if (token.startsWith('demo-refresh-')) {
          _role = token.substring('demo-refresh-'.length);
        }
        return {'data': _tokens(_role)};
    }
    return null;
  }

  static Map<String, dynamic> _tokens(String role, {bool? isNewUser}) {
    String b64(Object o) =>
        base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
    final exp = DateTime.now().millisecondsSinceEpoch ~/ 1000 + 900;
    final jwt = [
      b64({'alg': 'none', 'typ': 'JWT'}),
      b64({
        'sub': 'demo-$role',
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
      'refreshToken': 'demo-refresh-$role',
      'accessTokenExpiresIn': 900,
      if (isNewUser != null) 'isNewUser': isNewUser,
    };
  }

  static Object _write(String method, String path) => {
        'data': <String, dynamic>{},
      };

  static ResponseBody _ok(Object body) => _json(200, body);

  static ResponseBody _json(int status, Object body) {
    return ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json; charset=utf-8'],
      },
    );
  }
}
