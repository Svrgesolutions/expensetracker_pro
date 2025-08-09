import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/account_group_widget.dart';
import './widgets/add_account_button_widget.dart';
import './widgets/bulk_actions_widget.dart';
import './widgets/search_filter_bar_widget.dart';

class AccountManagement extends StatefulWidget {
  const AccountManagement({super.key});

  @override
  State<AccountManagement> createState() => _AccountManagementState;
}

class _AccountManagementState extends State<AccountManagement> {
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _selectedAccounts = [];
  bool _isSelectionMode = false;
  String _searchQuery = '';
  bool _isRefreshing = false;

  // Expanded state for each group
  final Map<String, bool> _groupExpandedState = {
    'Banking': true,
    'Credit Cards': true,
    'Investments': true,
    'Crypto': true,
  };

  // Mock data for accounts
  final List<Map<String, dynamic>> _mockAccounts = [
    {
      "id": 1,
      "institutionName": "Chase Bank",
      "accountName": "Chase Freedom Unlimited",
      "accountType": "Credit Card",
      "balance": "\$2,450.75",
      "connectionStatus": "connected",
      "logoUrl":
          "https://logos-world.net/wp-content/uploads/2021/02/Chase-Logo.png",
      "lastSync": "2 hours ago",
      "group": "Credit Cards"
    },
    {
      "id": 2,
      "institutionName": "First Hawaiian Bank",
      "accountName": "Checking Account",
      "accountType": "Checking",
      "balance": "\$8,234.50",
      "connectionStatus": "connected",
      "logoUrl": "https://www.fhb.com/images/fhb-logo.png",
      "lastSync": "1 hour ago",
      "group": "Banking"
    },
    {
      "id": 3,
      "institutionName": "First Hawaiian Bank",
      "accountName": "Credit Card",
      "accountType": "Credit Card",
      "balance": "-\$1,245.30",
      "connectionStatus": "needs_attention",
      "logoUrl": "https://www.fhb.com/images/fhb-logo.png",
      "lastSync": "6 hours ago",
      "group": "Credit Cards"
    },
    {
      "id": 4,
      "institutionName": "Ally Bank",
      "accountName": "Online Savings",
      "accountType": "Savings",
      "balance": "\$15,678.90",
      "connectionStatus": "connected",
      "logoUrl": "https://www.ally.com/images/ally-logo.png",
      "lastSync": "30 minutes ago",
      "group": "Banking"
    },
    {
      "id": 5,
      "institutionName": "Ally Bank",
      "accountName": "Interest Checking",
      "accountType": "Checking",
      "balance": "\$3,456.78",
      "connectionStatus": "connected",
      "logoUrl": "https://www.ally.com/images/ally-logo.png",
      "lastSync": "30 minutes ago",
      "group": "Banking"
    },
    {
      "id": 6,
      "institutionName": "Edward Jones",
      "accountName": "Roth IRA",
      "accountType": "Retirement",
      "balance": "\$45,234.67",
      "connectionStatus": "connected",
      "logoUrl": "https://www.edwardjones.com/images/ej-logo.png",
      "lastSync": "4 hours ago",
      "group": "Investments"
    },
    {
      "id": 7,
      "institutionName": "Edward Jones",
      "accountName": "Brokerage Account",
      "accountType": "Investment",
      "balance": "\$23,567.89",
      "connectionStatus": "connected",
      "logoUrl": "https://www.edwardjones.com/images/ej-logo.png",
      "lastSync": "4 hours ago",
      "group": "Investments"
    },
    {
      "id": 8,
      "institutionName": "Charles Schwab",
      "accountName": "Brokerage",
      "accountType": "Investment",
      "balance": "\$67,890.12",
      "connectionStatus": "disconnected",
      "logoUrl": "https://www.schwab.com/images/schwab-logo.png",
      "lastSync": "2 days ago",
      "group": "Investments"
    },
    {
      "id": 9,
      "institutionName": "Webull",
      "accountName": "Trading Account",
      "accountType": "Investment",
      "balance": "\$12,345.67",
      "connectionStatus": "connected",
      "logoUrl": "https://www.webull.com/images/webull-logo.png",
      "lastSync": "1 hour ago",
      "group": "Investments"
    },
    {
      "id": 10,
      "institutionName": "Crypto.com",
      "accountName": "Crypto Wallet",
      "accountType": "Crypto",
      "balance": "\$8,765.43",
      "connectionStatus": "connected",
      "logoUrl": "https://crypto.com/images/crypto-logo.png",
      "lastSync": "15 minutes ago",
      "group": "Crypto"
    },
    {
      "id": 11,
      "institutionName": "Venmo",
      "accountName": "Venmo Balance",
      "accountType": "Digital Wallet",
      "balance": "\$234.56",
      "connectionStatus": "connected",
      "logoUrl": "https://venmo.com/images/venmo-logo.png",
      "lastSync": "5 minutes ago",
      "group": "Banking"
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredAccounts = _getFilteredAccounts();
    final groupedAccounts = _groupAccountsByType(filteredAccounts);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Account Management',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          if (_isSelectionMode)
            TextButton(
              onPressed: _clearSelection,
              child: Text(
                'Cancel',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            )
          else
            IconButton(
              icon: CustomIconWidget(
                iconName: 'more_vert',
                size: 24,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: _showMoreOptions,
            ),
        ],
      ),
      body: Column(
        children: [
          SearchFilterBarWidget(
            searchController: _searchController,
            searchHint: 'Search accounts, institutions...',
            onFilterTap: _showFilterOptions,
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query.toLowerCase();
              });
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshAllAccounts,
              child: _buildAccountsList(groupedAccounts),
            ),
          ),
          BulkActionsWidget(
            selectedAccounts: _selectedAccounts,
            onRefreshSelected: _refreshSelectedAccounts,
            onExportSelected: _exportSelectedAccounts,
            onOrganizeSelected: _organizeSelectedAccounts,
            onClearSelection: _clearSelection,
          ),
        ],
      ),
      floatingActionButton: _isSelectionMode
          ? null
          : AddAccountButtonWidget(
              isFloating: true,
              onPressed: _addNewAccount,
            ),
    );
  }

  Widget _buildAccountsList(
      Map<String, List<Map<String, dynamic>>> groupedAccounts) {
    if (groupedAccounts.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: EdgeInsets.only(bottom: 10.h),
      itemCount: groupedAccounts.keys.length,
      itemBuilder: (context, index) {
        final groupTitle = groupedAccounts.keys.elementAt(index);
        final accounts = groupedAccounts[groupTitle]!;

        return AccountGroupWidget(
          groupTitle: groupTitle,
          accounts: accounts,
          isExpanded: _groupExpandedState[groupTitle] ?? true,
          onToggleExpanded: () => _toggleGroupExpanded(groupTitle),
          onAccountTap: _handleAccountTap,
          onAccountRefresh: _refreshAccount,
          onViewTransactions: _viewAccountTransactions,
          onAccountSettings: _showAccountSettings,
          onAccountDisconnect: _disconnectAccount,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'account_balance_wallet',
              size: 80,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: 3.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No accounts found'
                  : 'No accounts connected',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try adjusting your search terms'
                  : 'Connect your first account to get started with expense tracking',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isEmpty) ...[
              SizedBox(height: 4.h),
              AddAccountButtonWidget(
                onPressed: _addNewAccount,
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredAccounts() {
    if (_searchQuery.isEmpty) {
      return _mockAccounts;
    }

    return _mockAccounts.where((account) {
      final institutionName =
          (account["institutionName"] as String).toLowerCase();
      final accountName = (account["accountName"] as String).toLowerCase();
      final accountType = (account["accountType"] as String).toLowerCase();

      return institutionName.contains(_searchQuery) ||
          accountName.contains(_searchQuery) ||
          accountType.contains(_searchQuery);
    }).toList();
  }

  Map<String, List<Map<String, dynamic>>> _groupAccountsByType(
      List<Map<String, dynamic>> accounts) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final account in accounts) {
      final group = account["group"] as String;
      if (!grouped.containsKey(group)) {
        grouped[group] = [];
      }
      grouped[group]!.add(account);
    }

    // Sort groups by predefined order
    final orderedGroups = <String, List<Map<String, dynamic>>>{};
    const groupOrder = ['Banking', 'Credit Cards', 'Investments', 'Crypto'];

    for (final group in groupOrder) {
      if (grouped.containsKey(group)) {
        orderedGroups[group] = grouped[group]!;
      }
    }

    // Add any remaining groups
    for (final entry in grouped.entries) {
      if (!orderedGroups.containsKey(entry.key)) {
        orderedGroups[entry.key] = entry.value;
      }
    }

    return orderedGroups;
  }

  void _toggleGroupExpanded(String groupTitle) {
    setState(() {
      _groupExpandedState[groupTitle] =
          !(_groupExpandedState[groupTitle] ?? true);
    });
  }

  void _handleAccountTap(Map<String, dynamic> account) {
    if (_isSelectionMode) {
      _toggleAccountSelection(account);
    } else {
      _viewAccountDetails(account);
    }
  }

  void _toggleAccountSelection(Map<String, dynamic> account) {
    setState(() {
      final isSelected =
          _selectedAccounts.any((selected) => selected["id"] == account["id"]);
      if (isSelected) {
        _selectedAccounts
            .removeWhere((selected) => selected["id"] == account["id"]);
      } else {
        _selectedAccounts.add(account);
      }

      if (_selectedAccounts.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedAccounts.clear();
      _isSelectionMode = false;
    });
  }

  void _viewAccountDetails(Map<String, dynamic> account) {
    Navigator.pushNamed(context, '/transaction-list', arguments: account);
  }

  void _refreshAccount(Map<String, dynamic> account) {
    // Simulate account refresh
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Refreshing ${account["accountName"]}...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _viewAccountTransactions(Map<String, dynamic> account) {
    Navigator.pushNamed(context, '/transaction-list', arguments: account);
  }

  void _showAccountSettings(Map<String, dynamic> account) {
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
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                '${account["accountName"]} Settings',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Edit Account Name'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Notification Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'sync',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Sync Frequency'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'link_off',
                size: 24,
                color: Theme.of(context).colorScheme.error,
              ),
              title: const Text('Disconnect Account'),
              onTap: () {
                Navigator.pop(context);
                _disconnectAccount(account);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _disconnectAccount(Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Disconnect Account'),
        content: Text(
          'Are you sure you want to disconnect ${account["accountName"]}? This will stop syncing transactions and remove the account from your dashboard.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _mockAccounts.removeWhere((acc) => acc["id"] == account["id"]);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${account["accountName"]} disconnected'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        _mockAccounts.add(account);
                      });
                    },
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Disconnect'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshAllAccounts() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All accounts refreshed successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _refreshSelectedAccounts() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Refreshing ${_selectedAccounts.length} selected accounts...'),
        duration: const Duration(seconds: 2),
      ),
    );
    _clearSelection();
  }

  void _exportSelectedAccounts() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Exporting data for ${_selectedAccounts.length} accounts...'),
        duration: const Duration(seconds: 2),
      ),
    );
    _clearSelection();
  }

  void _organizeSelectedAccounts() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Organizing ${_selectedAccounts.length} accounts...'),
        duration: const Duration(seconds: 2),
      ),
    );
    _clearSelection();
  }

  void _addNewAccount() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: 70.h,
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
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Add New Account',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            SizedBox(height: 3.h),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                children: [
                  _buildInstitutionOption('Chase Bank', 'chase'),
                  _buildInstitutionOption('Bank of America', 'boa'),
                  _buildInstitutionOption('Wells Fargo', 'wells_fargo'),
                  _buildInstitutionOption('Citi', 'citi'),
                  _buildInstitutionOption('Capital One', 'capital_one'),
                  _buildInstitutionOption('American Express', 'amex'),
                  _buildInstitutionOption('Discover', 'discover'),
                  _buildInstitutionOption('Ally Bank', 'ally'),
                  _buildInstitutionOption('Charles Schwab', 'schwab'),
                  _buildInstitutionOption('Fidelity', 'fidelity'),
                  _buildInstitutionOption('Vanguard', 'vanguard'),
                  _buildInstitutionOption('Other Institution', 'other'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstitutionOption(String name, String code) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: ListTile(
        leading: Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: 'account_balance',
            size: 24,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: CustomIconWidget(
          iconName: 'chevron_right',
          size: 24,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        onTap: () {
          Navigator.pop(context);
          _initiateAccountConnection(name, code);
        },
      ),
    );
  }

  void _initiateAccountConnection(String institutionName, String code) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connect to $institutionName'),
        content: const Text(
          'You will be redirected to your bank\'s secure login page to authorize the connection. ExpenseTracker Pro uses bank-level security to protect your information.',
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
                SnackBar(
                  content: Text('Connecting to $institutionName...'),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
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
                'Filter Accounts',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'account_balance',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Account Type'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                size: 24,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'link',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Connection Status'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                size: 24,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'business',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Institution'),
              trailing: CustomIconWidget(
                iconName: 'chevron_right',
                size: 24,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions() {
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
            ListTile(
              leading: CustomIconWidget(
                iconName: 'select_all',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Select Multiple'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _isSelectionMode = true;
                });
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'sync',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Refresh All'),
              onTap: () {
                Navigator.pop(context);
                _refreshAllAccounts();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'settings',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Account Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/settings');
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}