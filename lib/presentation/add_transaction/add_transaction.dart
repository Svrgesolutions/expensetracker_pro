import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/account_picker_widget.dart';
import './widgets/amount_input_widget.dart';
import './widgets/category_selector_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/merchant_input_widget.dart';
import './widgets/notes_input_widget.dart';
import './widgets/receipt_capture_widget.dart';
import './widgets/recurring_toggle_widget.dart';

class AddTransaction extends StatefulWidget {
  const AddTransaction({super.key});

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedCategory;
  String? _selectedAccount;
  DateTime _selectedDate = DateTime.now();
  XFile? _receiptImage;
  bool _isRecurring = false;
  bool _isBusinessExpense = false;

  String? _amountError;
  String? _merchantError;
  String? _categoryError;
  String? _accountError;

  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    setState(() {
      _amountError = null;
      _merchantError = null;
      _categoryError = null;
      _accountError = null;
    });

    bool isValid = true;

    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null) {
      setState(() {
        _amountError = 'Please enter a valid amount';
      });
      isValid = false;
    }

    if (_merchantController.text.isEmpty) {
      setState(() {
        _merchantError = 'Please enter merchant or description';
      });
      isValid = false;
    }

    if (_selectedCategory == null) {
      setState(() {
        _categoryError = 'Please select a category';
      });
      isValid = false;
    }

    if (_selectedAccount == null) {
      setState(() {
        _accountError = 'Please select an account';
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> _saveTransaction() async {
    if (!_validateForm()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Show success message
      Fluttertoast.showToast(
        msg: "Transaction added successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.light),
        textColor: Colors.white,
        fontSize: 14.sp,
      );

      // Navigate back or show add another option
      _showSuccessDialog();
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to add transaction. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Theme.of(context).colorScheme.error,
        textColor: Colors.white,
        fontSize: 14.sp,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.getSuccessColor(
                        theme.brightness == Brightness.light)
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.getSuccessColor(
                    theme.brightness == Brightness.light),
                size: 48,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Transaction Added!',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Your transaction has been successfully recorded.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Done'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            child: Text('Add Another'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _amountController.clear();
      _merchantController.clear();
      _notesController.clear();
      _selectedCategory = null;
      _selectedAccount = null;
      _selectedDate = DateTime.now();
      _receiptImage = null;
      _isRecurring = false;
      _isBusinessExpense = false;
      _amountError = null;
      _merchantError = null;
      _categoryError = null;
      _accountError = null;
    });
  }

  void _showCancelDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'Discard Transaction?',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          'Are you sure you want to discard this transaction? All entered data will be lost.',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            child: Text('Discard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            if (_amountController.text.isNotEmpty ||
                _merchantController.text.isNotEmpty ||
                _selectedCategory != null ||
                _selectedAccount != null) {
              _showCancelDialog();
            } else {
              Navigator.pop(context);
            }
          },
          icon: CustomIconWidget(
            iconName: 'close',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Add Transaction',
          style: GoogleFonts.inter(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AmountInputWidget(
                      controller: _amountController,
                      onChanged: (value) {
                        if (_amountError != null) {
                          setState(() {
                            _amountError = null;
                          });
                        }
                      },
                      errorText: _amountError,
                    ),
                    SizedBox(height: 4.h),
                    MerchantInputWidget(
                      controller: _merchantController,
                      onChanged: (value) {
                        if (_merchantError != null) {
                          setState(() {
                            _merchantError = null;
                          });
                        }
                      },
                      errorText: _merchantError,
                    ),
                    SizedBox(height: 4.h),
                    CategorySelectorWidget(
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() {
                          _selectedCategory = category;
                          _categoryError = null;
                        });
                      },
                      errorText: _categoryError,
                    ),
                    SizedBox(height: 4.h),
                    AccountPickerWidget(
                      selectedAccount: _selectedAccount,
                      onAccountSelected: (account) {
                        setState(() {
                          _selectedAccount = account;
                          _accountError = null;
                        });
                      },
                      errorText: _accountError,
                    ),
                    SizedBox(height: 4.h),
                    DatePickerWidget(
                      selectedDate: _selectedDate,
                      onDateSelected: (date) {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
                    ),
                    SizedBox(height: 4.h),
                    ReceiptCaptureWidget(
                      onReceiptCaptured: (image) {
                        setState(() {
                          _receiptImage = image;
                        });
                      },
                    ),
                    SizedBox(height: 4.h),
                    NotesInputWidget(
                      controller: _notesController,
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 4.h),
                    RecurringToggleWidget(
                      isRecurring: _isRecurring,
                      isBusinessExpense: _isBusinessExpense,
                      onRecurringChanged: (value) {
                        setState(() {
                          _isRecurring = value;
                        });
                      },
                      onBusinessExpenseChanged: (value) {
                        setState(() {
                          _isBusinessExpense = value;
                        });
                      },
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: SizedBox(
                  width: double.infinity,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveTransaction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            'Add Transaction',
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
