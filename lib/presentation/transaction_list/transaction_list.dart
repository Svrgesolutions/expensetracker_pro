import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/date_section_header_widget.dart';
import './widgets/filter_modal_widget.dart';
import './widgets/transaction_detail_modal_widget.dart';
import './widgets/transaction_item_widget.dart';
import './widgets/transaction_search_bar_widget.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> _filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMockData() {
    final List<Map<String, dynamic>> mockTransactions = [
      {
        "id": 1,
        "merchant": "Starbucks Coffee",
        "amount": -5.47,
        "category": "Food & Dining",
        "categoryIcon": "local_cafe",
        "account": "Chase Freedom",
        "date": DateTime.now().subtract(const Duration(hours: 2)),
        "note": "Morning coffee with Sarah",
        "isBusinessExpense": false,
        "receiptUrl":
            "https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400&h=600&fit=crop",
      },
      {
        "id": 2,
        "merchant": "Salary Deposit",
        "amount": 3250.00,
        "category": "Income",
        "categoryIcon": "attach_money",
        "account": "First Hawaiian Checking",
        "date": DateTime.now().subtract(const Duration(days: 1)),
        "note": "",
        "isBusinessExpense": false,
        "receiptUrl": null,
      },
      {
        "id": 3,
        "merchant": "Shell Gas Station",
        "amount": -42.18,
        "category": "Transportation",
        "categoryIcon": "local_gas_station",
        "account": "Chase Freedom",
        "date": DateTime.now().subtract(const Duration(days: 1)),
        "note": "",
        "isBusinessExpense": true,
        "receiptUrl": null,
      },
      {
        "id": 4,
        "merchant": "Amazon Purchase",
        "amount": -89.99,
        "category": "Shopping",
        "categoryIcon": "shopping_bag",
        "account": "Chase Freedom",
        "date": DateTime.now().subtract(const Duration(days: 2)),
        "note": "Office supplies for home office",
        "isBusinessExpense": true,
        "receiptUrl":
            "https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=400&h=600&fit=crop",
      },
      {
        "id": 5,
        "merchant": "Netflix Subscription",
        "amount": -15.99,
        "category": "Entertainment",
        "categoryIcon": "movie",
        "account": "First Hawaiian Checking",
        "date": DateTime.now().subtract(const Duration(days: 3)),
        "note": "",
        "isBusinessExpense": false,
        "receiptUrl": null,
      },
      {
        "id": 6,
        "merchant": "Uber Ride",
        "amount": -23.45,
        "category": "Transportation",
        "categoryIcon": "directions_car",
        "account": "Chase Freedom",
        "date": DateTime.now().subtract(const Duration(days: 3)),
        "note": "Airport pickup",
        "isBusinessExpense": false,
        "receiptUrl": null,
      },
      {
        "id": 7,
        "merchant": "Whole Foods Market",
        "amount": -127.83,
        "category": "Food & Dining",
        "categoryIcon": "local_grocery_store",
        "account": "Chase Freedom",
        "date": DateTime.now().subtract(const Duration(days: 4)),
        "note": "Weekly grocery shopping",
        "isBusinessExpense": false,
        "receiptUrl": null,
      },
      {
        "id": 8,
        "merchant": "Freelance Payment",
        "amount": 850.00,
        "category": "Income",
        "categoryIcon": "work",
        "account": "First Hawaiian Checking",
        "date": DateTime.now().subtract(const Duration(days: 5)),
        "note": "Web design project completion",
        "isBusinessExpense": false,
        "receiptUrl": null,
      },
      {
        "id": 9,
        "merchant": "Electric Bill",
        "amount": -98.45,
        "category": "Bills & Utilities",
        "categoryIcon": "flash_on",
        "account": "First Hawaiian Checking",
        "date": DateTime.now().subtract(const Duration(days: 6)),
        "note": "",
        "isBusinessExpense": false,
        "receiptUrl": null,
      },
      {
        "id": 10,
        "merchant": "Gym Membership",
        "amount": -49.99,
        "category": "Healthcare",
        "categoryIcon": "fitness_center",
        "account": "First Hawaiian Checking",
        "date": DateTime.now().subtract(const Duration(days: 7)),
        "note": "Monthly membership fee",
        "isBusinessExpense": false,
        "receiptUrl": null,
      },
      {
        "id": 11,
        "merchant": "Investment Transfer",
        "amount": -500.00,
        "category": "Transfer",
        "categoryIcon": "swap_horiz",
        "account": "Edward Jones Roth IRA",
        "date": DateTime.now().subtract(const Duration(days: 8)),
        "note": "Monthly investment contribution",
        "isBusinessExpense": false,
        "receiptUrl": null,
      },
      {
        "id": 12,
        "merchant": "Apple Store",
        "amount": -1299.00,
        "category": "Shopping",
        "categoryIcon": "phone_iphone",
        "account": "Chase Freedom",
        "date": DateTime.now().subtract(const Duration(days: 10)),
        "note": "New iPhone 15 Pro",
        "isBusinessExpense": false,
        "receiptUrl":
            "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=600&fit=crop",
      },
    ];

    setState(() {
      _transactions = mockTransactions;
      _filteredTransactions = mockTransactions;
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMoreData) {
        _loadMoreTransactions();
      }
    }
  }

  void _loadMoreTransactions() {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading more data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _currentPage++;
          if (_currentPage > 3) {
            _hasMoreData = false;
          }
        });
      }
    });
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _currentPage = 1;
        _hasMoreData = true;
      });
      _loadMockData();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onFiltersChanged(Map<String, dynamic> filters) {
    setState(() {
      _activeFilters = filters;
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_transactions);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((transaction) {
        final merchant = (transaction['merchant'] as String).toLowerCase();
        final note = (transaction['note'] as String? ?? '').toLowerCase();
        final amount = transaction['amount'].toString();
        final query = _searchQuery.toLowerCase();

        return merchant.contains(query) ||
            note.contains(query) ||
            amount.contains(query);
      }).toList();
    }

    // Apply account filter
    final selectedAccounts =
        (_activeFilters['accounts'] as List<String>?) ?? [];
    if (selectedAccounts.isNotEmpty) {
      filtered = filtered.where((transaction) {
        return selectedAccounts.contains(transaction['account']);
      }).toList();
    }

    // Apply category filter
    final selectedCategories =
        (_activeFilters['categories'] as List<String>?) ?? [];
    if (selectedCategories.isNotEmpty) {
      filtered = filtered.where((transaction) {
        return selectedCategories.contains(transaction['category']);
      }).toList();
    }

    // Apply date range filter
    final dateRange = _activeFilters['dateRange'] as String?;
    if (dateRange != null) {
      final now = DateTime.now();
      DateTime? startDate;

      switch (dateRange) {
        case 'Last 7 days':
          startDate = now.subtract(const Duration(days: 7));
          break;
        case 'Last 30 days':
          startDate = now.subtract(const Duration(days: 30));
          break;
        case 'Last 3 months':
          startDate = now.subtract(const Duration(days: 90));
          break;
        case 'Last 6 months':
          startDate = now.subtract(const Duration(days: 180));
          break;
        case 'This year':
          startDate = DateTime(now.year, 1, 1);
          break;
      }

      if (startDate != null) {
        filtered = filtered.where((transaction) {
          final transactionDate = transaction['date'] as DateTime;
          return transactionDate.isAfter(startDate!);
        }).toList();
      }
    }

    // Apply amount range filter
    final minAmount = (_activeFilters['minAmount'] as double?) ?? 0.0;
    final maxAmount = (_activeFilters['maxAmount'] as double?) ?? 10000.0;
    if (minAmount > 0 || maxAmount < 10000) {
      filtered = filtered.where((transaction) {
        final amount = (transaction['amount'] as double).abs();
        return amount >= minAmount && amount <= maxAmount;
      }).toList();
    }

    setState(() {
      _filteredTransactions = filtered;
    });
  }

  int _getActiveFilterCount() {
    int count = 0;

    final accounts = (_activeFilters['accounts'] as List<String>?) ?? [];
    if (accounts.isNotEmpty) count++;

    final categories = (_activeFilters['categories'] as List<String>?) ?? [];
    if (categories.isNotEmpty) count++;

    if (_activeFilters['dateRange'] != null) count++;

    final minAmount = (_activeFilters['minAmount'] as double?) ?? 0.0;
    final maxAmount = (_activeFilters['maxAmount'] as double?) ?? 10000.0;
    if (minAmount > 0 || maxAmount < 10000) count++;

    return count;
  }

  Map<DateTime, List<Map<String, dynamic>>> _groupTransactionsByDate() {
    final Map<DateTime, List<Map<String, dynamic>>> grouped = {};

    for (final transaction in _filteredTransactions) {
      final date = transaction['date'] as DateTime;
      final dateKey = DateTime(date.year, date.month, date.day);

      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(transaction);
    }

    return grouped;
  }

  void _showTransactionDetail(Map<String, dynamic> transaction) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => TransactionDetailModalWidget(
        transaction: transaction,
        onEdit: () => _editTransaction(transaction),
        onDelete: () => _deleteTransaction(transaction),
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => FilterModalWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: _onFiltersChanged,
      ),
    );
  }

  void _editTransaction(Map<String, dynamic> transaction) {
    Navigator.pushNamed(context, '/add-transaction', arguments: transaction);
  }

  void _deleteTransaction(Map<String, dynamic> transaction) {
    setState(() {
      _transactions.removeWhere((t) => t['id'] == transaction['id']);
      _applyFilters();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Transaction deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _transactions.add(transaction);
              _applyFilters();
            });
          },
        ),
      ),
    );
  }

  void _editCategory(Map<String, dynamic> transaction) {
    // Show category selection modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit category functionality')),
    );
  }

  void _addNote(Map<String, dynamic> transaction) {
    // Show note editing modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add note functionality')),
    );
  }

  void _markBusiness(Map<String, dynamic> transaction) {
    setState(() {
      transaction['isBusinessExpense'] =
          !(transaction['isBusinessExpense'] as bool? ?? false);
      _applyFilters();
    });

    final isNowBusiness = transaction['isBusinessExpense'] as bool;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isNowBusiness
            ? 'Marked as business expense'
            : 'Unmarked as business expense'),
      ),
    );
  }

  void _splitTransaction(Map<String, dynamic> transaction) {
    // Show split transaction modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Split transaction functionality')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedTransactions = _groupTransactionsByDate();
    final sortedDates = groupedTransactions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar and filters
            TransactionSearchBarWidget(
              initialQuery: _searchQuery,
              onSearchChanged: _onSearchChanged,
              onFilterTap: _showFilterModal,
              activeFilterCount: _getActiveFilterCount(),
            ),

            // Transaction list
            Expanded(
              child: _filteredTransactions.isEmpty
                  ? _buildEmptyState(theme)
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _calculateItemCount(sortedDates),
                        itemBuilder: (context, index) {
                          return _buildListItem(context, sortedDates, index);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add-transaction'),
        child: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onPrimary,
          size: 7.w,
        ),
      ),
    );
  }

  int _calculateItemCount(List<DateTime> sortedDates) {
    int count = 0;
    for (final date in sortedDates) {
      count++; // Date header
      count += _groupTransactionsByDate()[date]!.length; // Transactions
    }
    if (_isLoading) count++; // Loading indicator
    return count;
  }

  Widget _buildListItem(
      BuildContext context, List<DateTime> sortedDates, int index) {
    int currentIndex = 0;
    final groupedTransactions = _groupTransactionsByDate();

    for (final date in sortedDates) {
      if (currentIndex == index) {
        // Date header
        final transactions = groupedTransactions[date]!;
        final totalAmount = transactions.fold<double>(
            0.0, (sum, t) => sum + (t['amount'] as double));

        return DateSectionHeaderWidget(
          date: date,
          totalAmount: totalAmount,
          transactionCount: transactions.length,
        );
      }
      currentIndex++;

      final transactions = groupedTransactions[date]!;
      for (int i = 0; i < transactions.length; i++) {
        if (currentIndex == index) {
          // Transaction item
          return TransactionItemWidget(
            transaction: transactions[i],
            onTap: () => _showTransactionDetail(transactions[i]),
            onEditCategory: () => _editCategory(transactions[i]),
            onAddNote: () => _addNote(transactions[i]),
            onMarkBusiness: () => _markBusiness(transactions[i]),
            onSplitTransaction: () => _splitTransaction(transactions[i]),
            onDelete: () => _deleteTransaction(transactions[i]),
          );
        }
        currentIndex++;
      }
    }

    // Loading indicator
    if (_isLoading) {
      return Container(
        padding: EdgeInsets.all(4.w),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'receipt_long',
              color: theme.colorScheme.onSurfaceVariant,
              size: 20.w,
            ),
            SizedBox(height: 3.h),
            Text(
              _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                  ? 'No transactions found'
                  : 'No transactions yet',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              _searchQuery.isNotEmpty || _activeFilters.isNotEmpty
                  ? 'Try adjusting your search or filters'
                  : 'Connect your accounts or add transactions manually to get started',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            if (_searchQuery.isEmpty && _activeFilters.isEmpty) ...[
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/account-management'),
                icon: CustomIconWidget(
                  iconName: 'account_balance',
                  color: theme.colorScheme.onPrimary,
                  size: 5.w,
                ),
                label: const Text('Connect Account'),
              ),
              SizedBox(height: 2.h),
              OutlinedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, '/add-transaction'),
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                label: const Text('Add Transaction'),
              ),
            ] else ...[
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _activeFilters.clear();
                    _applyFilters();
                  });
                },
                icon: CustomIconWidget(
                  iconName: 'clear',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                label: const Text('Clear Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
