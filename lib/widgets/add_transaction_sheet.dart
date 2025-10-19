// lib/widgets/add_transaction_sheet.dart
import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/screens/transactions/create_transaction_screen.dart';

// A helper class to hold the data for our grid
class TransactionGridItem {
  final String label;
  final IconData icon;
  final TransactionType type;

  const TransactionGridItem({
    required this.label,
    required this.icon,
    required this.type,
  });
}

// This is the list of all transaction types you want to show
// It matches your image and your request
final List<TransactionGridItem> _transactionItems = [
  TransactionGridItem(label: 'Sale', icon: Icons.receipt_long, type: TransactionType.sale),
  TransactionGridItem(label: 'Purchase', icon: Icons.shopping_cart, type: TransactionType.purchase),
  TransactionGridItem(label: 'Sale Return', icon: Icons.undo, type: TransactionType.saleReturn),
  TransactionGridItem(label: 'Purchase Return', icon: Icons.redo, type: TransactionType.purchaseReturn),
  TransactionGridItem(label: 'Payment In', icon: Icons.arrow_downward, type: TransactionType.paymentIn),
  TransactionGridItem(label: 'Payment Out', icon: Icons.arrow_upward, type: TransactionType.paymentOut),
  TransactionGridItem(label: 'Expense', icon: Icons.money_off, type: TransactionType.expense),
  TransactionGridItem(label: 'Estimate', icon: Icons.request_quote, type: TransactionType.estimate),
  TransactionGridItem(label: 'Sale Order', icon: Icons.note_alt_outlined, type: TransactionType.saleOrder),
  TransactionGridItem(label: 'Purchase Order', icon: Icons.notes_outlined, type: TransactionType.purchaseOrder),
  TransactionGridItem(label: 'P2P Transfer', icon: Icons.swap_horiz_outlined, type: TransactionType.p2pTransfer),
];

class AddTransactionSheet extends StatelessWidget {
  const AddTransactionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Transaction',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),

          // Grid of transactions
          Flexible(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 items per row
                childAspectRatio: 1.0,
                crossAxisSpacing: 8,
                mainAxisSpacing: 12,
              ),
              itemCount: _transactionItems.length,
              itemBuilder: (context, index) {
                final item = _transactionItems[index];
                return _buildGridItem(context, item);
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, TransactionGridItem item) {
    return InkWell(
      onTap: () {
        // THIS IS THE NAVIGATION LOGIC
        // 1. Close the bottom sheet
        Navigator.of(context).pop();

        // 2. Navigate to the CreateTransactionScreen, passing the correct type
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateTransactionScreen(type: item.type),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Icon(item.icon, size: 24, color: Theme.of(context).primaryColorDark),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}