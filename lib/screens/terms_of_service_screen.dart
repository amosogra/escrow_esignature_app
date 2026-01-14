import 'package:flutter/material.dart';

class TermsOfServiceScreen extends StatefulWidget {
  final VoidCallback onAccept;
  final VoidCallback onBack;

  const TermsOfServiceScreen({
    super.key,
    required this.onAccept,
    required this.onBack,
  });

  @override
  State<TermsOfServiceScreen> createState() => _TermsOfServiceScreenState();
}

class _TermsOfServiceScreenState extends State<TermsOfServiceScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToBottom = false;
  bool _acceptedTerms = false;

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
                const Text(
                  'Terms of Service',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please review our platform terms',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                
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
                      _buildSection('1. Acceptance of Terms', 
                        'By using our Escrow Platform, you agree to these Terms of Service and all applicable laws and regulations.'),
                      const SizedBox(height: 16),
                      _buildSection('2. Account Registration',
                        'You must provide accurate information during registration. You are responsible for maintaining the security of your account.'),
                      const SizedBox(height: 16),
                      _buildSection('3. Escrow Services',
                        'Our platform facilitates secure transactions between buyers and sellers. We hold funds until both parties fulfill their obligations.'),
                      const SizedBox(height: 16),
                      _buildSection('4. Fees and Payments',
                        'Transaction fees will be clearly disclosed before each transaction. Fees are non-refundable once a transaction is initiated.'),
                      const SizedBox(height: 16),
                      _buildSection('5. Dispute Resolution',
                        'In case of disputes, our team will mediate between parties. Final decisions will be made based on evidence provided.'),
                      const SizedBox(height: 16),
                      _buildSection('6. Privacy Policy',
                        'We respect your privacy and protect your personal information according to our Privacy Policy.'),
                      const SizedBox(height: 16),
                      _buildSection('7. Limitation of Liability',
                        'Our platform is not liable for losses arising from user disputes, fraud, or external factors beyond our control.'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
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
                            'Please scroll down to read all terms',
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
              CheckboxListTile(
                value: _acceptedTerms,
                enabled: _hasScrolledToBottom,
                onChanged: (value) {
                  setState(() {
                    _acceptedTerms = value ?? false;
                  });
                },
                title: const Text(
                  'I accept the Terms of Service',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              
              const SizedBox(height: 16),
              
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
                      onPressed: _acceptedTerms ? widget.onAccept : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Accept & Continue',
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
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        Text(content, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
      ],
    );
  }
}
