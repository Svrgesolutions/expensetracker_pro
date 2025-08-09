import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrendsChartWidget extends StatefulWidget {
  final String selectedPeriod;

  const TrendsChartWidget({
    super.key,
    required this.selectedPeriod,
  });

  @override
  State<TrendsChartWidget> createState() => _TrendsChartWidgetState();
}

class _TrendsChartWidgetState extends State<TrendsChartWidget> {
  final List<Map<String, dynamic>> monthlyTrends = [
    {"month": "Jan", "income": 6200.0, "expenses": 4850.0, "savings": 1350.0},
    {"month": "Feb", "income": 6655.0, "expenses": 5120.0, "savings": 1535.0},
    {"month": "Mar", "income": 6470.0, "expenses": 4980.0, "savings": 1490.0},
    {"month": "Apr", "income": 6570.0, "expenses": 5200.0, "savings": 1370.0},
    {"month": "May", "income": 6910.0, "expenses": 5350.0, "savings": 1560.0},
    {"month": "Jun", "income": 6390.0, "expenses": 5100.0, "savings": 1290.0},
  ];

  final List<Map<String, dynamic>> categoryTrends = [
    {
      "category": "Food & Dining",
      "currentMonth": 1250.50,
      "previousMonth": 1180.25,
      "trend": 5.9,
      "color": const Color(0xFF4285F4),
      "icon": "restaurant"
    },
    {
      "category": "Transportation",
      "currentMonth": 850.75,
      "previousMonth": 920.40,
      "trend": -7.6,
      "color": const Color(0xFF34A853),
      "icon": "directions_car"
    },
    {
      "category": "Shopping",
      "currentMonth": 720.25,
      "previousMonth": 650.80,
      "trend": 10.7,
      "color": const Color(0xFFEA4335),
      "icon": "shopping_bag"
    },
    {
      "category": "Entertainment",
      "currentMonth": 480.00,
      "previousMonth": 520.15,
      "trend": -7.7,
      "color": const Color(0xFFFBBC04),
      "icon": "movie"
    },
    {
      "category": "Utilities",
      "currentMonth": 420.30,
      "previousMonth": 415.60,
      "trend": 1.1,
      "color": const Color(0xFF9C27B0),
      "icon": "electrical_services"
    }
  ];

  final List<Map<String, dynamic>> savingsGoals = [
    {
      "goal": "Emergency Fund",
      "target": 15000.0,
      "current": 8500.0,
      "monthlyContribution": 750.0,
      "color": const Color(0xFF4285F4),
      "icon": "security"
    },
    {
      "goal": "Vacation Fund",
      "target": 5000.0,
      "current": 2800.0,
      "monthlyContribution": 400.0,
      "color": const Color(0xFF34A853),
      "icon": "flight"
    },
    {
      "goal": "New Car",
      "target": 25000.0,
      "current": 12500.0,
      "monthlyContribution": 800.0,
      "color": const Color(0xFFFBBC04),
      "icon": "directions_car"
    }
  ];

