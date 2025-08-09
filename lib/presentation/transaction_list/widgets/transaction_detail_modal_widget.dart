import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TransactionDetailModalWidget extends StatefulWidget {
  final Map<String, dynamic> transaction;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TransactionDetailModalWidget({
    super.key,
    required this.transaction,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<TransactionDetailModalWidget> createState() =>
      _TransactionDetailModalWidgetState();
}

class _TransactionDetailModalWidgetState
    extends State<TransactionDetailModalWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final transaction = widget.transaction;
    final amount = (transaction['amount'] as double?) ?? 0.0;
    final isIncome = amount > 0;
    final merchant = (transaction['merchant'] as String?) ?? 'Unknown';
    final category = (transaction['category'] as String?) ?? 'Uncategorized';
    final account = (transaction['account'] as String?) ?? 'Unknown Account';
    final date = (transaction['date'] as DateTime?) ?? DateTime.now();
    final note = (transaction['note'] as String?) ?? '';
    final isBusinessExpense =
        (transaction['isBusinessExpense'] as bool?) ?? false;
    final categoryIcon = (transaction['categoryIcon'] as String?) ?? 'category';
    final receiptUrl = (transaction['receiptUrl'] as String?);

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.w)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 10.w,
            height: 1.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(0.5.h),
            ),
          ),

          // Header with amount
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            decoration: BoxDecoration(
              color: isIncome
                  ? AppTheme.getSuccessColor(
                          theme.brightness == Brightness.light)
                      .withValues(alpha: 0.1)
                  : theme.colorScheme.error.withValues(alpha: 0.1),
            ),
            child: Column(
              children: [
                Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: isIncome
                        ? AppTheme.getSuccessColor(
                                theme.brightness == Brightness.light)
                            .withValues(alpha: 0.2)
                        : theme.colorScheme.error.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.w),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: categoryIcon,
                      color: isIncome
                          ? AppTheme.getSuccessColor(
                              theme.brightness == Brightness.light)
                          : theme.colorScheme.error,
                      size: 8.w,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  '${isIncome ? '+' : '-'}\$${amount.abs().toStringAsFixed(2)}',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: isIncome
                        ? AppTheme.getSuccessColor(
                            theme.brightness == Brightness.light)
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  merchant,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Transaction details
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow(
                    context,
                    'Category',
                    category,
                    'category',
                  ),
                  _buildDetailRow(
                    context,
                    'Account',
                    account,
                    'account_balance',
                  ),
                  _buildDetailRow(
                    context,
                    'Date',
                    _formatDate(date),
                    'calendar_today',
                  ),
                  if (isBusinessExpense)
                    _buildDetailRow(
                      context,
                      'Business Expense',
                      'Yes',
                      'business',
                      valueColor: AppTheme.getAccentBlueColor(
                          theme.brightness == Brightness.light),
                    ),
                  if (note.isNotEmpty)
                    _buildDetailRow(
                      context,
                      'Note',
                      note,
                      'note',
                      isMultiline: true,
                    ),

                  SizedBox(height: 3.h),

                  // Receipt section
                  if (receiptUrl != null) ...[
                    _buildReceiptSection(context, receiptUrl),
                    SizedBox(height: 3.h),
                  ] else ...[
                    _buildAddReceiptSection(context),
                    SizedBox(height: 3.h),
                  ],

                  // Action buttons
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    String iconName, {
    Color? valueColor,
    bool isMultiline = false,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(5.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: theme.colorScheme.primary,
                size: 5.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: valueColor ?? theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptSection(BuildContext context, String receiptUrl) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receipt',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          height: 25.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(3.w),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3.w),
            child: CustomImageWidget(
              imageUrl: receiptUrl,
              width: double.infinity,
              height: 25.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _viewReceipt(context, receiptUrl),
                icon: CustomIconWidget(
                  iconName: 'visibility',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                label: const Text('View Full Size'),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _replaceReceipt(context),
                icon: CustomIconWidget(
                  iconName: 'edit',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                label: const Text('Replace'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddReceiptSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receipt',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: () => _addReceipt(context),
          child: Container(
            width: double.infinity,
            height: 15.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(3.w),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'add_a_photo',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 8.w,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Add Receipt',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Tap to take photo or select from gallery',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: widget.onEdit,
            icon: CustomIconWidget(
              iconName: 'edit',
              color: theme.colorScheme.onPrimary,
              size: 5.w,
            ),
            label: const Text('Edit Transaction'),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _showDeleteConfirmation(context),
            icon: CustomIconWidget(
              iconName: 'delete',
              color: theme.colorScheme.error,
              size: 5.w,
            ),
            label: Text(
              'Delete Transaction',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.colorScheme.error),
            ),
          ),
        ),
        SizedBox(height: 4.h),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return '${days[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  void _viewReceipt(BuildContext context, String receiptUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Receipt'),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: InteractiveViewer(
              child: CustomImageWidget(
                imageUrl: receiptUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _replaceReceipt(BuildContext context) {
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
                iconName: 'camera_alt',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // Handle camera capture
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'photo_library',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // Handle gallery selection
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _addReceipt(BuildContext context) {
    _replaceReceipt(context);
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
              Navigator.pop(context);
              widget.onDelete?.call();
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
