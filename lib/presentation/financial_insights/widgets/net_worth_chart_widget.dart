import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class NetWorthChartWidget extends StatefulWidget {
  final String selectedPeriod;

  const NetWorthChartWidget({
    super.key,
    required this.selectedPeriod,
  });

  @override
  State<NetWorthChartWidget> createState() => _NetWorthChartWidgetState();
}

class _NetWorthChartWidgetState extends State<NetWorthChartWidget> {
  final List<Map<String, dynamic>> netWorthData = [
    {
      "month": "Jan",
      "assets": 125000.0,
      "liabilities": 45000.0,
      "netWorth": 80000.0
    },
    {
      "month": "Feb",
      "assets": 127500.0,
      "liabilities": 44200.0,
      "netWorth": 83300.0
    },
    {
      "month": "Mar",
      "assets": 130200.0,
      "liabilities": 43400.0,
      "netWorth": 86800.0
    },
    {
      "month": "Apr",
      "assets": 132800.0,
      "liabilities": 42600.0,
      "netWorth": 90200.0
    },
    {
      "month": "May",
      "assets": 135500.0,
      "liabilities": 41800.0,
      "netWorth": 93700.0
    },
    {
      "month": "Jun",
      "assets": 138200.0,
      "liabilities": 41000.0,
      "netWorth": 97200.0
    },
  ];

  final List<Map<String, dynamic>> assetBreakdown = [
    {
      "category": "Investment Accounts",
      "amount": 65000.0,
      "color": const Color(0xFF4285F4),
      "icon": "trending_up",
      "change": 5.2
    },
    {
      "category": "Checking & Savings",
      "amount": 28500.0,
      "color": const Color(0xFF34A853),
      "icon": "account_balance",
      "change": 2.1
    },
    {
      "category": "Real Estate",
      "amount": 35000.0,
      "color": const Color(0xFFFBBC04),
      "icon": "home",
      "change": 1.8
    },
    {
      "category": "Vehicles",
      "amount": 9700.0,
      "color": const Color(0xFFEA4335),
      "icon": "directions_car",
      "change": -2.5
    }
  ];