  @override
  Widget build(BuildContext context) {
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
                  offset: const Offset(0, 2)),
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Financial Trends',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(widget.selectedPeriod,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500))),
          ]),
          SizedBox(height: 3.h),
          _buildIncomeExpenseChart(theme),
          SizedBox(height: 3.h),
          _buildCategoryTrends(theme),
          SizedBox(height: 3.h),
          _buildSavingsGoals(theme),
        ]));
  }

  Widget _buildIncomeExpenseChart(ThemeData theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Income vs Expenses Trend',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      SizedBox(
          height: 25.h,
          child: LineChart(LineChartData(
              gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        strokeWidth: 1);
                  }),
              titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < monthlyTrends.length) {
                              return Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: Text(
                                      monthlyTrends[value.toInt()]["month"]
                                          as String,
                                      style: theme.textTheme.bodySmall));
                            }
                            return const Text('');
                          })),
                  leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1000,
                          reservedSize: 50,
                          getTitlesWidget: (value, meta) {
                            return Text(
                                '\$${(value / 1000).toStringAsFixed(0)}k',
                                style: theme.textTheme.bodySmall);
                          }))),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (monthlyTrends.length - 1).toDouble(),
              minY: 3000,
              maxY: 8000,
              lineBarsData: [
                // Income line
                LineChartBarData(
                    spots: monthlyTrends.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(),
                          entry.value["income"] as double);
                    }).toList(),
                    isCurved: true,
                    color: AppTheme.getSuccessColor(
                        theme.brightness == Brightness.light),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                              radius: 4,
                              color: AppTheme.getSuccessColor(
                                  theme.brightness == Brightness.light),
                              strokeWidth: 2,
                              strokeColor: theme.colorScheme.surface);
                        })),
                // Expenses line
                LineChartBarData(
                    spots: monthlyTrends.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(),
                          entry.value["expenses"] as double);
                    }).toList(),
                    isCurved: true,
                    color: AppTheme.warningLight,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                              radius: 4,
                              color: AppTheme.warningLight,
                              strokeWidth: 2,
                              strokeColor: theme.colorScheme.surface);
                        })),
              ],
              lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                      tooltipRoundedRadius: 8,
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final flSpot = barSpot;
                          final isIncome = barSpot.barIndex == 0;
                          return LineTooltipItem(
                              '${isIncome ? 'Income' : 'Expenses'}\n\$${flSpot.y.toStringAsFixed(0)}',
                              TextStyle(
                                  color: theme.colorScheme.onInverseSurface,
                                  fontWeight: FontWeight.w500));
                        }).toList();
                      }))))),
      SizedBox(height: 2.h),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        _buildLegendItem(theme, 'Income',
            AppTheme.getSuccessColor(theme.brightness == Brightness.light)),
        SizedBox(width: 6.w),
        _buildLegendItem(theme, 'Expenses', AppTheme.warningLight),
      ]),
    ]);
  }

  Widget _buildLegendItem(ThemeData theme, String label, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      SizedBox(width: 2.w),
      Text(label,
          style:
              theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
    ]);
  }

  Widget _buildCategoryTrends(ThemeData theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Category Trends',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      ...categoryTrends.map((category) {
        final trend = category["trend"] as double;
        final isPositive = trend >= 0;

        return Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2))),
            child: Row(children: [
              Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                      color:
                          (category["color"] as Color).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8)),
                  child: CustomIconWidget(
                      iconName: category["icon"] as String,
                      color: category["color"] as Color,
                      size: 20)),
              SizedBox(width: 3.w),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(category["category"] as String,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500)),
                    Text(
                        'This month: \$${(category["currentMonth"] as double).toStringAsFixed(2)}',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                  ])),
              Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                      color: isPositive
                          ? AppTheme.warningLight.withValues(alpha: 0.1)
                          : AppTheme.getSuccessColor(
                                  theme.brightness == Brightness.light)
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    CustomIconWidget(
                        iconName: isPositive ? 'trending_up' : 'trending_down',
                        color: isPositive
                            ? AppTheme.warningLight
                            : AppTheme.getSuccessColor(
                                theme.brightness == Brightness.light),
                        size: 14),
                    SizedBox(width: 1.w),
                    Text('${isPositive ? '+' : ''}${trend.toStringAsFixed(1)}%',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: isPositive
                                ? AppTheme.warningLight
                                : AppTheme.getSuccessColor(
                                    theme.brightness == Brightness.light),
                            fontWeight: FontWeight.w600)),
                  ])),
            ]));
      }),
    ]);
  }

  Widget _buildSavingsGoals(ThemeData theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Savings Goals Progress',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      ...savingsGoals.map((goal) {
        final progress =
            (goal["current"] as double) / (goal["target"] as double);
        final remainingMonths =
            ((goal["target"] as double) - (goal["current"] as double)) /
                (goal["monthlyContribution"] as double);

        return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2))),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                        color: (goal["color"] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8)),
                    child: CustomIconWidget(
                        iconName: goal["icon"] as String,
                        color: goal["color"] as Color,
                        size: 20)),
                SizedBox(width: 3.w),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(goal["goal"] as String,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600)),
                      Text(
                          '\$${(goal["current"] as double).toStringAsFixed(0)} of \$${(goal["target"] as double).toStringAsFixed(0)}',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                    ])),
                Text('${(progress * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: goal["color"] as Color)),
              ]),
              SizedBox(height: 2.h),
              LinearProgressIndicator(
                  value: progress,
                  backgroundColor:
                      theme.colorScheme.outline.withValues(alpha: 0.2),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(goal["color"] as Color),
                  minHeight: 8),
              SizedBox(height: 1.h),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(
                    '\$${(goal["monthlyContribution"] as double).toStringAsFixed(0)}/month',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                Text('${remainingMonths.ceil()} months remaining',
                    style: theme.textTheme.bodySmall
                        ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ]),
            ]));
      }),
    ]);
  }
}
