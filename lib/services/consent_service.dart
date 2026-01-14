import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ConsentService {
  static final ConsentService instance = ConsentService._internal();
  ConsentService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save consent record with timestamp
  Future<void> saveConsent({
    required String consentType,
    required bool consentGiven,
    String? ipAddress,
  }) async {
    final consentRecord = {
      'type': consentType,
      'given': consentGiven,
      'timestamp': DateTime.now().toIso8601String(),
      'ipAddress': ipAddress ?? 'unknown',
    };

    // Save to shared preferences
    final key = 'consent_$consentType';
    await _prefs.setString(key, jsonEncode(consentRecord));

    // Also add to consent history
    final history = await getConsentHistory();
    history.add(consentRecord);
    await _prefs.setString('consent_history', jsonEncode(history));
  }

  /// Get a specific consent record
  Future<Map<String, dynamic>?> getConsent(String consentType) async {
    final key = 'consent_$consentType';
    final consentJson = _prefs.getString(key);
    
    if (consentJson != null) {
      return jsonDecode(consentJson) as Map<String, dynamic>;
    }
    return null;
  }

  /// Get all consent history
  Future<List<Map<String, dynamic>>> getConsentHistory() async {
    final historyJson = _prefs.getString('consent_history');
    
    if (historyJson != null) {
      final List<dynamic> decoded = jsonDecode(historyJson);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }

  /// Check if a specific consent has been given
  Future<bool> hasConsent(String consentType) async {
    final consent = await getConsent(consentType);
    return consent != null && consent['given'] == true;
  }

  /// Withdraw consent
  Future<void> withdrawConsent(String consentType) async {
    await saveConsent(
      consentType: consentType,
      consentGiven: false,
    );
  }

  /// Clear all consents (for testing/demo purposes)
  Future<void> clearAllConsents() async {
    await _prefs.remove('consent_history');
    final keys = _prefs.getKeys().where((key) => key.startsWith('consent_'));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}
