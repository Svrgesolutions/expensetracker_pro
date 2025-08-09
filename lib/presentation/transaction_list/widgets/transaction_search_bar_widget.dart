import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TransactionSearchBarWidget extends StatefulWidget {
  final String? initialQuery;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterTap;
  final int activeFilterCount;

  const TransactionSearchBarWidget({
    super.key,
    this.initialQuery,
    this.onSearchChanged,
    this.onFilterTap,
    this.activeFilterCount = 0,
  });

  @override
  State<TransactionSearchBarWidget> createState() =>
      _TransactionSearchBarWidgetState();
}

class _TransactionSearchBarWidgetState
    extends State<TransactionSearchBarWidget> {
  late TextEditingController _searchController;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _isSearchActive = widget.initialQuery?.isNotEmpty ?? false;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3.h),
                border: Border.all(
                  color: _isSearchActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: _isSearchActive ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  SizedBox(width: 4.w),
                  CustomIconWidget(
                    iconName: 'search',
                    color: _isSearchActive
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _isSearchActive = value.isNotEmpty;
                        });
                        widget.onSearchChanged?.call(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search transactions...',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  if (_isSearchActive) ...[
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _isSearchActive = false;
                        });
                        widget.onSearchChanged?.call('');
                      },
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        child: CustomIconWidget(
                          iconName: 'clear',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 4.w,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(width: 2.w),
                ],
              ),
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: widget.onFilterTap,
            child: Container(
              width: 12.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: widget.activeFilterCount > 0
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(3.h),
                border: Border.all(
                  color: widget.activeFilterCount > 0
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: CustomIconWidget(
                      iconName: 'filter_list',
                      color: widget.activeFilterCount > 0
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  if (widget.activeFilterCount > 0)
                    Positioned(
                      top: 1.h,
                      right: 2.w,
                      child: Container(
                        width: 4.w,
                        height: 4.w,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                        child: Center(
                          child: Text(
                            widget.activeFilterCount > 9
                                ? '9+'
                                : widget.activeFilterCount.toString(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onError,
                              fontSize: 8.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
