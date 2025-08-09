import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class IncomeChartWidget extends StatefulWidget {
  final String selectedPeriod;

  const IncomeChartWidget({
    super.key,
    required this.selectedPeriod,
  });

  @override
  State<IncomeChartWidget> createState() => _IncomeChartWidgetState();
}

class _IncomeChartWidgetState extends State<IncomeChartWidget> {
  final List<Map<String, dynamic>> incomeData = [
    {
      "month": "Jan",
      "salary": 5200.0,
      "freelance": 800.0,
      "investments": 150.0,
      "other": 50.0
    },
    {
      "month": "Feb",
      "salary": 5200.0,
      "freelance": 1200.0,
      "investments": 180.0,
      "other": 75.0
    },
    {
      "month": "Mar",
      "salary": 5200.0,
      "freelance": 950.0,
      "investments": 220.0,
      "other": 100.0
    },
    {
      "month": "Apr",
      "salary": 5200.0,
      "freelance": 1100.0,
      "investments": 190.0,
      "other": 80.0
    },
    {
      "month": "May",
      "salary": 5200.0,
      "freelance": 1350.0,
      "investments": 240.0,
      "other": 120.0
    },
    {
      "month": "Jun",
      "salary": 5200.0,
      "freelance": 900.0,
      "investments": 200.0,
      "other": 90.0
    }
  ];

  final List<Map<String, dynamic>> incomeCategories = [
    {
      "category": "Salary",
      "amount": 31200.0,
      "color": const Color(0xFF4285F4),
      "icon": "work",
      "percentage": 83.2
    },
    {
      "category": "Freelance",
      "amount": 6300.0,
      "color": const Color(0xFF34A853),
      "icon": "laptop",
      "percentage": 16.8
    },
    {
      "category": "Investments",
      "amount": 1180.0,
      "color": const Color(0xFFFBBC04),
      "icon": "trending_up",
      "percentage": 3.1
    },
    {
      "category": "Other",
      "amount": 515.0,
      "color": const Color(0xFFEA4335),
      "icon": "more_horiz",
      "percentage": 1.4
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
            Text('Income Analysis',
                style: theme.textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                    color: AppTheme.getSuccessColor(
                            theme.brightness == Brightness.light)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20)),
                child: Text(widget.selectedPeriod,
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.getSuccessColor(
                            theme.brightness == Brightness.light),
                        fontWeight: FontWeight.w500))),
          ]),
          SizedBox(height: 3.h),
          _buildIncomeChart(theme),
          SizedBox(height: 3.h),
          _buildIncomeBreakdown(theme),
        ]));
  }

  Widget _buildIncomeChart(ThemeData theme) {
    return SizedBox(
        height: 30.h,
        child: BarChart(BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 8000,
            barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String category = '';
                      switch (rodIndex) {
                        case 0:
                          category = 'Salary';
                          break;
                        case 1:
                          category = 'Freelance';
                          break;
                        case 2:
                          category = 'Investments';
                          break;
                        case 3:
                          category = 'Other';
                          break;
                      }
                      return BarTooltipItem(
                          '$category\n\$${rod.toY.toStringAsFixed(0)}',
                          TextStyle(
                              color: theme.colorScheme.onInverseSurface,
                              fontWeight: FontWeight.w500));
                    })),
            titlesData: FlTitlesData(
                show: true,
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < incomeData.length) {
                            return Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: Text(
                                    incomeData[value.toInt()]["month"]
                                        as String,
                                    style: theme.textTheme.bodySmall));
                          }
                          return const Text('');
                        },
                        reservedSize: 30)),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 2000,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${(value / 1000).toStringAsFixed(0)}k',
                              style: theme.textTheme.bodySmall);
                        },
                        reservedSize: 40))),
            borderData: FlBorderData(show: false),
            barGroups: _buildBarGroups(),
            gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 2000,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      strokeWidth: 1);
                }))));
  }

  List<BarChartGroupData> _buildBarGroups() {
    return incomeData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;

      return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
                toY: data["salary"] as double,
                color: const Color(0xFF4285F4),
                width: 2.w,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4))),
            BarChartRodData(
                toY: data["freelance"] as double,
                color: const Color(0xFF34A853),
                width: 2.w,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4))),
            BarChartRodData(
                toY: data["investments"] as double,
                color: const Color(0xFFFBBC04),
                width: 2.w,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4))),
            BarChartRodData(
                toY: data["other"] as double,
                color: const Color(0xFFEA4335),
                width: 2.w,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4))),
          ],
          barsSpace: 1.w);
    }).toList();
  }

  Widget _buildIncomeBreakdown(ThemeData theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Income Sources',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      ...incomeCategories.map((category) {
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
                    Text('${category["percentage"]}% of total income',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                  ])),
              Text('\$${(category["amount"] as double).toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.getSuccessColor(
                          theme.brightness == Brightness.light))),
            ]));
      }),
    ]);
  }
}
