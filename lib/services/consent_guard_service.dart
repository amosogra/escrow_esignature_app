import 'package:flutter/material.dart';
import 'consent_service.dart';
import '../screens/consent_management_screen.dart';

/// Service to guard features that require e-signature consent
class ConsentGuardService {
  static final ConsentGuardService instance = ConsentGuardService._internal();
  ConsentGuardService._internal();

  /// Check if user has active e-signature consent
  /// Returns true if consent is active, false if withdrawn
  Future<bool> hasActiveConsent() async {
    return await ConsentService.instance.hasConsent('esignature');
  }

  /// Guard a feature that requires e-signature consent
  /// If consent is not active, shows dialog and navigates to consent management
  /// Returns true if user has consent and can proceed, false otherwise
  Future<bool> guardFeature(
    BuildContext context, {
    required String featureName,
    String? customMessage,
  }) async {
    final hasConsent = await hasActiveConsent();

    if (!hasConsent) {
      if (!context.mounted) return false;

      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange.shade700),
              const SizedBox(width: 12),
              const Expanded(child: Text('E-Signature Consent Required')),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customMessage ??
                      'To use $featureName, you need to provide electronic signature consent.',
                  style: const TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline,
                            color: Colors.orange.shade700,
                            size: 20
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Current Status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your e-signature consent has been withdrawn. You previously chose to receive documents via paper mail.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'What you can do:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '1. Provide consent again to use electronic features\n'
                  '2. Continue without consent (limited functionality)\n'
                  '3. Contact support for assistance',
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Manage Consent'),
            ),
          ],
        ),
      );

      if (result == true && context.mounted) {
        // Navigate to consent management screen
        final consentProvided = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (context) => const ConsentManagementScreen(),
          ),
        );

        // Check if user provided consent
        if (consentProvided == true) {
          return await hasActiveConsent();
        }
      }

      return false;
    }

    return true;
  }

  /// Show a simple snackbar message when consent is required
  void showConsentRequiredMessage(BuildContext context, String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text('$featureName requires e-signature consent'),
            ),
          ],
        ),
        backgroundColor: Colors.orange,
        action: SnackBarAction(
          label: 'Manage',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConsentManagementScreen(),
              ),
            );
          },
        ),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
