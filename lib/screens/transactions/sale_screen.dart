import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction_type.dart'; // <-- ADD THIS IMPORT
import 'transaction_list_screen.dart';

class SaleScreen extends StatelessWidget {
  const SaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen(
      title: 'Sale',
      floatingActionButtonType: TransactionType.sale, // <-- ADD THIS LINE
    );
  }
}