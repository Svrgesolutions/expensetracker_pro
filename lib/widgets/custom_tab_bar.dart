import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomTabBarVariant {
  standard,
  pills,
  underline,
  segmented,
  scrollable,
}

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final CustomTabBarVariant variant;
  final bool isScrollable;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    this.onTap,
    this.variant = CustomTabBarVariant.standard,
    this.isScrollable = false,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.padding,
    this.height,
  });

  // Financial app specific tab configurations
  static const List<String> dashboardTabs = [
    'Overview',
    'Accounts',
    'Recent',
  ];

  static const List<String> transactionTabs = [
    'All',
    'Income',
    'Expenses',
    'Transfers',
  ];

  static const List<String> insightsTabs = [
    'Spending',
    'Trends',
    'Goals',
    'Reports',
  ];

  static const List<String> accountTabs = [
    'Checking',
    'Savings',
    'Credit',
    'Investment',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomTabBarVariant.pills:
        return _buildPillsTabBar(context);
      case CustomTabBarVariant.underline:
        return _buildUnderlineTabBar(context);
      case CustomTabBarVariant.segmented:
        return _buildSegmentedTabBar(context);
      case CustomTabBarVariant.scrollable:
        return _buildScrollableTabBar(context);
      default:
        return _buildStandardTabBar(context);
    }
  }

  Widget _buildStandardTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height ?? 48,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        isScrollable: isScrollable || tabs.length > 4,
        labelColor: selectedColor ?? theme.colorScheme.primary,
        unselectedLabelColor:
            unselectedColor ?? theme.colorScheme.onSurfaceVariant,
        indicatorColor: indicatorColor ?? theme.colorScheme.primary,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        onTap: onTap,
        dividerColor: Colors.transparent,
        tabAlignment: isScrollable ? TabAlignment.start : TabAlignment.fill,
      ),
    );
  }

  Widget _buildPillsTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height ?? 56,
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = index == currentIndex;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onTap?.call(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (selectedColor ?? theme.colorScheme.primary)
                        : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? (selectedColor ?? theme.colorScheme.primary)
                          : theme.colorScheme.outline.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tab,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : (unselectedColor ??
                              theme.colorScheme.onSurfaceVariant),
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildUnderlineTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height ?? 48,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == currentIndex;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTap?.call(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? (indicatorColor ?? theme.colorScheme.primary)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? (selectedColor ?? theme.colorScheme.primary)
                        : (unselectedColor ??
                            theme.colorScheme.onSurfaceVariant),
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSegmentedTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height ?? 56,
      padding: padding ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
      ),
      child: Container(
        decoration: BoxDecoration(
          color:
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = index == currentIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () => onTap?.call(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.surface
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.shadow
                                  .withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    tab,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? (selectedColor ?? theme.colorScheme.primary)
                          : (unselectedColor ??
                              theme.colorScheme.onSurfaceVariant),
                      letterSpacing: 0.1,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildScrollableTabBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height ?? 48,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        tabs: tabs
            .map((tab) => Tab(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(tab),
                  ),
                ))
            .toList(),
        isScrollable: true,
        labelColor: selectedColor ?? theme.colorScheme.primary,
        unselectedLabelColor:
            unselectedColor ?? theme.colorScheme.onSurfaceVariant,
        indicatorColor: indicatorColor ?? theme.colorScheme.primary,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.1,
        ),
        onTap: onTap,
        dividerColor: Colors.transparent,
        tabAlignment: TabAlignment.start,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 48);
}

// Helper widget for TabBarView with financial app specific content
class CustomTabBarView extends StatelessWidget {
  final List<Widget> children;
  final TabController? controller;
  final ValueChanged<int>? onPageChanged;

  const CustomTabBarView({
    super.key,
    required this.children,
    this.controller,
    this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: controller,
      children: children
          .map(
            (child) => SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: child,
            ),
          )
          .toList(),
    );
  }
}

// Predefined tab configurations for financial app
class FinancialTabConfigs {
  static const Map<String, List<String>> configs = {
    'dashboard': dashboardTabs,
    'transactions': transactionTabs,
    'insights': insightsTabs,
    'accounts': accountTabs,
  };

  static const List<String> dashboardTabs = [
    'Overview',
    'Accounts',
    'Recent',
  ];

  static const List<String> transactionTabs = [
    'All',
    'Income',
    'Expenses',
    'Transfers',
  ];

  static const List<String> insightsTabs = [
    'Spending',
    'Trends',
    'Goals',
    'Reports',
  ];

  static const List<String> accountTabs = [
    'Checking',
    'Savings',
    'Credit',
    'Investment',
  ];
}
