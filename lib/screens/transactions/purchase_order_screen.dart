import 'package:flutter/material.dart';
import 'transaction_list_screen.dart';

class PurchaseOrderScreen extends StatelessWidget {
  const PurchaseOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen(title: 'Purchase Order');
  }
}