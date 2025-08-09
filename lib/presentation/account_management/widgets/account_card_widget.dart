import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AccountCardWidget extends StatelessWidget {
  final Map<String, dynamic> account;
  final VoidCallback? onTap;
  final VoidCallback? onRefresh;
  final VoidCallback? onViewTransactions;
  final VoidCallback? onSettings;
  final VoidCallback? onDisconnect;

  const AccountCardWidget({
    super.key,
    required this.account,
    this.onTap,
    this.onRefresh,
    this.onViewTransactions,
    this.onSettings,
    this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dismissible(
      key: Key('account_${account["id"]}'),
      background: _buildSwipeBackground(context, isLeft: true),
      secondaryBackground: _buildSwipeBackground(context, isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          // Swipe right - Quick actions
          _showQuickActions(context);
        } else {
          // Swipe left - Disconnect
          _showDisconnectDialog(context);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildInstitutionLogo(),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account["institutionName"] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              account["accountName"] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildConnectionStatus(context),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Balance',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            account["balance"] as String,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: _getBalanceColor(context),
                            ),
                          ),
                        ],
                      ),
                      _buildAccountTypeChip(context),
                    ],
                  ),
                  if (account["lastSync"] != null) ...[
                    SizedBox(height: 1.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'sync',
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Last synced: ${account["lastSync"]}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstitutionLogo() {
    return Container(
      width: 12.w,
      height: 12.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[100],
      ),
      child: account["logoUrl"] != null
          ? CustomImageWidget(
              imageUrl: account["logoUrl"] as String,
              width: 12.w,
              height: 12.w,
              fit: BoxFit.contain,
            )
          : CustomIconWidget(
              iconName: 'account_balance',
              size: 24,
              color: Colors.grey[600]!,
            ),
    );
  }

  Widget _buildConnectionStatus(BuildContext context) {
    final theme = Theme.of(context);
    final status = account["connectionStatus"] as String;

    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'connected':
        statusColor =
            AppTheme.getSuccessColor(theme.brightness == Brightness.light);
        statusIcon = Icons.check_circle;
        break;
      case 'needs_attention':
        statusColor =
            AppTheme.getWarningColor(theme.brightness == Brightness.light);
        statusIcon = Icons.warning;
        break;
      case 'disconnected':
        statusColor = theme.colorScheme.error;
        statusIcon = Icons.error;
        break;
      default:
        statusColor = theme.colorScheme.onSurfaceVariant;
        statusIcon = Icons.help;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: statusIcon.codePoint.toString(),
            size: 16,
            color: statusColor,
          ),
          SizedBox(width: 1.w),
          Text(
            status.replaceAll('_', ' ').toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountTypeChip(BuildContext context) {
    final theme = Theme.of(context);
    final accountType = account["accountType"] as String;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        accountType.toUpperCase(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  Color _getBalanceColor(BuildContext context) {
    final theme = Theme.of(context);
    final balanceString = account["balance"] as String;
    final isNegative = balanceString.contains('-');

    if (isNegative) {
      return theme.colorScheme.error;
    } else {
      return AppTheme.getSuccessColor(theme.brightness == Brightness.light);
    }
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft
            ? AppTheme.getAccentBlueColor(theme.brightness == Brightness.light)
            : theme.colorScheme.error,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'refresh' : 'delete',
                size: 28,
                color: Colors.white,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? 'Actions' : 'Disconnect',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
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
                iconName: 'refresh',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Refresh Account'),
              onTap: () {
                Navigator.pop(context);
                onRefresh?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'receipt_long',
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('View Transactions'),
              onTap: () {
                Navigator.pop(context);
                onViewTransactions?.call();
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
                onSettings?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showDisconnectDialog(BuildContext context) {
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
              onDisconnect?.call();
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
}
