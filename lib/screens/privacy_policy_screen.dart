import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Updated: ${DateTime.now().year}-01-01',
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
                  _buildSection(
                    '1. Information We Collect',
                    'We collect information you provide directly to us, including:\n\n'
                    '• Personal identification information (name, email, phone number)\n'
                    '• Account credentials and authentication data\n'
                    '• Transaction and payment information\n'
                    '• Communication preferences\n'
                    '• IP address and device information\n'
                    '• Electronic signature consent records',
                  ),
                  const Divider(height: 32),
                  _buildSection(
                    '2. How We Use Your Information',
                    'We use the information we collect to:\n\n'
                    '• Provide, maintain, and improve our escrow services\n'
                    '• Process transactions and send related information\n'
                    '• Send technical notices and support messages\n'
                    '• Respond to your comments and questions\n'
                    '• Comply with legal obligations and enforce our terms\n'
                    '• Detect and prevent fraud and security incidents',
                  ),
                  const Divider(height: 32),
                  _buildSection(
                    '3. Information Sharing',
                    'We may share your information with:\n\n'
                    '• Service providers who assist in our operations\n'
                    '• Payment processors (including Anchor by Stripe)\n'
                    '• Law enforcement when required by law\n'
                    '• Other parties with your consent\n\n'
                    'We do not sell your personal information to third parties.',
                  ),
                  const Divider(height: 32),
                  _buildSection(
                    '4. Data Security',
                    'We implement appropriate technical and organizational measures to protect your personal information, including:\n\n'
                    '• Encryption of data in transit and at rest\n'
                    '• Regular security assessments\n'
                    '• Access controls and authentication\n'
                    '• Employee training on data protection\n\n'
                    'However, no method of transmission over the Internet is 100% secure.',
                  ),
                  const Divider(height: 32),
                  _buildSection(
                    '5. Data Retention',
                    'We retain your personal information for as long as necessary to:\n\n'
                    '• Provide our services to you\n'
                    '• Comply with legal obligations\n'
                    '• Resolve disputes and enforce agreements\n'
                    '• Meet regulatory requirements (typically 7 years for financial records)',
                  ),
                  const Divider(height: 32),
                  _buildSection(
                    '6. Your Rights',
                    'You have the right to:\n\n'
                    '• Access your personal information\n'
                    '• Correct inaccurate information\n'
                    '• Request deletion of your information\n'
                    '• Object to processing of your information\n'
                    '• Request data portability\n'
                    '• Withdraw consent at any time\n\n'
                    'To exercise these rights, contact us at privacy@escrowplatform.com',
                  ),
                  const Divider(height: 32),
                  _buildSection(
                    '7. Cookies and Tracking',
                    'We use cookies and similar tracking technologies to:\n\n'
                    '• Remember your preferences\n'
                    '• Understand how you use our platform\n'
                    '• Improve our services\n\n'
                    'You can control cookies through your browser settings.',
                  ),
                  const Divider(height: 32),
                  _buildSection(
                    '8. Third-Party Services',
                    'Our platform integrates with third-party services:\n\n'
                    '• Anchor by Stripe for payment processing\n'
                    '• Analytics providers for service improvement\n\n'
                    'These services have their own privacy policies governing the use of your information.',
                  ),
                  const Divider(height: 32),
                  _buildSection(
                    '9. Children\'s Privacy',
                    'Our services are not directed to individuals under 18 years of age. We do not knowingly collect personal information from children. If we learn that we have collected information from a child, we will delete it promptly.',
                  ),
                  const Divider(height: 32),
                  _buildSection(
                    '10. Changes to This Policy',
                    'We may update this Privacy Policy from time to time. We will notify you of any changes by:\n\n'
                    '• Posting the new policy on this page\n'
                    '• Updating the "Last Updated" date\n'
                    '• Sending you an email notification for material changes\n\n'
                    'Your continued use of our services after changes constitutes acceptance.',
                  ),
                  const Divider(height: 32),
                  _buildSection(
                    '11. Contact Us',
                    'If you have questions about this Privacy Policy, please contact us:\n\n'
                    '• Email: privacy@escrowplatform.com\n'
                    '• Phone: 1-800-555-0123\n'
                    '• Mail: Escrow Platform Inc., 123 Main Street, Suite 100, San Francisco, CA 94105',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
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
}
