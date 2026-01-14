import 'package:flutter/material.dart';
import '../services/consent_service.dart';
import 'esignature_consent_screen.dart';

class ConsentManagementScreen extends StatefulWidget {
  const ConsentManagementScreen({super.key});

  @override
  State<ConsentManagementScreen> createState() => _ConsentManagementScreenState();
}

class _ConsentManagementScreenState extends State<ConsentManagementScreen> {
  Map<String, dynamic>? _consentRecord;
  bool _hasConsent = false;
  bool _isLoading = true;
  List<Map<String, dynamic>> _consentHistory = [];

  @override
  void initState() {
    super.initState();
    _loadConsentData();
  }

  Future<void> _loadConsentData() async {
    setState(() {
      _isLoading = true;
    });

    final hasConsent = await ConsentService.instance.hasConsent('esignature');
    final consentRecord = await ConsentService.instance.getConsent('esignature');
    final history = await ConsentService.instance.getConsentHistory();

    setState(() {
      _hasConsent = hasConsent;
      _consentRecord = consentRecord;
      _consentHistory = history.where((h) => h['type'] == 'esignature').toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Signature Consent'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Current Status Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _hasConsent ? Colors.green.shade50 : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _hasConsent ? Colors.green.shade200 : Colors.red.shade200,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          _hasConsent ? Icons.check_circle : Icons.cancel,
                          size: 60,
                          color: _hasConsent ? Colors.green : Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _hasConsent ? 'Consent Active' : 'Consent Withdrawn',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _hasConsent ? Colors.green.shade800 : Colors.red.shade800,
                          ),
                        ),
                        if (_consentRecord != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Last Updated: ${_formatDateTime(_consentRecord!['timestamp'])}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Current Consent Details
                  if (_consentRecord != null) ...[
                    const Text(
                      'Current Consent Details',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow(
                            'Status',
                            _consentRecord!['given'] ? 'Accepted' : 'Withdrawn',
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            'Date & Time',
                            _formatDateTime(_consentRecord!['timestamp']),
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            'IP Address',
                            _consentRecord!['ipAddress'],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Actions
                  const Text(
                    'Actions',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  if (_hasConsent)
                    ElevatedButton.icon(
                      onPressed: _handleWithdrawConsent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.cancel),
                      label: const Text(
                        'Withdraw Consent',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      onPressed: _handleReConsent,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      icon: const Icon(Icons.check_circle),
                      label: const Text(
                        'Provide Consent Again',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),

                  const SizedBox(height: 16),

                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Contact: support@escrowplatform.com or 1-800-555-0123'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.contact_support),
                    label: const Text('Request Paper Copies'),
                  ),

                  const SizedBox(height: 24),

                  // Information Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info_outline, color: Colors.blue.shade700),
                            const SizedBox(width: 8),
                            Text(
                              'About E-Signature Consent',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade700,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'This consent allows you to:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Electronically sign documents\n'
                          '• Receive communications digitally\n'
                          '• Conduct transactions online',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'If you withdraw consent:',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• You will receive paper copies of documents\n'
                          '• No fees will be charged for withdrawal\n'
                          '• Previous electronic transactions remain valid\n'
                          '• Some actions may need to be completed in person or via mail',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Consent History
                  if (_consentHistory.length > 1) ...[
                    const Text(
                      'Consent History',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ..._consentHistory.reversed.map((record) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                record['given'] ? Icons.check_circle : Icons.cancel,
                                color: record['given'] ? Colors.green : Colors.red,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      record['given'] ? 'Consent Accepted' : 'Consent Withdrawn',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      _formatDateTime(record['timestamp']),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.month}/${date.day}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _handleWithdrawConsent() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Withdraw Consent'),
        content: const Text(
          'Are you sure you want to withdraw your electronic signature consent?\n\n'
          'You will need to handle documents via paper mail going forward.\n\n'
          'You can provide consent again at any time.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Withdraw Consent',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ConsentService.instance.withdrawConsent('esignature');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('E-signature consent has been withdrawn'),
            backgroundColor: Colors.orange,
          ),
        );
        _loadConsentData();
      }
    }
  }

  Future<void> _handleReConsent() async {
    // Navigate to full consent screen
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ESignatureConsentScreen(
          onConsent: () {
            Navigator.pop(context, true);
          },
          onBack: () {
            Navigator.pop(context, false);
          },
        ),
      ),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('E-signature consent has been provided'),
          backgroundColor: Colors.green,
        ),
      );
      _loadConsentData();
    }
  }
}
