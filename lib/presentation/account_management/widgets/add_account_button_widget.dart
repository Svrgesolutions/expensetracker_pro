import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AddAccountButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isFloating;

  const AddAccountButtonWidget({
    super.key,
    this.onPressed,
    this.isFloating = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isFloating) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        elevation: 4,
        icon: CustomIconWidget(
          iconName: 'add',
          size: 24,
          color: theme.colorScheme.onPrimary,
        ),
        label: Text(
          'Add Account',
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'add',
              size: 24,
              color: theme.colorScheme.onPrimary,
            ),
            SizedBox(width: 2.w),
            Text(
              'Add New Account',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
