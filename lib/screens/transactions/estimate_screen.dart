import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooogle/models/transaction.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/screens/transactions/create_transaction_screen.dart';
import 'package:zooogle/services/api_service.dart';
import 'package:zooogle/widgets/common/add_button.dart';

class EstimateScreen extends StatefulWidget {
  const EstimateScreen({super.key});

  @override
  State<EstimateScreen> createState() => _EstimateScreenState();
}

class _EstimateScreenState extends State<EstimateScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Transaction>> _quotationsFuture;

  @override
  void initState() {
    super.initState();
    _refreshQuotations();
  }

  void _refreshQuotations() {
    setState(() {
      _quotationsFuture = _apiService.getTransactions(type: 'estimate');
    });
  }

  Future<void> _convertQuotation(String quotationId) async {
    // Show a confirmation dialog before converting
    final bool? shouldConvert = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Conversion'),
        content: const Text('Are you sure you want to convert this quotation into a sales invoice? This action cannot be undone.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Convert'),
          ),
        ],
      ),
    );

    if (shouldConvert != true) {
      return; // User cancelled the action
    }

    try {
      final newInvoice = await _apiService.convertQuotation(quotationId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully converted to Invoice #${newInvoice.transactionNumber}'),
            backgroundColor: Colors.green,
          ),
        );
      }
      _refreshQuotations(); // Refresh the list to show the updated status
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Conversion Failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotations / Estimates'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshQuotations,
          ),
        ],
      ),
      body: FutureBuilder<List<Transaction>>(
        future: _quotationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No quotations found.'));
          }

          final quotations = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80), // Space for FAB
            itemCount: quotations.length,
            itemBuilder: (context, index) {
              final q = quotations[index];
              final bool isConverted = q.status == 'Invoiced';
              final String status = q.status ?? 'Draft'; // Null check

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              q.party?.name ?? 'N/A',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(q.transactionNumber, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                        ],
                      ),
                      Text(DateFormat('dd MMM yyyy').format(q.transactionDate), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('₹ ${q.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              Chip(
                                label: Text(status.toUpperCase()), // Used safe status
                                backgroundColor: _getStatusColor(status).withOpacity(0.1), // Used safe status
                                labelStyle: TextStyle(color: _getStatusColor(status), fontSize: 10, fontWeight: FontWeight.bold), // Used safe status
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          if (!isConverted)
                            ElevatedButton(
                              onPressed: () => _convertQuotation(q.id!),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Convert to Invoice'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: AddButton(
        label: 'New Quotation',
        isFab: true,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateTransactionScreen(type: TransactionType.estimate)), // Corrected
          );
          // Always refresh after returning from the create screen
          _refreshQuotations();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Invoiced':
        return Colors.green;
      case 'Accepted':
        return Colors.blue;
      case 'Sent':
        return Colors.orange;
      case 'Rejected':
        return Colors.red;
      default: // Draft
        return Colors.grey.shade700;
    }
  }
}