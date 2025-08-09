import 'package:flutter/material.dart';
import '../presentation/settings/settings.dart';
import '../presentation/account_management/account_management.dart';
import '../presentation/transaction_list/transaction_list.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/add_transaction/add_transaction.dart';
import '../presentation/financial_insights/financial_insights.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String settings = '/settings';
  static const String accountManagement = '/account-management';
  static const String transactionList = '/transaction-list';
  static const String dashboard = '/dashboard';
  static const String addTransaction = '/add-transaction';
  static const String financialInsights = '/financial-insights';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const Settings(),
    settings: (context) => const Settings(),
    accountManagement: (context) => const AccountManagement(),
    transactionList: (context) => const TransactionList(),
    dashboard: (context) => const Dashboard(),
    addTransaction: (context) => const AddTransaction(),
    financialInsights: (context) => const FinancialInsights(),
    // TODO: Add your other routes here
  };
}
