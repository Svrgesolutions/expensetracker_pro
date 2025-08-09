import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomBottomBarVariant {
  standard,
  floating,
  minimal,
  withFab,
}

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final CustomBottomBarVariant variant;
  final bool showLabels;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.variant = CustomBottomBarVariant.standard,
    this.showLabels = true,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
  });

  static const List<_BottomBarItem> _items = [
    _BottomBarItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/dashboard',
    ),
    _BottomBarItem(
      icon: Icons.account_balance_wallet_outlined,
      selectedIcon: Icons.account_balance_wallet,
      label: 'Accounts',
      route: '/account-management',
    ),
    _BottomBarItem(
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      label: 'Transactions',
      route: '/transaction-list',
    ),
    _BottomBarItem(
      icon: Icons.insights_outlined,
      selectedIcon: Icons.insights,
      label: 'Insights',
      route: '/financial-insights',
    ),
    _BottomBarItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomBottomBarVariant.floating:
        return _buildFloatingBottomBar(context);
      case CustomBottomBarVariant.minimal:
        return _buildMinimalBottomBar(context);
      case CustomBottomBarVariant.withFab:
        return _buildBottomBarWithFab(context);
      default:
        return _buildStandardBottomBar(context);
    }
  }

  Widget _buildStandardBottomBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _handleTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: selectedItemColor ?? theme.colorScheme.primary,
          unselectedItemColor:
              unselectedItemColor ?? theme.colorScheme.onSurfaceVariant,
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          showSelectedLabels: showLabels,
          showUnselectedLabels: showLabels,
          items: _items
              .map((item) => BottomNavigationBarItem(
                    icon: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Icon(item.icon, size: 24),
                    ),
                    activeIcon: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Icon(item.selectedIcon, size: 24),
                    ),
                    label: item.label,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow.withValues(alpha: 0.15),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _items.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == currentIndex;

                  return _buildFloatingBarItem(
                    context,
                    item,
                    isSelected,
                    () => _handleTap(index),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBarItem(
    BuildContext context,
    _BottomBarItem item,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedItemColor ?? colorScheme.primary)
                  .withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? item.selectedIcon : item.icon,
              size: 24,
              color: isSelected
                  ? (selectedItemColor ?? colorScheme.primary)
                  : (unselectedItemColor ?? colorScheme.onSurfaceVariant),
            ),
            if (showLabels) ...[
              const SizedBox(height: 4),
              Text(
                item.label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                  color: isSelected
                      ? (selectedItemColor ?? colorScheme.primary)
                      : (unselectedItemColor ?? colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isSelected = index == currentIndex;

            return GestureDetector(
              onTap: () => _handleTap(index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  size: 28,
                  color: isSelected
                      ? (selectedItemColor ?? theme.colorScheme.primary)
                      : (unselectedItemColor ??
                          theme.colorScheme.onSurfaceVariant),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomBarWithFab(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            BottomNavigationBar(
              currentIndex: currentIndex >= 2 ? currentIndex + 1 : currentIndex,
              onTap: (index) {
                if (index == 2) return; // Skip FAB position
                _handleTap(index >= 2 ? index - 1 : index);
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: selectedItemColor ?? theme.colorScheme.primary,
              unselectedItemColor:
                  unselectedItemColor ?? theme.colorScheme.onSurfaceVariant,
              selectedLabelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              unselectedLabelStyle: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              showSelectedLabels: showLabels,
              showUnselectedLabels: showLabels,
              items: [
                ..._items.take(2).map((item) => BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Icon(item.icon, size: 24),
                      ),
                      activeIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Icon(item.selectedIcon, size: 24),
                      ),
                      label: item.label,
                    )),
                const BottomNavigationBarItem(
                  icon: SizedBox(width: 24, height: 24),
                  label: '',
                ),
                ..._items.skip(2).map((item) => BottomNavigationBarItem(
                      icon: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Icon(item.icon, size: 24),
                      ),
                      activeIcon: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Icon(item.selectedIcon, size: 24),
                      ),
                      label: item.label,
                    )),
              ],
            ),
            Positioned(
              top: -8,
              child: FloatingActionButton(
                onPressed: () =>
                    Navigator.pushNamed(context, '/add-transaction'),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                elevation: 4,
                child: const Icon(Icons.add, size: 28),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(int index) {
    if (onTap != null) {
      onTap!(index);
    } else {
      // Default navigation behavior
      final context = navigatorKey.currentContext;
      if (context != null && index < _items.length) {
        Navigator.pushNamed(context, _items[index].route);
      }
    }
  }

  // Global navigator key for default navigation
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

class _BottomBarItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const _BottomBarItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}
