import 'package:flutter/material.dart';
import 'transactions/transaction_list_screen.dart';
import 'gst_report_screen.dart';
import 'trial_balance_screen.dart';
import 'gst_summary_screen.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Transaction Reports'),
          _buildReportItem(context, 'Sale Report', () => _navigateTo(context, const TransactionListScreen(title: 'Sale Report', initialTransactionType: 'Sale'))),
          _buildReportItem(context, 'Purchase Report', () => _navigateTo(context, const TransactionListScreen(title: 'Purchase Report', initialTransactionType: 'Purchase'))),
          _buildReportItem(context, 'Day Book', () => _navigateTo(context, const TransactionListScreen(title: 'Day Book', initialDateFilter: 'Today'))),
          _buildReportItem(context, 'All Transactions', () => _navigateTo(context, const TransactionListScreen(title: 'All Transactions'))),
          
          _buildSectionHeader(context, 'Expense Reports'),
          _buildReportItem(context, 'Expense Report', () => _navigateTo(context, const TransactionListScreen(title: 'Expense Report', initialTransactionType: 'Expense'))),
          
          _buildSectionHeader(context, 'GST Reports'),
          _buildReportItem(context, 'GSTR-1', () => _navigateTo(context, const GstReportScreen(title: 'GSTR-1', reportType: GstReportType.gstr1))), // Corrected
          _buildReportItem(context, 'GSTR-2', () => _navigateTo(context, const GstReportScreen(title: 'GSTR-2', reportType: GstReportType.gstr2))), // Corrected
          _buildReportItem(context, 'GSTR-3B Summary', () => _navigateTo(context, const GstSummaryScreen(reportType: 'GSTR-3B'))),
          _buildReportItem(context, 'GSTR-9 Summary', () => _navigateTo(context, const GstSummaryScreen(reportType: 'GSTR-9'))),
          _buildReportItem(context, 'HSN Summary', () => _navigateTo(context, const GstReportScreen(title: 'HSN Summary', reportType: GstReportType.hsnSummary))), // Corrected
          _buildReportItem(context, 'GST Transactions', () => _navigateTo(context, const TransactionListScreen(title: 'GST Transactions'))),

          _buildSectionHeader(context, 'Financial Statements'),
           _buildReportItem(context, 'Trial Balance', () => _navigateTo(context, const TrialBalanceScreen())),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildReportItem(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}