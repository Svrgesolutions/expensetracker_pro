import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum SettingsRowType {
  navigation,
  toggle,
  value,
  action,
}

class SettingsRowWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? iconName;
  final SettingsRowType type;
  final bool? switchValue;
  final String? valueText;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggle;
  final bool showDivider;
  final Color? iconColor;
  final bool isDestructive;

  const SettingsRowWidget({
    super.key,
    required this.title,
    this.subtitle,
    this.iconName,
    this.type = SettingsRowType.navigation,
    this.switchValue,
    this.valueText,
    this.onTap,
    this.onToggle,
    this.showDivider = true,
    this.iconColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: type == SettingsRowType.toggle ? null : onTap,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  if (iconName != null) ...[
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: (iconColor ?? theme.colorScheme.primary)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: iconName!,
                          color: iconColor ?? theme.colorScheme.primary,
                          size: 4.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.w),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: isDestructive
                                ? theme.colorScheme.error
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        if (subtitle != null) ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            subtitle!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  _buildTrailingWidget(context),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            indent: iconName != null ? 15.w : 4.w,
            endIndent: 4.w,
          ),
      ],
    );
  }

  Widget _buildTrailingWidget(BuildContext context) {
    final theme = Theme.of(context);

    switch (type) {
      case SettingsRowType.toggle:
        return Switch(
          value: switchValue ?? false,
          onChanged: onToggle,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      case SettingsRowType.value:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (valueText != null)
              Text(
                valueText!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
          ],
        );
      case SettingsRowType.action:
        return const SizedBox.shrink();
      default:
        return CustomIconWidget(
          iconName: 'chevron_right',
          color: theme.colorScheme.onSurfaceVariant,
          size: 4.w,
        );
    }
  }
}
