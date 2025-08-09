import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CategorySelectorWidget extends StatefulWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;
  final String? errorText;

  const CategorySelectorWidget({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
    this.errorText,
  });

  @override
  State<CategorySelectorWidget> createState() => _CategorySelectorWidgetState();
}

class _CategorySelectorWidgetState extends State<CategorySelectorWidget> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Food & Dining', 'icon': 'restaurant', 'color': Colors.orange},
    {'name': 'Transportation', 'icon': 'directions_car', 'color': Colors.blue},
    {'name': 'Shopping', 'icon': 'shopping_bag', 'color': Colors.purple},
    {'name': 'Entertainment', 'icon': 'movie', 'color': Colors.red},
    {'name': 'Bills & Utilities', 'icon': 'receipt', 'color': Colors.green},
    {'name': 'Healthcare', 'icon': 'local_hospital', 'color': Colors.teal},
    {'name': 'Education', 'icon': 'school', 'color': Colors.indigo},
    {'name': 'Travel', 'icon': 'flight', 'color': Colors.cyan},
    {'name': 'Personal Care', 'icon': 'spa', 'color': Colors.pink},
    {'name': 'Home & Garden', 'icon': 'home', 'color': Colors.brown},
    {'name': 'Income', 'icon': 'attach_money', 'color': Colors.green},
    {'name': 'Investments', 'icon': 'trending_up', 'color': Colors.deepPurple},
  ];

  List<Map<String, dynamic>> _recentCategories = [];
  bool _showAllCategories = false;

  @override
  void initState() {
    super.initState();
    _recentCategories = _categories.take(6).toList();
  }

  void _showCategoryModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildCategoryModal(),
    );
  }

  Widget _buildCategoryModal() {
    final theme = Theme.of(context);

    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: EdgeInsets.symmetric(vertical: 3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Select Category',
                  style: GoogleFonts.inter(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 2.h,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = widget.selectedCategory == category['name'];

                return GestureDetector(
                  onTap: () {
                    widget.onCategorySelected(category['name']);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: (category['color'] as Color)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: CustomIconWidget(
                            iconName: category['icon'],
                            color: category['color'],
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            category['name'],
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: _showCategoryModal,
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.errorText != null
                    ? theme.colorScheme.error
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                if (widget.selectedCategory != null) ...[
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _categories
                          .firstWhere((cat) =>
                              cat['name'] == widget.selectedCategory)['color']
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: _categories.firstWhere((cat) =>
                          cat['name'] == widget.selectedCategory)['icon'],
                      color: _categories.firstWhere((cat) =>
                          cat['name'] == widget.selectedCategory)['color'],
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      widget.selectedCategory!,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ] else ...[
                  CustomIconWidget(
                    iconName: 'category',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Select category',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
                CustomIconWidget(
                  iconName: 'keyboard_arrow_down',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: 1.h),
          Text(
            widget.errorText!,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.error,
            ),
          ),
        ],
        SizedBox(height: 2.h),
        Text(
          'Recent Categories',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 6.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _recentCategories.length,
            separatorBuilder: (context, index) => SizedBox(width: 2.w),
            itemBuilder: (context, index) {
              final category = _recentCategories[index];
              final isSelected = widget.selectedCategory == category['name'];

              return GestureDetector(
                onTap: () => widget.onCategorySelected(category['name']),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.1)
                        : theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: category['icon'],
                        color: isSelected
                            ? theme.colorScheme.primary
                            : category['color'],
                        size: 16,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        category['name'],
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
