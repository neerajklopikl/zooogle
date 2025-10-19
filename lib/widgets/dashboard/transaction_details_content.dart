import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/screens/add_new_master_screen.dart';
import 'package:zooogle/screens/placeholder_screen.dart';
import 'package:zooogle/screens/reconciliation/gstr_reconciliation_screen.dart';
import 'package:zooogle/screens/reports_screen.dart';
import 'package:zooogle/screens/transactions/create_transaction_screen.dart';
import 'package:zooogle/screens/transactions/transaction_list_screen.dart';
import 'package:zooogle/screens/trial_balance_screen.dart';
import 'package:zooogle/screens/unified_reports_screen.dart';
import 'package:zooogle/services/api_service.dart';
import 'quick_links_card.dart';
import 'transaction_card.dart';
import 'quick_links_bottom_sheet.dart';

class TransactionDetailsContent extends StatefulWidget {
  const TransactionDetailsContent({super.key});

  @override
  State<TransactionDetailsContent> createState() => _TransactionDetailsContentState();
}

class _TransactionDetailsContentState extends State<TransactionDetailsContent> {
  final ApiService _apiService = ApiService();
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _loadRecentTransactions();
  }

  void _loadRecentTransactions() {
    setState(() {
      // Fetch all transactions and the logic will sort and take the latest ones.
      // In a real app, the API should support sorting and limiting.
      _transactionsFuture = _apiService.getTransactions();
    });
  }


  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quickLinks = [
      {'icon': Icons.add_box, 'label': 'Add Txn', 'color': Colors.red},
      {'icon': Icons.assessment, 'label': 'Sale Report', 'color': Colors.lightBlue},
      {'icon': Icons.library_books, 'label': 'Masters', 'color': Colors.green.shade600},
      {'icon': Icons.list_alt, 'label': 'All Txns', 'color': Colors.orange},
      {'icon': Icons.arrow_forward_ios, 'label': 'Show All', 'color': Colors.blue.shade800},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuickLinksCard(
          links: quickLinks,
          onLinkTapped: (label) {
            if (label == 'Masters') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewMasterScreen(masterType: 'sale_series')),);
            } else if (label == 'All Txns') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionListScreen(title: 'All Transactions')),);
            } else if (label == 'Sale Report') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionListScreen(title: 'Sale Report', initialTransactionType: 'Sale',)),);
            }
            else {
              _showQuickLinksBottomSheet(context, label);
            }
          },
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(onPressed: _loadRecentTransactions, icon: const Icon(Icons.refresh))
            ],
          ),
        ),
        const SizedBox(height: 8),
        _buildRecentTransactions(),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    return FutureBuilder<List<Transaction>>(
      future: _transactionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(),
          ));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Card(
            child: ListTile(
              title: Text('No recent transactions found.'),
              subtitle: Text('Create a new one to get started.'),
            ),
          );
        }

        final allTransactions = snapshot.data!;
        // Sort by date descending to get the latest ones
        allTransactions.sort((a, b) => b.transactionDate.compareTo(a.transactionDate));
        // Take the first 3
        final recentTransactions = allTransactions.take(3).toList();

        return Column(
          children: recentTransactions.map((txn) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: TransactionCard(transaction: txn),
          )).toList(),
        );
      },
    );
  }

  void _navigateToTransactionScreen(BuildContext context, String screenName) {
    TransactionType type;
    switch (screenName) {
      case 'Sale': type = TransactionType.sale; break;
      case 'Purchase': type = TransactionType.purchase; break;
      case 'Sale Return': type = TransactionType.saleReturn; break;
      case 'Purchase Return': type = TransactionType.purchaseReturn; break;
      case 'Estimate': type = TransactionType.estimate; break;
      case 'Sale Order': type = TransactionType.saleOrder; break;
      case 'Purchase Order': type = TransactionType.purchaseOrder; break;
      case 'P2P Transfer': type = TransactionType.p2pTransfer; break;
      case 'Payment In': type = TransactionType.paymentIn; break;
      case 'Payment Out': type = TransactionType.paymentOut; break;
      case 'Expense': type = TransactionType.expense; break;
      default: return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTransactionScreen(type: type)));
  }

  void _showQuickLinksBottomSheet(BuildContext context, String title) async {
    final Map<String, List<Map<String, dynamic>>> bottomSheetItems = {
      'Add Txn': [
        {'label': 'Sale', 'icon': Icons.receipt_long},
        {'label': 'Purchase', 'icon': Icons.shopping_cart},
        {'label': 'Sale Return', 'icon': Icons.undo},
        {'label': 'Purchase Return', 'icon': Icons.redo},
        {'label': 'Payment In', 'icon': Icons.arrow_downward},
        {'label': 'Payment Out', 'icon': Icons.arrow_upward},
        {'label': 'Expense', 'icon': Icons.money_off},
        {'label': 'Estimate', 'icon': Icons.request_quote},
        {'label': 'Sale Order', 'icon': Icons.note_alt_outlined},
        {'label': 'Purchase Order', 'icon': Icons.notes_outlined},
        {'label': 'P2P Transfer', 'icon': Icons.swap_horiz_outlined},
      ],
      'Show All': [
        {'label': 'Sale', 'icon': Icons.receipt_long},
        {'label': 'Purchase', 'icon': Icons.shopping_cart},
        {'label': 'Sale Report', 'icon': Icons.assessment},
        {'label': 'Day Book', 'icon': Icons.book},
        {'label': 'Profit & Loss', 'icon': Icons.trending_up},
        {'label': 'Balance Sheet', 'icon': Icons.account_balance},
        {'label': 'Trial Balance', 'icon': Icons.balance},
        {'label': 'All Reports', 'icon': Icons.analytics},
        {'label': 'GSTR Reconciliation', 'icon': Icons.rule},
        {'label': 'Bank Reconciliation', 'icon': Icons.account_balance_wallet},
      ]
    };

    final String? selectedLabel = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return QuickLinksBottomSheet(
          title: title,
          items: bottomSheetItems[title] ?? [],
        );
      },
    );

    if (selectedLabel != null) {
      Widget? destination;
      // Handle 'Add Txn' items
      if (title == 'Add Txn') {
        _navigateToTransactionScreen(context, selectedLabel);
        return;
      }
      
      // Handle 'Show All' items
      switch (selectedLabel) {
        case 'Sale Report':
          destination = const TransactionListScreen(title: 'Sale Report', initialTransactionType: 'Sale');
          break;
        case 'Day Book':
          destination = const TransactionListScreen(title: 'Day Book', initialDateFilter: 'Today');
          break;
        case 'All Reports':
          destination = const ReportsScreen();
          break;
        case 'Profit & Loss':
        case 'Balance Sheet':
          destination = const UnifiedReportsScreen();
          break;
        case 'Trial Balance':
          destination = const TrialBalanceScreen();
          break;
        case 'GSTR Reconciliation':
          destination = const GstrReconciliationScreen();
          break;
        case 'Bank Reconciliation':
          destination = const PlaceholderScreen(title: 'Bank Reconciliation');
          break;
      }
      if (destination != null) {
        if (context.mounted) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => destination!));
        }
      }
    }
  }
}

