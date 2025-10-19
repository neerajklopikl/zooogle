import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooogle/models/transaction.dart';

class TransactionDetailScreen extends StatefulWidget {
  final List<Transaction> transactions;
  final int initialIndex;

  const TransactionDetailScreen({
    Key? key,
    required this.transactions,
    required this.initialIndex,
  }) : super(key: key);

  @override
  _TransactionDetailScreenState createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  late Transaction _currentTransaction;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _currentTransaction = widget.transactions[_currentIndex];
  }

  void _navigateToTransaction(int index) {
    // Use push to build up the navigation stack
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TransactionDetailScreen(
          transactions: widget.transactions,
          initialIndex: index,
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final bool canGoPrevious = _currentIndex > 0;
    final bool canGoNext = _currentIndex < widget.transactions.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Txn #${_currentTransaction.transactionNumber}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_currentTransaction.type.toUpperCase(), style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Text(_currentTransaction.partyName ?? 'N/A', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text('Date: ${_formatDate(_currentTransaction.date)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    title: Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const Divider(height: 1),
                  if (_currentTransaction.items.isNotEmpty)
                    ..._currentTransaction.items.map((item) => ListTile(
                          title: Text(item.item.name),
                          subtitle: Text('${item.quantity} x ${item.rate}'),
                          trailing: Text('₹${(item.quantity * item.rate).toStringAsFixed(2)}'),
                        ))
                  else
                    const ListTile(
                      title: Text('No items in this transaction.'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Amount'),
                        Text('₹${_currentTransaction.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Amount Paid'),
                        Text('₹${_currentTransaction.amountPaid.toStringAsFixed(2)}'),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Balance Due', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('₹${_currentTransaction.balanceDue.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.arrow_back),
              label: const Text('Previous'),
              onPressed: canGoPrevious ? () => _navigateToTransaction(_currentIndex - 1) : null,
            ),
            TextButton.icon(
              label: const Text('Next'),
              icon: const Icon(Icons.arrow_forward,),
              onPressed: canGoNext ? () => _navigateToTransaction(_currentIndex + 1) : null,
            ),
          ],
        ),
      ),
    );
  }
}
