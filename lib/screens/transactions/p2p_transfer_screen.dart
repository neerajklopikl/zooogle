import 'package:flutter/material.dart';
import 'transaction_list_screen.dart';

class P2PTransferScreen extends StatelessWidget {
  const P2PTransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionListScreen(title: 'P2P Transfer');
  }
}