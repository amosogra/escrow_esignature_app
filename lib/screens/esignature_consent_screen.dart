import 'package:flutter/material.dart';
import '../services/consent_service.dart';
import '../services/ip_service.dart';
import 'privacy_policy_screen.dart';

class ESignatureConsentScreen extends StatefulWidget {
  final VoidCallback onConsent;
  final VoidCallback onBack;

  const ESignatureConsentScreen({
    super.key,
    required this.onConsent,
    required this.onBack,
  });

  @override
  State<ESignatureConsentScreen> createState() => _ESignatureConsentScreenState();
}

class _ESignatureConsentScreenState extends State<ESignatureConsentScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToBottom = false;
  bool _agreedToConsent = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 20) {
      if (!_hasScrolledToBottom) {
        setState(() {
          _hasScrolledToBottom = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Electronic Signature Consent',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please read this important information carefully',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                
                const SizedBox(height: 24),
                
                // Consent Text in a Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[50],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSection(
                        '1. Consent to Conduct Business Electronically',
                        'By clicking "I Agree" below, you consent to:\n\n'
                        '• Electronically sign documents and agreements\n'
                        '• Receive all communications, documents, and disclosures electronically\n'
                        '• Conduct all transactions through our electronic platform\n\n'
                        'This consent applies to:\n'
                        '• Anchor account opening documents and agreements\n'
                        '• Escrow transaction agreements between buyers and sellers\n'
                        '• Payment authorizations and ACH agreements\n'
                        '• Platform Terms of Service and Privacy Policy\n'
                        '• All other documents related to your use of our services',
                      ),
                      
                      const Divider(height: 32),
                      
                      _buildSection(
                        '2. Hardware and Software Requirements',
                        'To access and retain electronic records, you will need:\n\n'
                        '• A computer, tablet, or smartphone with internet access\n'
                        '• A current web browser (Chrome, Safari, Firefox, or Edge) or our mobile app\n'
                        '• Sufficient storage space to save documents or a printer to print them\n'
                        '• A valid email address that you check regularly\n'
                        '• PDF reader software (such as Adobe Acrobat Reader) for some documents',
                      ),
                      
                      const Divider(height: 32),
                      
                      _buildSection(
                        '3. Right to Withdraw Consent',
                        'You have the right to withdraw this consent at any time by:\n\n'
                        '• Emailing us at: support@escrowplatform.com\n'
                        '• Calling us at: 1-800-555-0123\n'
                        '• Visiting Account Settings > Electronic Signature Consent\n\n'
                        'If you withdraw consent:\n'
                        '• We will provide paper copies of documents going forward\n'
                        '• Previous electronic transactions remain valid\n'
                        '• No fees will be charged for withdrawal\n'
                        '• You may need to complete certain actions in person or via mail',
                      ),
                      
                      const Divider(height: 32),
                      
                      _buildSection(
                        '4. Right to Request Paper Copies',
                        'You may request paper copies of any electronic document at no charge by:\n\n'
                        '• Emailing: support@escrowplatform.com\n'
                        '• Calling: 1-800-555-0123\n'
                        '• Through your account dashboard\n\n'
                        'We will provide paper copies within 5 business days at no cost.',
                      ),
                      
                      const Divider(height: 32),
                      
                      _buildSection(
                        '5. How to Update Your Contact Information',
                        'You must keep your email address and contact information current. To update:\n\n'
                        '• Log into your account and visit Account Settings\n'
                        '• Email us at: support@escrowplatform.com\n'
                        '• Call us at: 1-800-555-0123\n\n'
                        'If we send you an electronic communication and it is returned as undeliverable, '
                        'we may provide notice via paper mail.',
                      ),
                      
                      const Divider(height: 32),
                      
                      _buildSection(
                        '6. Confirmation',
                        'By providing your consent below, you confirm that:\n\n'
                        '• You can access and read this disclosure\n'
                        '• You have read and understood this disclosure\n'
                        '• You have the required hardware and software to access electronic records\n'
                        '• You consent to conduct business electronically',
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),

                // Privacy Policy Link
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.privacy_tip_outlined),
                    label: const Text('View Privacy Policy'),
                  ),
                ),

                const SizedBox(height: 16),

                // Scroll indicator
                if (!_hasScrolledToBottom)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_downward, color: Colors.blue.shade700, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Please scroll down to read the entire disclosure',
                            style: TextStyle(color: Colors.blue.shade700, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        
        // Bottom Action Area
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Consent Checkbox
              CheckboxListTile(
                value: _agreedToConsent,
                enabled: _hasScrolledToBottom,
                onChanged: (value) {
                  setState(() {
                    _agreedToConsent = value ?? false;
                  });
                },
                title: const Text(
                  'I have read and agree to conduct this transaction electronically',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: const Text(
                  'You can request paper copies at any time',
                  style: TextStyle(fontSize: 12),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              
              const SizedBox(height: 16),
              
              // Buttons Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onBack,
                      child: const Text('Back'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _agreedToConsent && !_isSaving
                          ? _handleConsent
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'I Agree - Continue',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[800],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Future<void> _handleConsent() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // Get IP address
      final ipAddress = await IpService.instance.getIpAddress();

      // Save consent record
      await ConsentService.instance.saveConsent(
        consentType: 'esignature',
        consentGiven: true,
        ipAddress: ipAddress,
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Electronic signature consent recorded'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Small delay to show the success message
        await Future.delayed(const Duration(milliseconds: 500));
        
        widget.onConsent();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving consent: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
}
