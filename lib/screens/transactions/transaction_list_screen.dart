import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooogle/models/transaction.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/services/api_service.dart';
import 'create_transaction_screen.dart';
import 'transaction_detail_screen.dart'; // Import the detail screen

class TransactionListScreen extends StatefulWidget {
  final String title;
  final TransactionType? floatingActionButtonType;
  final String? initialTransactionType;
  final String? initialDateFilter;

  const TransactionListScreen({
    Key? key,
    required this.title,
    this.floatingActionButtonType,
    this.initialTransactionType,
    this.initialDateFilter,
  }) : super(key: key);

  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
    DateTime? startDate;
    DateTime? endDate;

    if (widget.initialDateFilter == 'Today') {
      final now = DateTime.now();
      startDate = DateTime(now.year, now.month, now.day);
      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    }
    // You could add more cases for other date filters here

    setState(() {
      _transactionsFuture = _apiService.getTransactions(
        type: widget.initialTransactionType,
        startDate: startDate,
        endDate: endDate,
      );
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy').format(date);
  }

  void _navigateAndReload() async {
    if (widget.floatingActionButtonType != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateTransactionScreen(type: widget.floatingActionButtonType!),
        ),
      );
      // If the result is true, it means a transaction was created successfully
      if (result == true) {
        _loadTransactions();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _loadTransactions(),
        child: FutureBuilder<List<Transaction>>(
          future: _transactionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No ${widget.title} transactions found.', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    const Text('Tap the + button to add a new one.'),
                  ],
                ),
              );
            }

            final transactions = snapshot.data!;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(transaction.partyName ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('No: ${transaction.transactionNumber ?? 'N/A'} | ${_formatDate(transaction.date)}'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${transaction.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                        ),
                        if (transaction.balanceDue > 0)
                          Text(
                            'Due: ₹${transaction.balanceDue.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TransactionDetailScreen(
                            transactions: transactions, // Pass the full list
                            initialIndex: index,        // Pass the tapped index
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: widget.floatingActionButtonType != null
          ? FloatingActionButton.extended(
              onPressed: _navigateAndReload, // <-- Use the new method
              label: Text('Add New ${widget.title}'),
              icon: const Icon(Icons.add),
            )
          : null,
    );
  }
}
