import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionItemWidget extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback? onTap;
  final VoidCallback? onEditCategory;
  final VoidCallback? onAddNote;
  final VoidCallback? onMarkBusiness;
  final VoidCallback? onSplitTransaction;
  final VoidCallback? onDelete;

  const TransactionItemWidget({
    super.key,
    required this.transaction,
    this.onTap,
    this.onEditCategory,
    this.onAddNote,
    this.onMarkBusiness,
    this.onSplitTransaction,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amount = (transaction['amount'] as double?) ?? 0.0;
    final isIncome = amount > 0;
    final merchant = (transaction['merchant'] as String?) ?? 'Unknown';
    final category = (transaction['category'] as String?) ?? 'Uncategorized';
    final account = (transaction['account'] as String?) ?? 'Unknown Account';
    final categoryIcon = (transaction['categoryIcon'] as String?) ?? 'category';
    final isBusinessExpense =
        (transaction['isBusinessExpense'] as bool?) ?? false;
    final hasNote = (transaction['note'] as String?)?.isNotEmpty ?? false;

    return Dismissible(
      key: Key(transaction['id'].toString()),
      background: _buildLeftSwipeBackground(context),
      secondaryBackground: _buildRightSwipeBackground(context),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Right swipe - Quick actions
          _showQuickActions(context);
          return false;
        } else {
          // Left swipe - Destructive actions
          _showDestructiveActions(context);
          return false;
        }
      },
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              // Category Icon
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: isIncome
                      ? AppTheme.getSuccessColor(
                              theme.brightness == Brightness.light)
                          .withValues(alpha: 0.1)
                      : theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.w),
                ),
                child: Center(
                  child: CustomIconWidget(
                    iconName: categoryIcon,
                    color: isIncome
                        ? AppTheme.getSuccessColor(
                            theme.brightness == Brightness.light)
                        : theme.colorScheme.primary,
                    size: 6.w,
                  ),
                ),
              ),
              SizedBox(width: 3.w),

              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            merchant,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isBusinessExpense) ...[
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.getAccentBlueColor(
                                      theme.brightness == Brightness.light)
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(1.w),
                            ),
                            child: Text(
                              'Business',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppTheme.getAccentBlueColor(
                                    theme.brightness == Brightness.light),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                        if (hasNote) ...[
                          SizedBox(width: 2.w),
                          CustomIconWidget(
                            iconName: 'note',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 4.w,
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            category,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          ' • ',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            account,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(width: 3.w),

              // Amount
              Text(
                '${isIncome ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isIncome
                      ? AppTheme.getSuccessColor(
                          theme.brightness == Brightness.light)
                      : theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeftSwipeBackground(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: AppTheme.getSuccessColor(theme.brightness == Brightness.light)
          .withValues(alpha: 0.1),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: 6.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.getSuccessColor(
                    theme.brightness == Brightness.light),
                size: 6.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Quick Actions',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppTheme.getSuccessColor(
                      theme.brightness == Brightness.light),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightSwipeBackground(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.error.withValues(alpha: 0.1),
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.only(right: 6.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'More Actions',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 2.w),
              CustomIconWidget(
                iconName: 'more_horiz',
                color: theme.colorScheme.error,
                size: 6.w,
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
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 1.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'category',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Edit Category'),
              onTap: () {
                Navigator.pop(context);
                onEditCategory?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'note_add',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Add Note'),
              onTap: () {
                Navigator.pop(context);
                onAddNote?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'business',
                color: AppTheme.getAccentBlueColor(
                    Theme.of(context).brightness == Brightness.light),
                size: 6.w,
              ),
              title: const Text('Mark as Business Expense'),
              onTap: () {
                Navigator.pop(context);
                onMarkBusiness?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showDestructiveActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 1.h,
              margin: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(0.5.h),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'call_split',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Split Transaction'),
              onTap: () {
                Navigator.pop(context);
                onSplitTransaction?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete',
                color: Theme.of(context).colorScheme.error,
                size: 6.w,
              ),
              title: Text(
                'Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text(
            'Are you sure you want to delete this transaction? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
