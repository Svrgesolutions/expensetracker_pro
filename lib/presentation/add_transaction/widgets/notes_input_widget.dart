import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class NotesInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const NotesInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<NotesInputWidget> createState() => _NotesInputWidgetState();
}

class _NotesInputWidgetState extends State<NotesInputWidget> {
  final List<String> _commonTags = [
    'Business',
    'Personal',
    'Tax Deductible',
    'Reimbursable',
    'Gift',
    'Subscription',
    'One-time',
    'Monthly',
    'Emergency',
    'Planned',
  ];

  List<String> _selectedTags = [];

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notes & Tags (Optional)',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: widget.controller,
            maxLines: 3,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: 'Add notes about this transaction...',
              hintStyle: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.only(top: 3.w, left: 3.w, right: 3.w),
                child: CustomIconWidget(
                  iconName: 'note_add',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            ),
            onChanged: widget.onChanged,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'Quick Tags',
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _commonTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);

            return GestureDetector(
              onTap: () => _toggleTag(tag),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary.withValues(alpha: 0.1)
                      : theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (_selectedTags.isNotEmpty) ...[
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Tags:',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 1.w,
                  runSpacing: 0.5.h,
                  children: _selectedTags.map((tag) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            tag,
                            style: GoogleFonts.inter(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          SizedBox(width: 1.w),
                          GestureDetector(
                            onTap: () => _toggleTag(tag),
                            child: CustomIconWidget(
                              iconName: 'close',
                              color: theme.colorScheme.onPrimary,
                              size: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  List<String> get selectedTags => _selectedTags;
}
