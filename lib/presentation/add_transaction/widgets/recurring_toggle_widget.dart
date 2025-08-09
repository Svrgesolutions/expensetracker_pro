import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecurringToggleWidget extends StatefulWidget {
  final bool isRecurring;
  final bool isBusinessExpense;
  final Function(bool) onRecurringChanged;
  final Function(bool) onBusinessExpenseChanged;

  const RecurringToggleWidget({
    super.key,
    required this.isRecurring,
    required this.isBusinessExpense,
    required this.onRecurringChanged,
    required this.onBusinessExpenseChanged,
  });

  @override
  State<RecurringToggleWidget> createState() => _RecurringToggleWidgetState();
}

class _RecurringToggleWidgetState extends State<RecurringToggleWidget> {
  String _recurringFrequency = 'Monthly';
  final List<String> _frequencies = ['Weekly', 'Monthly', 'Quarterly', 'Yearly'];

  void _showFrequencyModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFrequencyModal(),
    );
  }

  Widget _buildFrequencyModal() {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            child: Text(
              'Recurring Frequency',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          _frequencies.map((frequency) {
            final isSelected = _recurringFrequency == frequency;
            
            return ListTile(
              leading: Radio<String>(
                value: frequency,
                groupValue: _recurringFrequency,
                onChanged: (value) {
                  setState(() {
                    _recurringFrequency = value!;
                  });
                  Navigator.pop(context);
                },
              ),
              title: Text(
                frequency,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              onTap: () {
                setState(() {
                  _recurringFrequency = frequency;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
          SizedBox(height: 2.h),
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
          'Additional Options',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: widget.isRecurring 
                          ? theme.colorScheme.primary.withValues(alpha: 0.2)
                          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'repeat',
                      color: widget.isRecurring 
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recurring Transaction',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        if (widget.isRecurring) ...[
                          SizedBox(height: 0.5.h),
                          GestureDetector(
                            onTap: _showFrequencyModal,
                            child: Text(
                              _recurringFrequency,
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ] else ...[
                          SizedBox(height: 0.5.h),
                          Text(
                            'Set up automatic recurring',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Switch(
                    value: widget.isRecurring,
                    onChanged: widget.onRecurringChanged,
                  ),
                ],
              ),
              SizedBox(height: 3.h),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: widget.isBusinessExpense 
                          ? AppTheme.getWarningColor(theme.brightness == Brightness.light).withValues(alpha: 0.2)
                          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: 'business',
                      color: widget.isBusinessExpense 
                          ? AppTheme.getWarningColor(theme.brightness == Brightness.light)
                          : theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Business Expense',
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          widget.isBusinessExpense 
                              ? 'Tax deductible expense'
                              : 'Mark for tax purposes',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: widget.isBusinessExpense 
                                ? AppTheme.getWarningColor(theme.brightness == Brightness.light)
                                : theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: widget.isBusinessExpense,
                    onChanged: widget.onBusinessExpenseChanged,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String get recurringFrequency => _recurringFrequency;
}