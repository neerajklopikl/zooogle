import 'package:flutter/material.dart';
import 'package:zooogle/screens/placeholder_screen.dart';

class LedgersScreen extends StatelessWidget {
  const LedgersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ledgers'),
      ),
      body: ListView(
        children: [
          _buildLedgerItem(
            context,
            title: 'General Ledger',
            subtitle: 'View all journal entries.',
            icon: Icons.book_outlined,
            screen: const PlaceholderScreen(title: 'General Ledger'),
          ),
          _buildLedgerItem(
            context,
            title: 'Party Ledgers',
            subtitle: 'View statements for customers and suppliers.',
            icon: Icons.people_outline,
            screen: const PlaceholderScreen(title: 'Party Ledgers'),
          ),
          _buildLedgerItem(
            context,
            title: 'Bank & Cash Ledgers',
            subtitle: 'Track transactions for all your accounts.',
            icon: Icons.account_balance_wallet_outlined,
            screen: const PlaceholderScreen(title: 'Bank & Cash Ledgers'),
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerItem(BuildContext context, {required String title, required String subtitle, required IconData icon, required Widget screen}) {
    return ListTile(
      leading: Icon(icon, size: 32),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
    );
  }
}