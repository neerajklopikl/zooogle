import 'package:flutter/material.dart';
import 'package:zooogle/screens/transactions/transaction_list_screen.dart';

class PaymentReceiptsScreen extends StatelessWidget {
  const PaymentReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen(title: 'Payment Receipts');
  }
}