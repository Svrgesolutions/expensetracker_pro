import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/app_info_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_row_widget.dart';
import './widgets/settings_section_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Mock user data
  final Map<String, dynamic> userData = {
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "profileImage":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
    "isPremium": true,
    "memberSince": "January 2023",
  };

  // Settings state
  bool _biometricEnabled = true;
  bool _transactionAlerts = true;
  bool _budgetWarnings = true;
  bool _connectionIssues = true;
  bool _marketingEmails = false;
  bool _pushNotifications = true;
  String _appLockTimeout = "5 minutes";
  String _dataExportFormat = "CSV";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.h),

            // Profile Header
            ProfileHeaderWidget(
              userName: userData["name"] as String,
              userEmail: userData["email"] as String,
              profileImageUrl: userData["profileImage"] as String?,
              onTap: () => _showProfileEdit(context),
            ),

            // Account Section
            SettingsSectionWidget(
              title: 'Account',
              children: [
                SettingsRowWidget(
                  title: 'Profile Information',
                  subtitle: 'Update your personal details',
                  iconName: 'person',
                  onTap: () => _showProfileEdit(context),
                ),
                SettingsRowWidget(
                  title: 'Connected Accounts',
                  subtitle: '8 accounts connected',
                  iconName: 'account_balance',
                  type: SettingsRowType.value,
                  valueText: '8 linked',
                  onTap: () =>
                      Navigator.pushNamed(context, '/account-management'),
                ),
                SettingsRowWidget(
                  title: 'Subscription',
                  subtitle: 'Premium - Active until Dec 2024',
                  iconName: 'workspace_premium',
                  type: SettingsRowType.value,
                  valueText: 'Premium',
                  onTap: () => _showSubscriptionDetails(context),
                  showDivider: false,
                ),
              ],
            ),

            // Security Section
            SettingsSectionWidget(
              title: 'Security',
              children: [
                SettingsRowWidget(
                  title: 'Biometric Authentication',
                  subtitle: 'Use Face ID or fingerprint to unlock',
                  iconName: 'fingerprint',
                  type: SettingsRowType.toggle,
                  switchValue: _biometricEnabled,
                  onToggle: (value) =>
                      setState(() => _biometricEnabled = value),
                ),
                SettingsRowWidget(
                  title: 'App Lock Timeout',
                  subtitle: 'Auto-lock after inactivity',
                  iconName: 'lock_clock',
                  type: SettingsRowType.value,
                  valueText: _appLockTimeout,
                  onTap: () => _showTimeoutOptions(context),
                ),
                SettingsRowWidget(
                  title: 'Two-Factor Authentication',
                  subtitle: 'Add extra security to your account',
                  iconName: 'security',
                  onTap: () => _showTwoFactorSetup(context),
                  showDivider: false,
                ),
              ],
            ),

            // Notifications Section
            SettingsSectionWidget(
              title: 'Notifications',
              children: [
                SettingsRowWidget(
                  title: 'Push Notifications',
                  subtitle: 'Receive app notifications',
                  iconName: 'notifications',
                  type: SettingsRowType.toggle,
                  switchValue: _pushNotifications,
                  onToggle: (value) =>
                      setState(() => _pushNotifications = value),
                ),
                SettingsRowWidget(
                  title: 'Transaction Alerts',
                  subtitle: 'Get notified of new transactions',
                  iconName: 'receipt',
                  type: SettingsRowType.toggle,
                  switchValue: _transactionAlerts,
                  onToggle: (value) =>
                      setState(() => _transactionAlerts = value),
                ),
                SettingsRowWidget(
                  title: 'Budget Warnings',
                  subtitle: 'Alert when approaching budget limits',
                  iconName: 'warning',
                  type: SettingsRowType.toggle,
                  switchValue: _budgetWarnings,
                  onToggle: (value) => setState(() => _budgetWarnings = value),
                ),
                SettingsRowWidget(
                  title: 'Connection Issues',
                  subtitle: 'Notify when accounts need reconnection',
                  iconName: 'sync_problem',
                  type: SettingsRowType.toggle,
                  switchValue: _connectionIssues,
                  onToggle: (value) =>
                      setState(() => _connectionIssues = value),
                ),
                SettingsRowWidget(
                  title: 'Marketing Emails',
                  subtitle: 'Receive product updates and tips',
                  iconName: 'email',
                  type: SettingsRowType.toggle,
                  switchValue: _marketingEmails,
                  onToggle: (value) => setState(() => _marketingEmails = value),
                  showDivider: false,
                ),
              ],
            ),

            // Data & Privacy Section
            SettingsSectionWidget(
              title: 'Data & Privacy',
              children: [
                SettingsRowWidget(
                  title: 'Export Data',
                  subtitle: 'Download your financial data',
                  iconName: 'download',
                  type: SettingsRowType.value,
                  valueText: _dataExportFormat,
                  onTap: () => _showExportOptions(context),
                ),
                SettingsRowWidget(
                  title: 'Data Usage',
                  subtitle: 'View how your data is used',
                  iconName: 'analytics',
                  onTap: () => _showDataUsage(context),
                ),
                SettingsRowWidget(
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account and data',
                  iconName: 'delete_forever',
                  isDestructive: true,
                  iconColor: theme.colorScheme.error,
                  onTap: () => _showDeleteAccountDialog(context),
                  showDivider: false,
                ),
              ],
            ),

            // Support Section
            SettingsSectionWidget(
              title: 'Support',
              children: [
                SettingsRowWidget(
                  title: 'Help Center',
                  subtitle: 'FAQs and tutorials',
                  iconName: 'help',
                  onTap: () => _showHelpCenter(context),
                ),
                SettingsRowWidget(
                  title: 'Contact Support',
                  subtitle: 'Get help from our team',
                  iconName: 'support_agent',
                  onTap: () => _showContactSupport(context),
                ),
                SettingsRowWidget(
                  title: 'Send Feedback',
                  subtitle: 'Help us improve the app',
                  iconName: 'feedback',
                  onTap: () => _showFeedbackForm(context),
                  showDivider: false,
                ),
              ],
            ),

            // App Info
            AppInfoWidget(
              appVersion: '2.1.4',
              buildNumber: '2024.08.09',
            ),

            // Logout Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'logout',
                      color: theme.colorScheme.onError,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Sign Out',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onError,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 4.h),
          ],
        ),
      ),
    );
  }

  void _showProfileEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 3.h),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                    ),
                    controller:
                        TextEditingController(text: userData["name"] as String),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'Enter your email',
                    ),
                    controller: TextEditingController(
                        text: userData["email"] as String),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Profile updated successfully')),
                            );
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscriptionDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Premium Subscription'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Premium subscription includes:'),
            SizedBox(height: 1.h),
            const Text('• Unlimited account connections'),
            const Text('• Advanced analytics and insights'),
            const Text('• Custom categories and budgets'),
            const Text('• Priority customer support'),
            const Text('• Data export in multiple formats'),
            SizedBox(height: 2.h),
            Text(
              'Next billing: December 9, 2024',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Manage Subscription'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTimeoutOptions(BuildContext context) {
    final options = [
      'Immediately',
      '1 minute',
      '5 minutes',
      '15 minutes',
      '30 minutes',
      'Never'
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'App Lock Timeout',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            ...options.map((option) => ListTile(
                  title: Text(option),
                  trailing: _appLockTimeout == option
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Theme.of(context).colorScheme.primary,
                          size: 5.w,
                        )
                      : null,
                  onTap: () {
                    setState(() => _appLockTimeout = option);
                    Navigator.pop(context);
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showTwoFactorSetup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Two-Factor Authentication'),
        content: const Text(
          'Two-factor authentication adds an extra layer of security to your account. You\'ll need to enter a code from your authenticator app when signing in.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Two-factor authentication setup started')),
              );
            },
            child: const Text('Set Up'),
          ),
        ],
      ),
    );
  }

  void _showExportOptions(BuildContext context) {
    final formats = ['CSV', 'PDF', 'Excel', 'JSON'];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Text(
                'Export Format',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            ...formats.map((format) => ListTile(
                  title: Text(format),
                  trailing: _dataExportFormat == format
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Theme.of(context).colorScheme.primary,
                          size: 5.w,
                        )
                      : null,
                  onTap: () {
                    setState(() => _dataExportFormat = format);
                    Navigator.pop(context);
                    _startDataExport(format);
                  },
                )),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _startDataExport(String format) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Preparing $format export... You\'ll be notified when ready.'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showDataUsage(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data Usage'),
        content: const Text(
          'We use your financial data to:\n\n• Categorize transactions automatically\n• Provide spending insights and trends\n• Generate budgets and financial reports\n• Sync data across your devices\n\nYour data is encrypted and never shared with third parties.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: TextStyle(color: Theme.of(context).colorScheme.error),
        ),
        content: const Text(
          'This action cannot be undone. All your financial data, connected accounts, and settings will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalDeleteConfirmation(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation(BuildContext context) {
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Final Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Type "DELETE" to confirm account deletion:'),
            SizedBox(height: 2.h),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                hintText: 'Type DELETE here',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (confirmController.text == 'DELETE') {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Account deletion initiated. You will receive a confirmation email.'),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Confirm Delete'),
          ),
        ],
      ),
    );
  }

  void _showHelpCenter(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Help Center')),
          body: ListView(
            padding: EdgeInsets.all(4.w),
            children: [
              _buildHelpItem(
                  'Getting Started', 'Learn the basics of ExpenseTracker Pro'),
              _buildHelpItem(
                  'Connecting Accounts', 'How to link your bank accounts'),
              _buildHelpItem(
                  'Managing Categories', 'Organize your transactions'),
              _buildHelpItem(
                  'Setting Budgets', 'Create and track spending limits'),
              _buildHelpItem(
                  'Understanding Reports', 'Make sense of your financial data'),
              _buildHelpItem('Troubleshooting', 'Common issues and solutions'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpItem(String title, String subtitle) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 5.w,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Opening help for: $title')),
          );
        },
      ),
    );
  }

  void _showContactSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 50.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Support',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  SizedBox(height: 3.h),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'email',
                      color: Theme.of(context).colorScheme.primary,
                      size: 6.w,
                    ),
                    title: const Text('Email Support'),
                    subtitle: const Text('support@expensetrackerPro.com'),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Opening email client...')),
                      );
                    },
                  ),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'chat',
                      color: Theme.of(context).colorScheme.primary,
                      size: 6.w,
                    ),
                    title: const Text('Live Chat'),
                    subtitle: const Text('Available 9 AM - 6 PM EST'),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Starting live chat...')),
                      );
                    },
                  ),
                  ListTile(
                    leading: CustomIconWidget(
                      iconName: 'phone',
                      color: Theme.of(context).colorScheme.primary,
                      size: 6.w,
                    ),
                    title: const Text('Phone Support'),
                    subtitle: const Text('1-800-EXPENSE (Premium only)'),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Dialing support number...')),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFeedbackForm(BuildContext context) {
    final TextEditingController feedbackController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Send Feedback',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Help us improve ExpenseTracker Pro by sharing your thoughts and suggestions.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    SizedBox(height: 3.h),
                    Expanded(
                      child: TextField(
                        controller: feedbackController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: 'Tell us what you think...',
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Thank you for your feedback!')),
                              );
                            },
                            child: const Text('Send'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text(
            'Are you sure you want to sign out? You\'ll need to sign in again to access your account.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                  context, '/dashboard', (route) => false);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
