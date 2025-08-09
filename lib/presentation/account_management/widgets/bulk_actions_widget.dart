import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BulkActionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> selectedAccounts;
  final VoidCallback? onRefreshSelected;
  final VoidCallback? onExportSelected;
  final VoidCallback? onOrganizeSelected;
  final VoidCallback? onClearSelection;

  const BulkActionsWidget({
    super.key,
    required this.selectedAccounts,
    this.onRefreshSelected,
    this.onExportSelected,
    this.onOrganizeSelected,
    this.onClearSelection,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (selectedAccounts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${selectedAccounts.length} account${selectedAccounts.length == 1 ? '' : 's'} selected',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onClearSelection,
                  child: Text(
                    'Clear',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: 'refresh',
                    label: 'Refresh',
                    onPressed: onRefreshSelected,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: 'file_download',
                    label: 'Export',
                    onPressed: onExportSelected,
                  ),
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: _buildActionButton(
                    context,
                    icon: 'folder_open',
                    label: 'Organize',
                    onPressed: onOrganizeSelected,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: theme.colorScheme.primary,
        side: BorderSide(
          color: theme.colorScheme.primary.withValues(alpha: 0.5),
          width: 1,
        ),
        padding: EdgeInsets.symmetric(vertical: 1.5.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon,
            size: 20,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
