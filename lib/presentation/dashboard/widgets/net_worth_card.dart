import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class NetWorthCard extends StatefulWidget {
  final double netWorth;
  final double monthlyChange;
  final bool isPositiveChange;
  final VoidCallback? onPrivacyToggle;

  const NetWorthCard({
    super.key,
    required this.netWorth,
    required this.monthlyChange,
    required this.isPositiveChange,
    this.onPrivacyToggle,
  });

  @override
  State<NetWorthCard> createState() => _NetWorthCardState();
}

class _NetWorthCardState extends State<NetWorthCard> {
  bool _isAmountVisible = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Net Worth',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isAmountVisible = !_isAmountVisible;
                  });
                  widget.onPrivacyToggle?.call();
                },
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: colorScheme.onPrimary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: CustomIconWidget(
                    iconName:
                        _isAmountVisible ? 'visibility_off' : 'visibility',
                    color: colorScheme.onPrimary,
                    size: 5.w,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            _isAmountVisible
                ? '\$${widget.netWorth.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}'
                : '••••••',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 8.sp,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: widget.isPositiveChange
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: widget.isPositiveChange
                          ? 'trending_up'
                          : 'trending_down',
                      color:
                          widget.isPositiveChange ? Colors.green : Colors.red,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _isAmountVisible
                          ? '${widget.isPositiveChange ? '+' : '-'}\$${widget.monthlyChange.abs().toStringAsFixed(2)}'
                          : '••••',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            widget.isPositiveChange ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 2.w),
              Text(
                'this month',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
