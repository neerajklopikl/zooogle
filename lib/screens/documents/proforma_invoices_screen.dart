import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/screens/transactions/transaction_list_screen.dart';

class ProformaInvoicesScreen extends StatelessWidget {
  const ProformaInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen(
      title: 'Proforma Invoices',
      floatingActionButtonType: TransactionType.estimate, // Use 'estimate' for proforma
    );
  }
}