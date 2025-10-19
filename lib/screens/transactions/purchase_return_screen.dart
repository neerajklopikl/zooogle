import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'transaction_list_screen.dart';

class PurchaseReturnScreen extends StatelessWidget {
  const PurchaseReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen(
      title: 'Purchase Return',
      floatingActionButtonType: TransactionType.purchaseReturn,
    );
  }
}