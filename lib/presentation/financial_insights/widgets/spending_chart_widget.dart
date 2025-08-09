import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SpendingChartWidget extends StatefulWidget {
  final String selectedPeriod;
  final Function(String) onCategoryTap;

  const SpendingChartWidget({
    super.key,
    required this.selectedPeriod,
    required this.onCategoryTap,
  });

  @override
  State<SpendingChartWidget> createState() => _SpendingChartWidgetState();
}

class _SpendingChartWidgetState extends State<SpendingChartWidget> {
  int touchedIndex = -1;

  final List<Map<String, dynamic>> spendingData = [
    {
      "category": "Food & Dining",
      "amount": 1250.50,
      "percentage": 28.5,
      "color": const Color(0xFF4285F4),
      "icon": "restaurant",
      "transactions": 45
    },
    {
      "category": "Transportation",
      "amount": 850.75,
      "percentage": 19.4,
      "color": const Color(0xFF34A853),
      "icon": "directions_car",
      "transactions": 28
    },
    {
      "category": "Shopping",
      "amount": 720.25,
      "percentage": 16.4,
      "color": const Color(0xFFEA4335),
      "icon": "shopping_bag",
      "transactions": 32
    },
    {
      "category": "Entertainment",
      "amount": 480.00,
      "percentage": 10.9,
      "color": const Color(0xFFFBBC04),
      "icon": "movie",
      "transactions": 18
    },
    {
      "category": "Utilities",
      "amount": 420.30,
      "percentage": 9.6,
      "color": const Color(0xFF9C27B0),
      "icon": "electrical_services",
      "transactions": 12
    },
    {
      "category": "Healthcare",
      "amount": 380.20,
      "percentage": 8.7,
      "color": const Color(0xFF00BCD4),
      "icon": "local_hospital",
      "transactions": 8
    },
    {
      "category": "Other",
      "amount": 295.00,
      "percentage": 6.7,
      "color": const Color(0xFF607D8B),
      "icon": "more_horiz",
      "transactions": 15
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
            offset: const Offset(0, 2),
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
                'Spending Breakdown',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.selectedPeriod,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          SizedBox(
            height: 35.h,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 8.w,
                      sections: _buildPieChartSections(),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _buildLegendItems(theme),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          _buildCategoryList(theme),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    return spendingData.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 14.sp : 12.sp;
      final radius = isTouched ? 12.w : 10.w;

      return PieChartSectionData(
        color: data["color"] as Color,
        value: data["percentage"] as double,
        title: '${data["percentage"]}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  List<Widget> _buildLegendItems(ThemeData theme) {
    return spendingData.take(5).map((data) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 0.5.h),
        child: Row(
          children: [
            Container(
              width: 3.w,
              height: 3.w,
              decoration: BoxDecoration(
                color: data["color"] as Color,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["category"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${(data["amount"] as double).toStringAsFixed(0)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Widget _buildCategoryList(ThemeData theme) {
    return Column(
      children: spendingData.map((data) {
        return GestureDetector(
          onTap: () => widget.onCategoryTap(data["category"] as String),
          child: Container(
            margin: EdgeInsets.only(bottom: 1.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: (data["color"] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: data["icon"] as String,
                    color: data["color"] as Color,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["category"] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${data["transactions"]} transactions',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${(data["amount"] as double).toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${data["percentage"]}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
