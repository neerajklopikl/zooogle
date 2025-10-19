import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooogle/models/report_models.dart';
import 'package:zooogle/services/api_service.dart';

class UnifiedReportsScreen extends StatefulWidget {
  const UnifiedReportsScreen({super.key});

  @override
  State<UnifiedReportsScreen> createState() => _UnifiedReportsScreenState();
}

class _UnifiedReportsScreenState extends State<UnifiedReportsScreen> {
  final ApiService _apiService = ApiService();
  late Future<AllReportsData> _reportsFuture;

  @override
  void initState() {
    super.initState();
    _reportsFuture = _apiService.fetchAllReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Reports'),
      ),
      body: FutureBuilder<AllReportsData>(
        future: _reportsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No report data found.'));
          }

          final reportsData = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(12.0),
            children: [
              _buildProfitAndLossCard(reportsData.profitAndLossReport),
              const SizedBox(height: 16),
              // UPDATED: Call the new Balance Sheet widget
              _buildBalanceSheetCard(reportsData.balanceSheetReport),
              const SizedBox(height: 16),
              _buildConsolidatedReportCard(reportsData.consolidatedReport),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfitAndLossCard(ProfitAndLossData data) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: const Text('Profit & Loss Statement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        initiallyExpanded: true,
        children: [
          _buildReportRow('Revenue (Sales)', currencyFormat.format(data.revenue), isPositive: true),
          _buildReportRow('Cost of Goods Sold', currencyFormat.format(data.costOfGoodsSold)),
          _buildReportRow('Gross Profit', currencyFormat.format(data.grossProfit), isTotal: true, isPositive: data.grossProfit >= 0),
          _buildReportRow('Expenses', currencyFormat.format(data.expenses)),
          _buildReportRow('Net Profit', currencyFormat.format(data.netProfit), isTotal: true, isPositive: data.netProfit >= 0),
        ],
      ),
    );
  }

  // NEW: A completely new widget to render the Balance Sheet correctly
  Widget _buildBalanceSheetCard(BalanceSheetData data) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final bool isBalanced = (data.totalAssets - data.totalLiabilitiesAndEquity).abs() < 0.01;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: const Text('Balance Sheet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(isBalanced ? 'In Balance' : 'Out of Balance', style: TextStyle(color: isBalanced ? Colors.green : Colors.red)),
        initiallyExpanded: true,
        children: [
          // ASSETS
          _buildSectionHeader('Assets'),
          _buildReportRow('Cash & Bank', currencyFormat.format(data.cashAndBank)),
          _buildReportRow('Accounts Receivable', currencyFormat.format(data.accountsReceivable)),
          _buildReportRow('Inventory', currencyFormat.format(data.inventoryValue)),
          _buildReportRow('Total Assets', currencyFormat.format(data.totalAssets), isTotal: true),
          
          const SizedBox(height: 8),

          // LIABILITIES & EQUITY
          _buildSectionHeader('Liabilities & Equity'),
          _buildReportRow('Accounts Payable', currencyFormat.format(data.accountsPayable)),
          _buildReportRow('Owner\'s Capital', currencyFormat.format(data.ownerCapital)),
          _buildReportRow('Retained Earnings (Net Profit)', currencyFormat.format(data.netProfit)),
          _buildReportRow('Total Liabilities & Equity', currencyFormat.format(data.totalLiabilitiesAndEquity), isTotal: true),
        ],
      ),
    );
  }


  Widget _buildConsolidatedReportCard(List<ConsolidatedReportData> data) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: const Text('Transaction Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        children: data.map((item) {
          final title = '${_formatTitle(item.type)} (${item.count} txns)';
          return _buildReportRow(title, currencyFormat.format(item.totalAmount));
        }).toList(),
      ),
    );
  }
  
  // Helper for sub-headers inside an ExpansionTile
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.grey.withOpacity(0.1),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
    );
  }

  Widget _buildReportRow(String title, String value, {bool isTotal = false, bool? isPositive}) {
    Color valueColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87;
    if (isPositive != null) {
      valueColor = isPositive ? Colors.green.shade700 : Colors.red.shade700;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        children: [
           if (isTotal) const Divider(height: 1, thickness: 1),
           if (isTotal) const SizedBox(height: 11),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
              Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.w600, color: valueColor)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTitle(String text) {
    if (text.isEmpty) return '';
    // Add space before capital letters and then capitalize the first letter
    return text.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}').trim().capitalize();
  }
}

extension StringExtension on String {
    String capitalize() {
      if (isEmpty) return this;
      return "${this[0].toUpperCase()}${substring(1)}";
    }
}
