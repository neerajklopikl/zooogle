import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/screens/transactions/transaction_list_screen.dart';

class DebitNotesScreen extends StatelessWidget {
  const DebitNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen(
      title: 'Debit Notes',
      floatingActionButtonType: TransactionType.purchaseReturn,
    );
  }
}