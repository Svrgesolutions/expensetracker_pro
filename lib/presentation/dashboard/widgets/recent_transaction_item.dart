import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class RecentTransactionItem extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback? onTap;
  final VoidCallback? onCategorize;

  const RecentTransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
    this.onCategorize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String merchant =
        (transaction['merchant'] as String?) ?? 'Unknown Merchant';
    final double amount = (transaction['amount'] as num?)?.toDouble() ?? 0.0;
    final String category =
        (transaction['category'] as String?) ?? 'Uncategorized';
    final String account =
        (transaction['account'] as String?) ?? 'Unknown Account';
    final String categoryIcon =
        (transaction['categoryIcon'] as String?) ?? 'category';
    final bool isExpense = (transaction['type'] as String?) == 'expense';
    final DateTime date = transaction['date'] as DateTime? ?? DateTime.now();

    return Dismissible(
      key: Key(transaction['id']?.toString() ??
          DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: Colors.green.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(3.w),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'category',
              color: Colors.green,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Categorize',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(3.w),
        ),
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Details',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'info',
              color: colorScheme.primary,
              size: 6.w,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onCategorize?.call();
        } else {
          onTap?.call();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.5.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: categoryIcon,
                  color: colorScheme.primary,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      merchant,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Text(
                          category,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Container(
                          width: 1,
                          height: 3.w,
                          color: colorScheme.outline.withValues(alpha: 0.3),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          account,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${isExpense ? '-' : '+'}\$${amount.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: isExpense ? Colors.red : Colors.green,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    _formatDate(date),
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
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '${difference}d ago';
    } else {
      return '${date.month}/${date.day}';
    }
  }
}
