import 'package:flutter/material.dart';
import '../services/backend_service.dart';
import '../services/consent_service.dart';
import '../services/consent_guard_service.dart';
import 'welcome_screen.dart';
import 'anchor_setup_screen.dart';
import 'privacy_policy_screen.dart';
import 'consent_management_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _anchorAccount;
  bool _isLoading = true;
  bool _hasConsent = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    final user = await BackendService.instance.getCurrentUser();
    final anchorAccount = await BackendService.instance.getAnchorAccount();
    final hasConsent = await ConsentService.instance.hasConsent('esignature');

    setState(() {
      _user = user;
      _anchorAccount = anchorAccount;
      _hasConsent = hasConsent;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_user == null) {
      return const WelcomeScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _handleLogout,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadUserData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome Card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade700, Colors.blue.shade500],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_user!['firstName']} ${_user!['lastName']}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle,
                          color: Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _user!['accountType'] ?? 'User',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Account Status
              const Text(
                'Account Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              _buildStatusCard(
                'Profile',
                'Complete',
                Icons.check_circle,
                Colors.green,
              ),

              const SizedBox(height: 12),

              _buildStatusCard(
                'E-Signature Consent',
                _hasConsent ? 'Accepted' : 'Withdrawn',
                _hasConsent ? Icons.draw : Icons.warning_amber,
                _hasConsent ? Colors.green : Colors.orange,
                onTap: !_hasConsent ? _handleManageConsent : null,
              ),

              const SizedBox(height: 12),

              _buildStatusCard(
                'Anchor Account',
                _anchorAccount != null ? 'Connected' : 'Not Connected',
                _anchorAccount != null ? Icons.account_balance : Icons.error_outline,
                _anchorAccount != null ? Colors.green : Colors.orange,
                onTap: _anchorAccount == null ? _handleSetupAnchorAccount : null,
              ),

              const SizedBox(height: 24),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: _buildActionCard(
                      'New Transaction',
                      Icons.add_circle_outline,
                      Colors.blue,
                      _handleNewTransaction,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionCard(
                      'Transactions',
                      Icons.list_alt,
                      Colors.purple,
                      () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transaction history coming soon'),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Account Details
              const Text(
                'Account Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(Icons.email, 'Email', _user!['email']),
                    const Divider(height: 24),
                    _buildDetailRow(Icons.phone, 'Phone', _user!['phone']),
                    const Divider(height: 24),
                    _buildDetailRow(
                      Icons.calendar_today,
                      'Member Since',
                      _formatDate(_user!['createdAt']),
                    ),
                    if (_anchorAccount != null) ...[
                      const Divider(height: 24),
                      _buildDetailRow(
                        Icons.account_balance,
                        'Bank Account',
                        '****${_anchorAccount!['accountNumberLast4']}',
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Settings & Links
              const Text(
                'Settings & Support',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              _buildSettingsItem(
                Icons.privacy_tip_outlined,
                'Privacy Policy',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
              ),

              _buildSettingsItem(
                Icons.description_outlined,
                'Terms of Service',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Terms of Service screen'),
                    ),
                  );
                },
              ),

              _buildSettingsItem(
                Icons.help_outline,
                'Help & Support',
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Support: 1-800-555-0123'),
                    ),
                  );
                },
              ),

              _buildSettingsItem(
                Icons.draw_outlined,
                'E-Signature Consent',
                _handleManageConsent,
              ),

              _buildSettingsItem(
                Icons.delete_outline,
                'Clear Demo Data',
                () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Clear All Data'),
                      content: const Text(
                        'This will delete all demo data including your account. Are you sure?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Clear Data',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await BackendService.instance.clearAllData();
                    await ConsentService.instance.clearAllConsents();

                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WelcomeScreen(),
                        ),
                        (route) => false,
                      );
                    }
                  }
                },
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(
    String title,
    String status,
    IconData icon,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    status,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
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

  Widget _buildSettingsItem(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(color: color),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    return '${date.month}/${date.day}/${date.year}';
  }

  void _handleManageConsent() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConsentManagementScreen(),
      ),
    ).then((_) => _loadUserData()); // Refresh dashboard when returning
  }

  Future<void> _handleNewTransaction() async {
    // Check if user has e-signature consent
    final canProceed = await ConsentGuardService.instance.guardFeature(
      context,
      featureName: 'New Transaction',
      customMessage: 'Creating escrow transactions requires electronic signature consent to sign agreements digitally.',
    );

    if (canProceed) {
      // User has consent, proceed with transaction creation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction creation coming soon'),
          ),
        );
      }
    }
    // If not, the guard already showed the dialog and handled navigation
  }

  Future<void> _handleSetupAnchorAccount() async {
    // Check if user has e-signature consent
    final canProceed = await ConsentGuardService.instance.guardFeature(
      context,
      featureName: 'Anchor Account Setup',
      customMessage: 'Setting up an Anchor account requires electronic signature consent to sign ACH authorization agreements.',
    );

    if (canProceed && mounted) {
      // User has consent, proceed with Anchor setup
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AnchorSetupScreen(),
        ),
      ).then((_) => _loadUserData());
    }
    // If not, the guard already showed the dialog and handled navigation
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await BackendService.instance.logout();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const WelcomeScreen(),
          ),
          (route) => false,
        );
      }
    }
  }
}
