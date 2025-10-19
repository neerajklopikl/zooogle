import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'transaction_list_screen.dart';

class PaymentInScreen extends StatelessWidget {
  const PaymentInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen(
      title: 'Payment In',
      floatingActionButtonType: TransactionType.paymentIn,
    );
  }
}