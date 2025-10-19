import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'transaction_list_screen.dart';

class PaymentOutScreen extends StatelessWidget {
  const PaymentOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen(
      title: 'Payment Out',
      floatingActionButtonType: TransactionType.paymentOut,
    );
  }
}