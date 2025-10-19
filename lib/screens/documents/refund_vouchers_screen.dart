import 'package:flutter/material.dart';
import 'package:zooogle/screens/transactions/transaction_list_screen.dart';

class RefundVouchersScreen extends StatelessWidget {
  const RefundVouchersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen(title: 'Refund Vouchers');
  }
}