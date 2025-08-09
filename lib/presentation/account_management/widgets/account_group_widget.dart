import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './account_card_widget.dart';

class AccountGroupWidget extends StatelessWidget {
  final String groupTitle;
  final List<Map<String, dynamic>> accounts;
  final bool isExpanded;
  final VoidCallback? onToggleExpanded;
  final Function(Map<String, dynamic>)? onAccountTap;
  final Function(Map<String, dynamic>)? onAccountRefresh;
  final Function(Map<String, dynamic>)? onViewTransactions;
  final Function(Map<String, dynamic>)? onAccountSettings;
  final Function(Map<String, dynamic>)? onAccountDisconnect;

  const AccountGroupWidget({
    super.key,
    required this.groupTitle,
    required this.accounts,
    this.isExpanded = true,
    this.onToggleExpanded,
    this.onAccountTap,
    this.onAccountRefresh,
    this.onViewTransactions,
    this.onAccountSettings,
    this.onAccountDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalBalance = _calculateTotalBalance();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGroupHeader(context, totalBalance),
          if (isExpanded) ...[
            SizedBox(height: 1.h),
            ...accounts.map((account) => AccountCardWidget(
                  account: account,
                  onTap: () => onAccountTap?.call(account),
                  onRefresh: () => onAccountRefresh?.call(account),
                  onViewTransactions: () => onViewTransactions?.call(account),
                  onSettings: () => onAccountSettings?.call(account),
                  onDisconnect: () => onAccountDisconnect?.call(account),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildGroupHeader(BuildContext context, String totalBalance) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onToggleExpanded,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color:
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            _buildGroupIcon(context),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        groupTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${accounts.length}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    'Total: $totalBalance',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            _buildConnectionSummary(context),
            SizedBox(width: 2.w),
            AnimatedRotation(
              turns: isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                size: 24,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupIcon(BuildContext context) {
    final theme = Theme.of(context);
    IconData iconData;
    Color iconColor;

    switch (groupTitle.toLowerCase()) {
      case 'banking':
        iconData = Icons.account_balance;
        iconColor =
            AppTheme.getAccentBlueColor(theme.brightness == Brightness.light);
        break;
      case 'credit cards':
        iconData = Icons.credit_card;
        iconColor =
            AppTheme.getWarningColor(theme.brightness == Brightness.light);
        break;
      case 'investments':
        iconData = Icons.trending_up;
        iconColor =
            AppTheme.getSuccessColor(theme.brightness == Brightness.light);
        break;
      case 'crypto':
        iconData = Icons.currency_bitcoin;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.account_balance_wallet;
        iconColor = theme.colorScheme.primary;
    }

    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: CustomIconWidget(
        iconName: iconData.codePoint.toString(),
        size: 24,
        color: iconColor,
      ),
    );
  }

  Widget _buildConnectionSummary(BuildContext context) {
    final theme = Theme.of(context);
    final connectedCount = accounts
        .where((account) =>
            (account["connectionStatus"] as String).toLowerCase() ==
            'connected')
        .length;
    final needsAttentionCount = accounts
        .where((account) =>
            (account["connectionStatus"] as String).toLowerCase() ==
            'needs_attention')
        .length;
    final disconnectedCount = accounts
        .where((account) =>
            (account["connectionStatus"] as String).toLowerCase() ==
            'disconnected')
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (connectedCount > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.getSuccessColor(
                      theme.brightness == Brightness.light),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                '$connectedCount',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.getSuccessColor(
                      theme.brightness == Brightness.light),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        if (needsAttentionCount > 0) ...[
          SizedBox(height: 0.5.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppTheme.getWarningColor(
                      theme.brightness == Brightness.light),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                '$needsAttentionCount',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.getWarningColor(
                      theme.brightness == Brightness.light),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
        if (disconnectedCount > 0) ...[
          SizedBox(height: 0.5.h),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                '$disconnectedCount',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _calculateTotalBalance() {
    double total = 0.0;
    for (final account in accounts) {
      final balanceString =
          (account["balance"] as String).replaceAll(RegExp(r'[^\d.-]'), '');
      final balance = double.tryParse(balanceString) ?? 0.0;
      total += balance;
    }

    return total >= 0
        ? '\$${total.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
        : '-\$${total.abs().toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
}
