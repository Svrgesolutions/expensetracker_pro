import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/income_chart_widget.dart';
import './widgets/insights_card_widget.dart';
import './widgets/net_worth_chart_widget.dart';
import './widgets/spending_chart_widget.dart';
import './widgets/time_period_selector_widget.dart';
import './widgets/trends_chart_widget.dart';

class FinancialInsights extends StatefulWidget {
  const FinancialInsights({super.key});

  @override
  State<FinancialInsights> createState() => _FinancialInsightsState();
}

class _FinancialInsightsState extends State<FinancialInsights>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = '1 Month';
  int _currentBottomIndex = 3; // Insights tab active
  bool _isLoading = false;

  final List<String> _tabTitles = ['Spending', 'Income', 'Net Worth', 'Trends'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabTitles.length, vsync: this);
    _loadInsightsData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadInsightsData() async {
    setState(() => _isLoading = true);

    // Simulate data loading
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Financial Insights',
        variant: CustomAppBarVariant.withActions,
        centerTitle: false,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: theme.appBarTheme.foregroundColor ??
                  theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _handleExportInsights,
            tooltip: 'Export Insights',
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: theme.appBarTheme.foregroundColor ??
                  theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _handleRefreshData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: _isLoading ? _buildLoadingState(theme) : _buildMainContent(theme),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: _handleBottomNavigation,
        variant: CustomBottomBarVariant.standard,
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 15.w,
            height: 15.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor:
                  AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            'Loading Financial Insights...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Analyzing your financial data',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(ThemeData theme) {
    return Column(
      children: [
        // Time Period Selector
        Container(
          color: theme.scaffoldBackgroundColor,
          child: TimePeriodSelectorWidget(
            selectedPeriod: _selectedPeriod,
            onPeriodChanged: _handlePeriodChange,
          ),
        ),

        // Tab Bar
        CustomTabBar(
          tabs: _tabTitles,
          currentIndex: _tabController.index,
          onTap: (index) {
            _tabController.animateTo(index);
            setState(() {});
          },
          variant: CustomTabBarVariant.segmented,
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSpendingTab(),
              _buildIncomeTab(),
              _buildNetWorthTab(),
              _buildTrendsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpendingTab() {
    return RefreshIndicator(
      onRefresh: _handleRefreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            SpendingChartWidget(
              selectedPeriod: _selectedPeriod,
              onCategoryTap: _handleCategoryTap,
            ),
            SizedBox(height: 3.h),
            InsightsCardWidget(selectedPeriod: _selectedPeriod),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeTab() {
    return RefreshIndicator(
      onRefresh: _handleRefreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            IncomeChartWidget(selectedPeriod: _selectedPeriod),
            SizedBox(height: 3.h),
            _buildIncomeInsights(),
          ],
        ),
      ),
    );
  }

  Widget _buildNetWorthTab() {
    return RefreshIndicator(
      onRefresh: _handleRefreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            NetWorthChartWidget(selectedPeriod: _selectedPeriod),
            SizedBox(height: 3.h),
            _buildNetWorthInsights(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsTab() {
    return RefreshIndicator(
      onRefresh: _handleRefreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          children: [
            TrendsChartWidget(selectedPeriod: _selectedPeriod),
            SizedBox(height: 3.h),
            _buildTrendInsights(),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeInsights() {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Income Insights',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildInsightItem(
            theme,
            'Steady Growth',
            'Your income has increased by 8.2% compared to last period',
            'trending_up',
            AppTheme.getSuccessColor(theme.brightness == Brightness.light),
          ),
          SizedBox(height: 1.h),
          _buildInsightItem(
            theme,
            'Diversification',
            'Freelance income contributes 16.8% to your total earnings',
            'work',
            const Color(0xFF4285F4),
          ),
          SizedBox(height: 1.h),
          _buildInsightItem(
            theme,
            'Investment Returns',
            'Investment income shows consistent monthly growth',
            'trending_up',
            const Color(0xFFFBBC04),
          ),
        ],
      ),
    );
  }

  Widget _buildNetWorthInsights() {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Net Worth Insights',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildInsightItem(
            theme,
            'Positive Trajectory',
            'Your net worth has grown by 21.5% over the selected period',
            'trending_up',
            AppTheme.getSuccessColor(theme.brightness == Brightness.light),
          ),
          SizedBox(height: 1.h),
          _buildInsightItem(
            theme,
            'Asset Allocation',
            'Investment accounts represent 47% of your total assets',
            'pie_chart',
            const Color(0xFF4285F4),
          ),
          SizedBox(height: 1.h),
          _buildInsightItem(
            theme,
            'Debt Reduction',
            'Total liabilities decreased by 8.9% through consistent payments',
            'trending_down',
            AppTheme.getSuccessColor(theme.brightness == Brightness.light),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendInsights() {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trend Analysis',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildInsightItem(
            theme,
            'Savings Rate',
            'Your average savings rate is 22.8%, above the recommended 20%',
            'savings',
            AppTheme.getSuccessColor(theme.brightness == Brightness.light),
          ),
          SizedBox(height: 1.h),
          _buildInsightItem(
            theme,
            'Spending Patterns',
            'Weekend spending is 35% higher than weekday averages',
            'calendar_today',
            AppTheme.warningLight,
          ),
          SizedBox(height: 1.h),
          _buildInsightItem(
            theme,
            'Goal Progress',
            'You\'re on track to meet 2 out of 3 financial goals this year',
            'flag',
            const Color(0xFF4285F4),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightItem(ThemeData theme, String title, String description,
      String icon, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: color,
            size: 20,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _handlePeriodChange(String period) {
    setState(() {
      _selectedPeriod = period;
    });
    _loadInsightsData();
  }

  void _handleCategoryTap(String category) {
    Navigator.pushNamed(context, '/transaction-list');
  }

  void _handleBottomNavigation(int index) {
    setState(() {
      _currentBottomIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/account-management');
        break;
      case 2:
        Navigator.pushNamed(context, '/transaction-list');
        break;
      case 3:
        // Already on insights screen
        break;
      case 4:
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }

  Future<void> _handleRefreshData() async {
    await _loadInsightsData();
  }

  void _handleExportInsights() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Export Insights',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'picture_as_pdf',
                  color: const Color(0xFFEA4335),
                  size: 24,
                ),
                title: const Text('Export as PDF'),
                subtitle: const Text('Complete insights report'),
                onTap: () {
                  Navigator.pop(context);
                  _exportAsPDF();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'image',
                  color: const Color(0xFF4285F4),
                  size: 24,
                ),
                title: const Text('Share Charts'),
                subtitle: const Text('Export charts as images'),
                onTap: () {
                  Navigator.pop(context);
                  _shareCharts();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'table_chart',
                  color: const Color(0xFF34A853),
                  size: 24,
                ),
                title: const Text('Export Data'),
                subtitle: const Text('CSV format for analysis'),
                onTap: () {
                  Navigator.pop(context);
                  _exportAsCSV();
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  void _exportAsPDF() {
    // Implement PDF export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF export feature coming soon')),
    );
  }

  void _shareCharts() {
    // Implement chart sharing functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chart sharing feature coming soon')),
    );
  }

  void _exportAsCSV() {
    // Implement CSV export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV export feature coming soon')),
    );
  }
}
