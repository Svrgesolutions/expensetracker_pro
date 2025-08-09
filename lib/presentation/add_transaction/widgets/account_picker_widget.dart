import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AccountPickerWidget extends StatefulWidget {
  final String? selectedAccount;
  final Function(String) onAccountSelected;
  final String? errorText;

  const AccountPickerWidget({
    super.key,
    this.selectedAccount,
    required this.onAccountSelected,
    this.errorText,
  });

  @override
  State<AccountPickerWidget> createState() => _AccountPickerWidgetState();
}

class _AccountPickerWidgetState extends State<AccountPickerWidget> {
  final List<Map<String, dynamic>> _accounts = [
    {
      'name': 'Chase Freedom',
      'type': 'Credit Card',
      'balance': '\$2,450.00',
      'icon': 'credit_card',
      'color': Colors.blue,
      'bank': 'Chase',
    },
    {
      'name': 'First Hawaiian Checking',
      'type': 'Checking',
      'balance': '\$8,750.25',
      'icon': 'account_balance',
      'color': Colors.green,
      'bank': 'First Hawaiian Bank',
    },
    {
      'name': 'Ally Savings',
      'type': 'Savings',
      'balance': '\$15,200.00',
      'icon': 'savings',
      'color': Colors.orange,
      'bank': 'Ally Bank',
    },
    {
      'name': 'Edward Jones Roth IRA',
      'type': 'Investment',
      'balance': '\$45,680.75',
      'icon': 'trending_up',
      'color': Colors.purple,
      'bank': 'Edward Jones',
    },
    {
      'name': 'Charles Schwab Brokerage',
      'type': 'Investment',
      'balance': '\$28,950.50',
      'icon': 'show_chart',
      'color': Colors.indigo,
      'bank': 'Charles Schwab',
    },
    {
      'name': 'Webull Trading',
      'type': 'Investment',
      'balance': '\$5,420.00',
      'icon': 'candlestick_chart',
      'color': Colors.teal,
      'bank': 'Webull',
    },
    {
      'name': 'Crypto.com',
      'type': 'Crypto',
      'balance': '\$3,250.00',
      'icon': 'currency_bitcoin',
      'color': Colors.amber,
      'bank': 'Crypto.com',
    },
    {
      'name': 'Venmo',
      'type': 'Digital Wallet',
      'balance': '\$125.50',
      'icon': 'account_balance_wallet',
      'color': Colors.cyan,
      'bank': 'Venmo',
    },
  ];

  void _showAccountModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _buildAccountModal(),
    );
  }

  Widget _buildAccountModal() {
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
                  'Select Account',
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
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: _accounts.length,
              separatorBuilder: (context, index) => SizedBox(height: 1.h),
              itemBuilder: (context, index) {
                final account = _accounts[index];
                final isSelected = widget.selectedAccount == account['name'];

                return GestureDetector(
                  onTap: () {
                    widget.onAccountSelected(account['name']);
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4.w),
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
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: (account['color'] as Color)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CustomIconWidget(
                            iconName: account['icon'],
                            color: account['color'],
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account['name'],
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                '${account['bank']} • ${account['type']}',
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          account['balance'],
                          style: GoogleFonts.inter(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
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
          'Account',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: _showAccountModal,
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
                if (widget.selectedAccount != null) ...[
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: _accounts
                          .firstWhere((acc) =>
                              acc['name'] == widget.selectedAccount)['color']
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: _accounts.firstWhere((acc) =>
                          acc['name'] == widget.selectedAccount)['icon'],
                      color: _accounts.firstWhere((acc) =>
                          acc['name'] == widget.selectedAccount)['color'],
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.selectedAccount!,
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          _accounts.firstWhere((acc) =>
                              acc['name'] == widget.selectedAccount)['balance'],
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  CustomIconWidget(
                    iconName: 'account_balance_wallet',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Select account',
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
      ],
    );
  }
}
