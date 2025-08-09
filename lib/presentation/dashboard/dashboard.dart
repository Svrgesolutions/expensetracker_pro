import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/account_balance_overview.dart';
import './widgets/net_worth_card.dart';
import './widgets/quick_action_card.dart';
import './widgets/recent_transaction_item.dart';
import './widgets/spending_summary_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  bool _isRefreshing = false;
  DateTime _lastUpdated = DateTime.now();
  late AnimationController _refreshController;

  // Mock data for dashboard
  final List<Map<String, dynamic>> _recentTransactions = [
    {
      'id': 1,
      'merchant': 'Starbucks Coffee',
      'amount': 5.47,
      'category': 'Food & Dining',
      'categoryIcon': 'restaurant',
      'account': 'Chase Freedom',
      'type': 'expense',
      'date': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': 2,
      'merchant': 'Salary Deposit',
      'amount': 3250.00,
      'category': 'Income',
      'categoryIcon': 'attach_money',
      'account': 'First Hawaiian Bank',
      'type': 'income',
      'date': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': 3,
      'merchant': 'Amazon Purchase',
      'amount': 89.99,
      'category': 'Shopping',
      'categoryIcon': 'shopping_cart',
      'account': 'Chase Sapphire',
      'type': 'expense',
      'date': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': 4,
      'merchant': 'Shell Gas Station',
      'amount': 42.15,
      'category': 'Transportation',
      'categoryIcon': 'local_gas_station',
      'account': 'Chase Freedom',
      'type': 'expense',
      'date': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'id': 5,
      'merchant': 'Netflix Subscription',
      'amount': 15.99,
      'category': 'Entertainment',
      'categoryIcon': 'movie',
      'account': 'First Hawaiian Bank',
      'type': 'expense',
      'date': DateTime.now().subtract(const Duration(days: 4)),
    },
  ];

  final List<Map<String, dynamic>> _accounts = [
    {
      'id': 1,
      'name': 'Chase Freedom Unlimited',
      'type': 'Credit Card',
      'balance': 2847.32,
      'icon': 'credit_card',
      'isConnected': true,
    },
    {
      'id': 2,
      'name': 'First Hawaiian Checking',
      'type': 'Checking',
      'balance': 5234.67,
      'icon': 'account_balance',
      'isConnected': true,
    },
    {
      'id': 3,
      'name': 'Ally High Yield Savings',
      'type': 'Savings',
      'balance': 15678.90,
      'icon': 'savings',
      'isConnected': false,
    },
    {
      'id': 4,
      'name': 'Edward Jones Roth IRA',
      'type': 'Investment',
      'balance': 23456.78,
      'icon': 'trending_up',
      'isConnected': true,
    },
    {
      'id': 5,
      'name': 'Charles Schwab Brokerage',
      'type': 'Investment',
      'balance': 45123.45,
      'icon': 'show_chart',
      'isConnected': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      _lastUpdated = DateTime.now();
    });

    _refreshController.reset();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Accounts synced successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(3.w)),
        ),
      );
    }
  }

  double get _totalNetWorth {
    return (_accounts as List)
        .fold(0.0, (sum, account) => sum + (account['balance'] as double));
  }

  double get _monthlyExpenses {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return (_recentTransactions as List)
        .where((transaction) =>
            (transaction['type'] as String) == 'expense' &&
            (transaction['date'] as DateTime).isAfter(startOfMonth))
        .fold(
            0.0, (sum, transaction) => sum + (transaction['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Text(
              'ExpenseTracker',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              'Pro',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.secondary,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 2.w),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: Colors.green,
                  size: 4.w,
                ),
                SizedBox(width: 1.w),
                Text(
                  'Secure',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: CustomIconWidget(
              iconName: 'notifications_outlined',
              color: colorScheme.onSurface,
              size: 6.w,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: colorScheme.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Net Worth Card
                  NetWorthCard(
                    netWorth: _totalNetWorth,
                    monthlyChange: 1247.83,
                    isPositiveChange: true,
                    onPrivacyToggle: () {
                      // Handle privacy toggle
                    },
                  ),

                  // Spending Summary Cards
                  SpendingSummaryCard(
                    title: 'This Month\'s Expenses',
                    amount: _monthlyExpenses,
                    period: 'last month',
                    percentageChange: 12.5,
                    isPositiveChange: true,
                    onTap: () =>
                        Navigator.pushNamed(context, '/transaction-list'),
                  ),

                  // Quick Actions
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Actions',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Expanded(
                              child: QuickActionCard(
                                title: 'Add Transaction',
                                iconName: 'add_circle_outline',
                                onTap: () => Navigator.pushNamed(
                                    context, '/add-transaction'),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: QuickActionCard(
                                title: 'View Budget',
                                iconName: 'pie_chart_outline',
                                onTap: () => Navigator.pushNamed(
                                    context, '/financial-insights'),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: QuickActionCard(
                                title: 'Connect Account',
                                iconName: 'account_balance',
                                onTap: () => Navigator.pushNamed(
                                    context, '/account-management'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Account Balance Overview
                  AccountBalanceOverview(
                    accounts: _accounts,
                    onViewAll: () =>
                        Navigator.pushNamed(context, '/account-management'),
                  ),

                  // Recent Transactions
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Transactions',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                  context, '/transaction-list'),
                              child: Text(
                                'View All',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= _recentTransactions.length) return null;

                  return RecentTransactionItem(
                    transaction: _recentTransactions[index],
                    onTap: () {
                      // Navigate to transaction details
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Transaction details for ${_recentTransactions[index]['merchant']}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    onCategorize: () {
                      // Handle categorization
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Categorizing ${_recentTransactions[index]['merchant']}'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
                childCount: _recentTransactions.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.all(4.w),
                padding: EdgeInsets.symmetric(vertical: 3.h),
                child: Column(
                  children: [
                    Text(
                      'Last updated: ${_formatLastUpdated(_lastUpdated)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    if (_isRefreshing)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 4.w,
                            height: 4.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.primary,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Syncing accounts...',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-transaction'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        child: CustomIconWidget(
          iconName: 'add',
          color: colorScheme.onPrimary,
          size: 7.w,
        ),
      ),
    );
  }

  String _formatLastUpdated(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${dateTime.month}/${dateTime.day} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
