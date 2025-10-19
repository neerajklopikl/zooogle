import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooogle/models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shadowColor: Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(transaction.partyName ?? 'N/A', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('#${transaction.transactionNumber}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.lightBlue.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    '${transaction.type.toUpperCase()}: ${transaction.balanceDue > 0 ? "PARTIAL" : "PAID"}',
                    style: const TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)
                  ),
                ),
                Text(DateFormat('dd MMM, yy').format(transaction.transactionDate), style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildAmountColumn('Total', '₹ ${transaction.totalAmount.toStringAsFixed(2)}'),
                _buildAmountColumn('Balance', '₹ ${transaction.balanceDue.toStringAsFixed(2)}'),
                Row(
                  children: [
                    Icon(Icons.print_outlined, color: Colors.grey.shade600),
                    const SizedBox(width: 16),
                    Icon(Icons.share_outlined, color: Colors.grey.shade600),
                    const SizedBox(width: 16),
                    Icon(Icons.more_vert, color: Colors.grey.shade600),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column _buildAmountColumn(String title, String amount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
