import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/screens/transactions/transaction_list_screen.dart';

class PaymentsMadeScreen extends StatelessWidget {
  const PaymentsMadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen(
      title: 'Payments Made',
      floatingActionButtonType: TransactionType.paymentOut,
    );
  }
}