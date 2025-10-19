import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooogle/models/gstr_reconciliation_model.dart';
import 'package:zooogle/services/api_service.dart';

class GstrReconciliationScreen extends StatefulWidget {
  const GstrReconciliationScreen({super.key});

  @override
  State<GstrReconciliationScreen> createState() => _GstrReconciliationScreenState();
}

class _GstrReconciliationScreenState extends State<GstrReconciliationScreen> {
  final ApiService _apiService = ApiService();
  late Future<GstrReconciliation> _reconciliationFuture;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchReconciliation();
  }

  void _fetchReconciliation() {
    setState(() {
      _reconciliationFuture = _apiService.fetchGstrReconciliation(
          _selectedDate.month.toString(), _selectedDate.year.toString()); // Corrected
    });
  }

  Future<void> _selectPeriod() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Select Reconciliation Period',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _fetchReconciliation();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GSTR-2A Reconciliation'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'MATCHED'),
              Tab(text: 'MISMATCHED'),
              Tab(text: 'MISSING IN BOOKS'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildPeriodSelector(),
            Expanded(
              child: FutureBuilder<GstrReconciliation>(
                future: _reconciliationFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                        child: Text('No reconciliation data found.'));
                  }

                  final data = snapshot.data!;
                  return TabBarView(
                    children: [
                      _buildInvoiceList(data.matchedInvoices, 'Matched'),
                      _buildInvoiceList(data.mismatchedInvoices, 'Mismatched'),
                      _buildInvoiceList(
                          data.missingInBooks, 'Missing in Books'),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('For Period:', style: Theme.of(context).textTheme.titleMedium),
          ElevatedButton.icon(
            onPressed: _selectPeriod,
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Text(DateFormat('MMMM yyyy').format(_selectedDate)),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceList(List<GstrPurchaseRecord> invoices, String status) {
    if (invoices.isEmpty) {
      return Center(child: Text('No $status invoices found.'));
    }
    return ListView.builder(
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(invoice.partyGstin,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Inv: ${invoice.invoiceNumber}'),
                    Text(DateFormat('dd MMM yyyy').format(invoice.invoiceDate)),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildValueColumn(
                        'Taxable Value', '₹${invoice.taxableValue}'),
                    _buildValueColumn(
                        'Total Tax', '₹${invoice.totalTax.toStringAsFixed(2)}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildValueColumn(String label, String value,
      {CrossAxisAlignment align = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}