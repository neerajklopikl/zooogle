import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/providers/theme_provider.dart';
import 'package:zooogle/screens/transactions/create_transaction_screen.dart';

class DesktopHeader extends StatelessWidget {
  const DesktopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // VVV THIS IS THE CORRECTED WIDGET VVV
    // Access the theme provider to toggle dark/light mode
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('My Company', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Unregistered', style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
            ],
          ),
          Row(
            children: [
              // --- Dark Mode Toggle Button ---
              IconButton(
                icon: Icon(
                  isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                tooltip: 'Toggle Theme',
                onPressed: () {
                  themeProvider.toggleTheme(!isDarkMode);
                },
              ),
              const SizedBox(width: 16),
              // --- Create Invoice Button ---
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateTransactionScreen(type: TransactionType.sale), // Corrected
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Create Invoice'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade400,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}