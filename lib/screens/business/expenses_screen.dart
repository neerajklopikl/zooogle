import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/screens/transactions/create_transaction_screen.dart';
import 'package:zooogle/widgets/common/add_button.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Expenses'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'CATEGORIES'),
              Tab(text: 'ITEMS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCategoriesTab(),
            const Center(child: Text('Items will be shown here')),
          ],
        ),
        // VVV THIS IS THE CORRECTED WIDGET VVV
        floatingActionButton: AddButton(
          label: 'Add Expenses', 
          isFab: true,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateTransactionScreen(type: TransactionType.expense), // Corrected
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget _buildCategoriesTab() {
    final expenses = {
      'Manufacturing Expense': '0.00',
      'Petrol': '0.00',
      'Rent': '0.00',
      'Salary': '0.00',
      'Tea': '0.00',
      'Transport': '0.00',
    };

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              Text('₹ 0.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
            ],
          ),
        ),
        const Divider(height: 1),
        ...expenses.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            trailing: Text('₹ ${entry.value}'),
          );
        }).toList(),
      ],
    );
  }
}