import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InsightsCardWidget extends StatelessWidget {
  final String selectedPeriod;

  const InsightsCardWidget({
    super.key,
    required this.selectedPeriod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> insights = [
      {
        "title": "Highest Spending Category",
        "description":
            "Food & Dining accounts for 28.5% of your total spending this month",
        "value": "\$1,250.50",
        "icon": "restaurant",
        "color": const Color(0xFF4285F4),
        "trend": "up",
        "actionText": "View Details"
      },
      {
        "title": "Unusual Transaction Alert",
        "description":
            "Your shopping expenses increased by 45% compared to last month",
        "value": "+\$320.25",
        "icon": "warning",
        "color": const Color(0xFFEA4335),
        "trend": "warning",
        "actionText": "Review Transactions"
      },
      {
        "title": "Subscription Renewals",
        "description": "3 subscriptions are renewing in the next 7 days",
        "value": "\$89.97",
        "icon": "subscriptions",
        "color": const Color(0xFFFBBC04),
        "trend": "neutral",
        "actionText": "Manage Subscriptions"
      },
      {
        "title": "Savings Opportunity",
        "description":
            "You could save \$150/month by optimizing recurring expenses",
        "value": "\$150.00",
        "icon": "savings",
        "color": const Color(0xFF34A853),
        "trend": "down",
        "actionText": "See Recommendations"
      },
      {
        "title": "Budget Performance",
        "description": "You're 15% under budget for entertainment this month",
        "value": "-\$72.00",
        "icon": "assessment",
        "color": const Color(0xFF9C27B0),
        "trend": "down",
        "actionText": "View Budget"
      },
      {
        "title": "Cash Flow Analysis",
        "description": "Your average daily spending decreased by 8% this week",
        "value": "-\$12.50",
        "icon": "trending_down",
        "color": const Color(0xFF00BCD4),
        "trend": "down",
        "actionText": "View Analysis"
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Key Insights',
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
                  selectedPeriod,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 20.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: insights.length,
            itemBuilder: (context, index) {
              final insight = insights[index];
              return _buildInsightCard(context, theme, insight, index == 0);
            },
          ),
        ),
        SizedBox(height: 3.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: _buildDetailedInsights(theme),
        ),
      ],
    );
  }

  Widget _buildInsightCard(BuildContext context, ThemeData theme,
      Map<String, dynamic> insight, bool isFirst) {
    return Container(
      width: 70.w,
      margin:
          EdgeInsets.only(right: isFirst ? 3.w : 0, left: isFirst ? 0 : 3.w),
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
        border: Border.all(
          color: (insight["color"] as Color).withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: (insight["color"] as Color).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: insight["icon"] as String,
                  color: insight["color"] as Color,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight["title"] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      insight["value"] as String,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: insight["color"] as Color,
                      ),
                    ),
                  ],
                ),
              ),
              _buildTrendIcon(theme, insight["trend"] as String),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            insight["description"] as String,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => _handleInsightAction(
                  context, insight["actionText"] as String),
              style: TextButton.styleFrom(
                backgroundColor:
                    (insight["color"] as Color).withValues(alpha: 0.1),
                foregroundColor: insight["color"] as Color,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                insight["actionText"] as String,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendIcon(ThemeData theme, String trend) {
    IconData iconData;
    Color iconColor;

    switch (trend) {
      case 'up':
        iconData = Icons.trending_up;
        iconColor = AppTheme.warningLight;
        break;
      case 'down':
        iconData = Icons.trending_down;
        iconColor =
            AppTheme.getSuccessColor(theme.brightness == Brightness.light);
        break;
      case 'warning':
        iconData = Icons.warning_outlined;
        iconColor = AppTheme.warningLight;
        break;
      default:
        iconData = Icons.remove;
        iconColor = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      padding: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: CustomIconWidget(
        iconName: iconData.codePoint.toString(),
        color: iconColor,
        size: 16,
      ),
    );
  }

  Widget _buildDetailedInsights(ThemeData theme) {
    final List<Map<String, dynamic>> detailedInsights = [
      {
        "title": "Spending Velocity Analysis",
        "description":
            "Your spending rate has decreased by 12% in the last 2 weeks, indicating better financial discipline.",
        "icon": "speed",
        "color": const Color(0xFF34A853),
      },
      {
        "title": "Category Trend Alert",
        "description":
            "Transportation costs are trending upward. Consider carpooling or public transport to reduce expenses.",
        "icon": "trending_up",
        "color": const Color(0xFFFBBC04),
      },
      {
        "title": "Budget Variance Report",
        "description":
            "You're currently 8% over budget for the month. Focus on reducing discretionary spending.",
        "icon": "assessment",
        "color": const Color(0xFFEA4335),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Analysis',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        ...detailedInsights.map((insight) {
          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: (insight["color"] as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: insight["icon"] as String,
                    color: insight["color"] as Color,
                    size: 20,
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insight["title"] as String,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        insight["description"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  void _handleInsightAction(BuildContext context, String actionText) {
    switch (actionText) {
      case 'View Details':
        Navigator.pushNamed(context, '/transaction-list');
        break;
      case 'Review Transactions':
        Navigator.pushNamed(context, '/transaction-list');
        break;
      case 'Manage Subscriptions':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'See Recommendations':
        Navigator.pushNamed(context, '/financial-insights');
        break;
      case 'View Budget':
        Navigator.pushNamed(context, '/dashboard');
        break;
      case 'View Analysis':
        Navigator.pushNamed(context, '/financial-insights');
        break;
      default:
        break;
    }
  }
}
