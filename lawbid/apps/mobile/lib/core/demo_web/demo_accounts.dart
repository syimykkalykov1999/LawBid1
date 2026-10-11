import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Accounts created in the web demo, kept in the browser (localStorage via
/// shared_preferences): a new phone number walks the whole sign-up
/// (consents, role, profile, ...) and signing in with the same number later
/// opens the same account. Two numbers and the demo codes AAAAAAAA /
/// BBBBBBBB are "existing" accounts with ready-made data.
class DemoAccounts {
  static const _key = 'demo.accounts';
  static Map<String, dynamic>? _db;
  static String? _currentId;

  /// Digits of the numbers that open a ready-made account.
  static const knownAttorney = '5550000000';
  static const knownClient = '5550000001';

  static Future<Map<String, dynamic>> _load() async {
    final cached = _db;
    if (cached != null) return cached;
    try {
      final raw = (await SharedPreferences.getInstance()).getString(_key);
      if (raw != null) {
        return _db = jsonDecode(raw) as Map<String, dynamic>;
      }
    } catch (_) {}
    return _db = <String, dynamic>{'byIdentifier': <String, dynamic>{}};
  }

  static Future<void> _save() async {
    try {
      await (await SharedPreferences.getInstance())
          .setString(_key, jsonEncode(_db));
    } catch (_) {}
  }

  static Map<String, dynamic>? _acct(Map<String, dynamic> db, String? id) {
    final accounts = db['accounts'] as Map<String, dynamic>?;
    return id == null ? null : accounts?[id] as Map<String, dynamic>?;
  }

  /// The signed-in created account's role for the recorded data maps.
  static String? get currentId => _currentId;

  static bool isCreated(String? sub) =>
      sub != null && sub.startsWith('demo-u-');

  /// Selects the account a refresh token belongs to.
  static Future<Map<String, dynamic>?> select(String sub) async {
    final db = await _load();
    final a = _acct(db, sub);
    _currentId = a == null ? null : sub;
    return a;
  }

  /// OTP verify. Returns the account (created when new) or null for the
  /// ready-made ones.
  static Future<Map<String, dynamic>?> signIn(String identifier) async {
    final digits = identifier.replaceAll(RegExp('[^0-9]'), '');
    if (digits.endsWith(knownAttorney) || digits.endsWith(knownClient)) {
      _currentId = null;
      return null;
    }
    final db = await _load();
    final byId = db['byIdentifier'] as Map<String, dynamic>;
    final accounts =
        (db['accounts'] ??= <String, dynamic>{}) as Map<String, dynamic>;
    var id = byId[digits] as String?;
    if (id == null) {
      id =
          'demo-u-${accounts.length + 1}-${DateTime.now().millisecondsSinceEpoch % 100000}';
      byId[digits] = id;
      accounts[id] = <String, dynamic>{
        'id': id,
        'phone': identifier,
        'role': null,
        'firstName': '',
        'lastName': '',
        'consents': false,
        'currentStep': null,
        'completedAt': null,
        'profile': null,
        'isNew': true,
      };
      await _save();
    }
    _currentId = id;
    return accounts[id] as Map<String, dynamic>;
  }

  static String? roleOf(Map<String, dynamic>? a) => a?['role'] as String?;

  static Map<String, dynamic> me(Map<String, dynamic> a) {
    final role = a['role'] as String?;
    final profile = a['profile'] as Map<String, dynamic>?;
    final first = (a['firstName'] as String?) ?? '';
    final last = (a['lastName'] as String?) ?? '';
    final missing = <String>[
      if (a['consents'] != true) 'consents',
      if (role == null) 'role',
      if (role != null && first.isEmpty) 'name',
      if (role == 'client' && profile == null) 'profile',
      if (role == 'attorney' && profile == null) 'profile',
    ];
    final username = '${first.isEmpty ? 'user' : first.toLowerCase()}'
            '${last.isEmpty ? '' : '.${last.toLowerCase()}'}'
        .replaceAll(RegExp('[^a-z0-9.]'), '');
    return {
      'id': a['id'],
      'role': role,
      'status': 'active',
      'firstName': first.isEmpty ? null : first,
      'lastName': last.isEmpty ? null : last,
      'email': '${a['id']}@demo.lawbid.invalid',
      'emailVerified': true,
      'phone': a['phone'],
      'phoneVerified': true,
      'uiLanguage': a['uiLanguage'] ?? 'en',
      'theme': 'system',
      'avatarFileId': null,
      'avatarUrl': null,
      'requiredConsentsGranted': a['consents'] == true,
      'pendingLegalDocuments': const <Object>[],
      'onboarding': {
        'currentStep': a['currentStep'],
        'completedAt': a['completedAt'],
        'data': null,
      },
      'profile': profile == null
          ? null
          : {
              'username':
                  '$username${a['id'].toString().hashCode.abs() % 90 + 10}',
              ...profile,
            },
      'missing': missing,
    };
  }

  /// Account routes. Returns the response body, or null when [path] is not
  /// an account route (or no created account is signed in).
  static Future<Object?> handle(
    String method,
    String path,
    Map<String, dynamic> body,
  ) async {
    final db = await _load();
    final a = _acct(db, _currentId);
    if (a == null) return null;
    final m = method.toUpperCase();
    Object result() => {'data': me(a)};
    switch ('$m $path') {
      case 'GET /users/me':
        return result();
      case 'POST /users/me/consents':
        a['consents'] = true;
        await _save();
        return {
          'data': {'saved': true},
        };
      case 'POST /users/me/role':
        a['role'] = body['role'];
        await _save();
        return result();
      case 'PATCH /users/me/onboarding':
        final step = body['currentStep'];
        if (step is String) a['currentStep'] = step;
        final p = body['profile'];
        if (p is Map<String, dynamic>) {
          if (p['firstName'] != null) a['firstName'] = p['firstName'];
          if (p['lastName'] != null) a['lastName'] = p['lastName'];
          final rest = Map<String, dynamic>.from(p)
            ..remove('firstName')
            ..remove('lastName');
          if (a['role'] == 'attorney') {
            rest.putIfAbsent('verificationStatus', () => 'unverified');
            rest['licensedStates'] ??= const <Object>[];
          }
          a['profile'] = rest;
        }
        await _save();
        return result();
      case 'PATCH /users/me/profile':
        for (final k in ['firstName', 'lastName', 'uiLanguage']) {
          if (body[k] != null) a[k] = body[k];
        }
        await _save();
        return result();
      case 'POST /users/me/onboarding/complete':
        a['completedAt'] = DateTime.now().toUtc().toIso8601String();
        await _save();
        return result();
    }
    return null;
  }
}
