import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterModalWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>>? onFiltersChanged;

  const FilterModalWidget({
    super.key,
    required this.currentFilters,
    this.onFiltersChanged,
  });

  @override
  State<FilterModalWidget> createState() => _FilterModalWidgetState();
}

class _FilterModalWidgetState extends State<FilterModalWidget> {
  late Map<String, dynamic> _filters;
  final List<String> _expandedSections = [];

  final List<Map<String, dynamic>> _accounts = [
    {'name': 'Chase Freedom', 'type': 'Credit Card', 'icon': 'credit_card'},
    {
      'name': 'First Hawaiian Checking',
      'type': 'Checking',
      'icon': 'account_balance'
    },
    {'name': 'Ally Savings', 'type': 'Savings', 'icon': 'savings'},
    {
      'name': 'Edward Jones Roth IRA',
      'type': 'Investment',
      'icon': 'trending_up'
    },
    {'name': 'Charles Schwab', 'type': 'Brokerage', 'icon': 'show_chart'},
    {'name': 'Webull', 'type': 'Trading', 'icon': 'candlestick_chart'},
    {'name': 'Crypto.com', 'type': 'Crypto', 'icon': 'currency_bitcoin'},
    {'name': 'Venmo', 'type': 'Payment', 'icon': 'payment'},
  ];

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food & Dining', 'icon': 'restaurant'},
    {'name': 'Transportation', 'icon': 'directions_car'},
    {'name': 'Shopping', 'icon': 'shopping_bag'},
    {'name': 'Entertainment', 'icon': 'movie'},
    {'name': 'Bills & Utilities', 'icon': 'receipt'},
    {'name': 'Healthcare', 'icon': 'local_hospital'},
    {'name': 'Travel', 'icon': 'flight'},
    {'name': 'Income', 'icon': 'attach_money'},
    {'name': 'Transfer', 'icon': 'swap_horiz'},
    {'name': 'Investment', 'icon': 'trending_up'},
  ];

  final List<String> _dateRanges = [
    'Last 7 days',
    'Last 30 days',
    'Last 3 months',
    'Last 6 months',
    'This year',
    'Custom range',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);

    // Initialize default expanded sections
    if (_filters.isNotEmpty) {
      _expandedSections
          .addAll(['accounts', 'categories', 'dateRange', 'amount']);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 85.h,
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

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Filter Transactions',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2)),

          // Filter sections
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildAccountsSection(theme),
                  _buildCategoriesSection(theme),
                  _buildDateRangeSection(theme),
                  _buildAmountRangeSection(theme),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: Text('Apply Filters (${_getActiveFilterCount()})'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountsSection(ThemeData theme) {
    final isExpanded = _expandedSections.contains('accounts');
    final selectedAccounts = (_filters['accounts'] as List<String>?) ?? [];

    return Column(
      children: [
        ListTile(
          leading: CustomIconWidget(
            iconName: 'account_balance',
            color: theme.colorScheme.primary,
            size: 6.w,
          ),
          title: const Text('Accounts'),
          subtitle: selectedAccounts.isNotEmpty
              ? Text('${selectedAccounts.length} selected')
              : null,
          trailing: CustomIconWidget(
            iconName: isExpanded ? 'expand_less' : 'expand_more',
            color: theme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          onTap: () => _toggleSection('accounts'),
        ),
        if (isExpanded) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: _accounts.map((account) {
                final isSelected = selectedAccounts.contains(account['name']);
                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) =>
                      _toggleAccountFilter(account['name'] as String),
                  title: Text(account['name'] as String),
                  subtitle: Text(account['type'] as String),
                  secondary: CustomIconWidget(
                    iconName: account['icon'] as String,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  dense: true,
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoriesSection(ThemeData theme) {
    final isExpanded = _expandedSections.contains('categories');
    final selectedCategories = (_filters['categories'] as List<String>?) ?? [];

    return Column(
      children: [
        ListTile(
          leading: CustomIconWidget(
            iconName: 'category',
            color: theme.colorScheme.primary,
            size: 6.w,
          ),
          title: const Text('Categories'),
          subtitle: selectedCategories.isNotEmpty
              ? Text('${selectedCategories.length} selected')
              : null,
          trailing: CustomIconWidget(
            iconName: isExpanded ? 'expand_less' : 'expand_more',
            color: theme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          onTap: () => _toggleSection('categories'),
        ),
        if (isExpanded) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: _categories.map((category) {
                final isSelected =
                    selectedCategories.contains(category['name']);
                return CheckboxListTile(
                  value: isSelected,
                  onChanged: (value) =>
                      _toggleCategoryFilter(category['name'] as String),
                  title: Text(category['name'] as String),
                  secondary: CustomIconWidget(
                    iconName: category['icon'] as String,
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 5.w,
                  ),
                  dense: true,
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateRangeSection(ThemeData theme) {
    final isExpanded = _expandedSections.contains('dateRange');
    final selectedDateRange = _filters['dateRange'] as String?;

    return Column(
      children: [
        ListTile(
          leading: CustomIconWidget(
            iconName: 'date_range',
            color: theme.colorScheme.primary,
            size: 6.w,
          ),
          title: const Text('Date Range'),
          subtitle: selectedDateRange != null ? Text(selectedDateRange) : null,
          trailing: CustomIconWidget(
            iconName: isExpanded ? 'expand_less' : 'expand_more',
            color: theme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          onTap: () => _toggleSection('dateRange'),
        ),
        if (isExpanded) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Column(
              children: _dateRanges.map((range) {
                final isSelected = selectedDateRange == range;
                return RadioListTile<String>(
                  value: range,
                  groupValue: selectedDateRange,
                  onChanged: (value) => _setDateRangeFilter(value),
                  title: Text(range),
                  dense: true,
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAmountRangeSection(ThemeData theme) {
    final isExpanded = _expandedSections.contains('amount');
    final minAmount = (_filters['minAmount'] as double?) ?? 0.0;
    final maxAmount = (_filters['maxAmount'] as double?) ?? 10000.0;

    return Column(
      children: [
        ListTile(
          leading: CustomIconWidget(
            iconName: 'attach_money',
            color: theme.colorScheme.primary,
            size: 6.w,
          ),
          title: const Text('Amount Range'),
          subtitle: minAmount > 0 || maxAmount < 10000
              ? Text(
                  '\$${minAmount.toStringAsFixed(0)} - \$${maxAmount.toStringAsFixed(0)}')
              : null,
          trailing: CustomIconWidget(
            iconName: isExpanded ? 'expand_less' : 'expand_more',
            color: theme.colorScheme.onSurfaceVariant,
            size: 6.w,
          ),
          onTap: () => _toggleSection('amount'),
        ),
        if (isExpanded) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Min Amount',
                          prefixText: '\$',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final amount = double.tryParse(value) ?? 0.0;
                          setState(() {
                            _filters['minAmount'] = amount;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Max Amount',
                          prefixText: '\$',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          final amount = double.tryParse(value) ?? 10000.0;
                          setState(() {
                            _filters['maxAmount'] = amount;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                RangeSlider(
                  values: RangeValues(minAmount, maxAmount),
                  min: 0,
                  max: 10000,
                  divisions: 100,
                  labels: RangeLabels(
                    '\$${minAmount.toStringAsFixed(0)}',
                    '\$${maxAmount.toStringAsFixed(0)}',
                  ),
                  onChanged: (values) {
                    setState(() {
                      _filters['minAmount'] = values.start;
                      _filters['maxAmount'] = values.end;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _toggleSection(String section) {
    setState(() {
      if (_expandedSections.contains(section)) {
        _expandedSections.remove(section);
      } else {
        _expandedSections.add(section);
      }
    });
  }

  void _toggleAccountFilter(String account) {
    setState(() {
      final accounts = (_filters['accounts'] as List<String>?) ?? <String>[];
      if (accounts.contains(account)) {
        accounts.remove(account);
      } else {
        accounts.add(account);
      }
      _filters['accounts'] = accounts;
    });
  }

  void _toggleCategoryFilter(String category) {
    setState(() {
      final categories =
          (_filters['categories'] as List<String>?) ?? <String>[];
      if (categories.contains(category)) {
        categories.remove(category);
      } else {
        categories.add(category);
      }
      _filters['categories'] = categories;
    });
  }

  void _setDateRangeFilter(String? range) {
    setState(() {
      _filters['dateRange'] = range;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged?.call(_filters);
    Navigator.pop(context);
  }

  int _getActiveFilterCount() {
    int count = 0;

    final accounts = (_filters['accounts'] as List<String>?) ?? [];
    if (accounts.isNotEmpty) count++;

    final categories = (_filters['categories'] as List<String>?) ?? [];
    if (categories.isNotEmpty) count++;

    if (_filters['dateRange'] != null) count++;

    final minAmount = (_filters['minAmount'] as double?) ?? 0.0;
    final maxAmount = (_filters['maxAmount'] as double?) ?? 10000.0;
    if (minAmount > 0 || maxAmount < 10000) count++;

    return count;
  }
}
