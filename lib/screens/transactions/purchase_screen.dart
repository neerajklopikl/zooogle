import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction_type.dart'; // <-- ADD THIS IMPORT
import 'transaction_list_screen.dart';

class PurchaseScreen extends StatelessWidget {
  const PurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen(
      title: 'Purchase',
      floatingActionButtonType: TransactionType.purchase, // <-- ADD THIS LINE
    );
  }
}