  final List<Map<String, dynamic>> liabilityBreakdown = [
    {
      "category": "Mortgage",
      "amount": 28500.0,
      "color": const Color(0xFF9C27B0),
      "icon": "home",
      "change": -1.2
    },
    {
      "category": "Credit Cards",
      "amount": 8200.0,
      "color": const Color(0xFFFF5722),
      "icon": "credit_card",
      "change": -5.8
    },
    {
      "category": "Auto Loan",
      "amount": 4300.0,
      "color": const Color(0xFF607D8B),
      "icon": "directions_car",
      "change": -3.2
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentNetWorth = netWorthData.last["netWorth"] as double;
    final previousNetWorth =
        netWorthData[netWorthData.length - 2]["netWorth"] as double;
    final netWorthChange =
        ((currentNetWorth - previousNetWorth) / previousNetWorth * 100);

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
            Text('Net Worth Tracking',
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
          _buildNetWorthSummary(theme, currentNetWorth, netWorthChange),
          SizedBox(height: 3.h),
          _buildNetWorthChart(theme),
          SizedBox(height: 3.h),
          _buildAssetLiabilityBreakdown(theme),
        ]));
  }

  Widget _buildNetWorthSummary(
      ThemeData theme, double currentNetWorth, double change) {
    final isPositive = change >= 0;

    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.primary.withValues(alpha: 0.05),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Current Net Worth',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          SizedBox(height: 1.h),
          Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text('\$${currentNetWorth.toStringAsFixed(0)}',
                style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary)),
            SizedBox(width: 2.w),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                    color: isPositive
                        ? AppTheme.getSuccessColor(
                                theme.brightness == Brightness.light)
                            .withValues(alpha: 0.1)
                        : AppTheme.warningLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  CustomIconWidget(
                      iconName: isPositive ? 'trending_up' : 'trending_down',
                      color: isPositive
                          ? AppTheme.getSuccessColor(
                              theme.brightness == Brightness.light)
                          : AppTheme.warningLight,
                      size: 14),
                  SizedBox(width: 1.w),
                  Text('${isPositive ? '+' : ''}${change.toStringAsFixed(1)}%',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: isPositive
                              ? AppTheme.getSuccessColor(
                                  theme.brightness == Brightness.light)
                              : AppTheme.warningLight,
                          fontWeight: FontWeight.w600)),
                ])),
          ]),
        ]));
  }

  Widget _buildNetWorthChart(ThemeData theme) {
    return SizedBox(
        height: 25.h,
        child: LineChart(LineChartData(
            gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 20000,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      strokeWidth: 1);
                }),
            titlesData: FlTitlesData(
                show: true,
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < netWorthData.length) {
                            return Padding(
                                padding: EdgeInsets.only(top: 1.h),
                                child: Text(
                                    netWorthData[value.toInt()]["month"]
                                        as String,
                                    style: theme.textTheme.bodySmall));
                          }
                          return const Text('');
                        })),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true,
                        interval: 20000,
                        reservedSize: 50,
                        getTitlesWidget: (value, meta) {
                          return Text('\$${(value / 1000).toStringAsFixed(0)}k',
                              style: theme.textTheme.bodySmall);
                        }))),
            borderData: FlBorderData(show: false),
            minX: 0,
            maxX: (netWorthData.length - 1).toDouble(),
            minY: 60000,
            maxY: 120000,
            lineBarsData: [
              LineChartBarData(
                  spots: netWorthData.asMap().entries.map((entry) {
                    return FlSpot(entry.key.toDouble(),
                        entry.value["netWorth"] as double);
                  }).toList(),
                  isCurved: true,
                  gradient: LinearGradient(colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.7),
                  ]),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                            radius: 4,
                            color: theme.colorScheme.primary,
                            strokeWidth: 2,
                            strokeColor: theme.colorScheme.surface);
                      }),
                  belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withValues(alpha: 0.2),
                            theme.colorScheme.primary.withValues(alpha: 0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter))),
            ],
            lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        final flSpot = barSpot;
                        return LineTooltipItem(
                            'Net Worth\n\$${flSpot.y.toStringAsFixed(0)}',
                            TextStyle(
                                color: theme.colorScheme.onInverseSurface,
                                fontWeight: FontWeight.w500));
                      }).toList();
                    })))));
  }

  Widget _buildAssetLiabilityBreakdown(ThemeData theme) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Assets & Liabilities',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w600)),
      SizedBox(height: 2.h),
      Row(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Assets',
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.getSuccessColor(
                      theme.brightness == Brightness.light))),
          SizedBox(height: 1.h),
          ...assetBreakdown
              .map((asset) => _buildBreakdownItem(theme, asset, true)),
        ])),
        SizedBox(width: 4.w),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Liabilities',
              style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600, color: AppTheme.warningLight)),
          SizedBox(height: 1.h),
          ...liabilityBreakdown
              .map((liability) => _buildBreakdownItem(theme, liability, false)),
        ])),
      ]),
    ]);
  }

  Widget _buildBreakdownItem(
      ThemeData theme, Map<String, dynamic> item, bool isAsset) {
    final change = item["change"] as double;
    final isPositiveChange = change >= 0;

    return Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CustomIconWidget(
                iconName: item["icon"] as String,
                color: item["color"] as Color,
                size: 16),
            SizedBox(width: 2.w),
            Expanded(
                child: Text(item["category"] as String,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis)),
          ]),
          SizedBox(height: 0.5.h),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('\$${(item["amount"] as double).toStringAsFixed(0)}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            Text('${isPositiveChange ? '+' : ''}${change.toStringAsFixed(1)}%',
                style: theme.textTheme.bodySmall?.copyWith(
                    color: isPositiveChange
                        ? AppTheme.getSuccessColor(
                            theme.brightness == Brightness.light)
                        : AppTheme.warningLight,
                    fontWeight: FontWeight.w500)),
          ]),
        ]));
  }
}
