import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class MerchantInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final String? errorText;

  const MerchantInputWidget({
    super.key,
    required this.controller,
    required this.onChanged,
    this.errorText,
  });

  @override
  State<MerchantInputWidget> createState() => _MerchantInputWidgetState();
}

class _MerchantInputWidgetState extends State<MerchantInputWidget> {
  final List<String> _commonMerchants = [
    'Amazon',
    'Starbucks',
    'McDonald\'s',
    'Target',
    'Walmart',
    'Uber',
    'Netflix',
    'Spotify',
    'Apple',
    'Google',
    'Shell',
    'Chevron',
    'Costco',
    'Home Depot',
    'Best Buy',
  ];

  List<String> _filteredMerchants = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _filteredMerchants = _commonMerchants;
  }

  void _filterMerchants(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMerchants = _commonMerchants;
        _showSuggestions = false;
      } else {
        _filteredMerchants = _commonMerchants
            .where((merchant) =>
                merchant.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _showSuggestions = _filteredMerchants.isNotEmpty;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
          child: TextFormField(
            controller: widget.controller,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              labelText: 'Merchant/Description',
              labelStyle: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              hintText: 'Enter merchant name or description',
              hintStyle: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color:
                    theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'store',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        widget.controller.clear();
                        widget.onChanged('');
                        setState(() {
                          _showSuggestions = false;
                        });
                      },
                      icon: CustomIconWidget(
                        iconName: 'clear',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
            ),
            onChanged: (value) {
              widget.onChanged(value);
              _filterMerchants(value);
            },
            onTap: () {
              if (widget.controller.text.isEmpty) {
                setState(() {
                  _showSuggestions = true;
                });
              }
            },
          ),
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Text(
              widget.errorText!,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
        if (_showSuggestions && _filteredMerchants.isNotEmpty) ...[
          SizedBox(height: 1.h),
          Container(
            constraints: BoxConstraints(maxHeight: 30.h),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount:
                  _filteredMerchants.length > 5 ? 5 : _filteredMerchants.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.1),
              ),
              itemBuilder: (context, index) {
                final merchant = _filteredMerchants[index];
                return ListTile(
                  dense: true,
                  leading: CustomIconWidget(
                    iconName: 'store',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  title: Text(
                    merchant,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  onTap: () {
                    widget.controller.text = merchant;
                    widget.onChanged(merchant);
                    setState(() {
                      _showSuggestions = false;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
