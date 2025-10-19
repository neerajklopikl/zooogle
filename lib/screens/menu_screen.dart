import 'package:flutter/material.dart';
import 'package:zooogle/screens/business/expenses_screen.dart';
import 'package:zooogle/screens/transactions/estimate_screen.dart';
// Remove the direct import to CreateTransactionScreen, it's not needed here
// import 'transactions/create_transaction_screen.dart';
// import '../models/transaction_type.dart'; // No longer needed here

// --- ADD THESE IMPORTS ---
import 'package:zooogle/screens/transactions/sale_screen.dart';
import 'package:zooogle/screens/transactions/purchase_screen.dart';
import 'package:zooogle/screens/transactions/sale_return_screen.dart';
import 'package:zooogle/screens/transactions/purchase_return_screen.dart';
import 'package:zooogle/screens/transactions/payment_in_screen.dart';
import 'package:zooogle/screens/transactions/payment_out_screen.dart';
// --- END IMPORTS ---


class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Features'),
      ),
      body: ListView(
        children: [
          // ... other list items
          _buildSectionHeader(context, 'TRANSACTIONS'),
          
          // --- THESE ARE THE CHANGES ---
          _buildMenuListItem(context, icon: Icons.receipt_long_outlined, title: 'Sale', screen: const SaleScreen()),
          _buildMenuListItem(context, icon: Icons.shopping_cart_outlined, title: 'Purchase', screen: const PurchaseScreen()),
          _buildMenuListItem(context, icon: Icons.undo_outlined, title: 'Sale Return', screen: const SaleReturnScreen()),
          _buildMenuListItem(context, icon: Icons.redo_outlined, title: 'Purchase Return', screen: const PurchaseReturnScreen()),
          _buildMenuListItem(context, icon: Icons.arrow_downward_outlined, title: 'Payment In', screen: const PaymentInScreen()),
          _buildMenuListItem(context, icon: Icons.arrow_upward_outlined, title: 'Payment Out', screen: const PaymentOutScreen()),
          // --- END CHANGES ---

          _buildMenuListItem(context, icon: Icons.wallet_outlined, title: 'Expenses', screen: const ExpensesScreen()), // This was already correct
          _buildMenuListItem(context, icon: Icons.request_quote_outlined, title: 'Estimate/Quotation', screen: const EstimateScreen()), // This was already correct
          // ... rest of the list
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
    );
  }

  Widget _buildMenuListItem(BuildContext context, {required IconData icon, required String title, required Widget screen}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}