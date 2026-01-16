import 'package:flutter/material.dart';
import '../services/backend_service.dart';
import 'anchor_setup_screen.dart';

class AccountSetupCompleteScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const AccountSetupCompleteScreen({super.key, required this.userData});

  @override
  State<AccountSetupCompleteScreen> createState() => _AccountSetupCompleteScreenState();
}

class _AccountSetupCompleteScreenState extends State<AccountSetupCompleteScreen> {
  bool _isRegistering = false;
  bool _registrationComplete = false;

  @override
  void initState() {
    super.initState();
    _registerUser();
  }

  Future<void> _registerUser() async {
    setState(() {
      _isRegistering = true;
    });

    try {
      await BackendService.instance.registerUser(widget.userData);

      setState(() {
        _isRegistering = false;
        _registrationComplete = true;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isRegistering = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating account: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isRegistering) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Creating your account...'),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Success Icon
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 80,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Title
                  const Text(
                    'Account Setup Complete!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Welcome, ${widget.userData['firstName']}! Your account is ready.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Summary Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account Summary',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoRow(Icons.person, 'Name', '${widget.userData['firstName']} ${widget.userData['lastName']}'),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.email, 'Email', widget.userData['email']),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.phone, 'Phone', widget.userData['phone']),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.account_circle, 'Account Type', widget.userData['accountType']),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.check_circle, 'E-Signature Consent', 'Accepted'),
                        const SizedBox(height: 12),
                        _buildInfoRow(Icons.description, 'Terms of Service', 'Accepted'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Next Steps
                  ElevatedButton(
                    onPressed: _registrationComplete ? _handleGetStarted : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Setup Anchor Account',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleGetStarted() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const AnchorSetupScreen(),
      ),
      (route) => false,
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
