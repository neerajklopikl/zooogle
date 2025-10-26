import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/providers/theme_provider.dart';
import 'package:zooogle/providers/company_provider.dart'; // <-- NEW: Import CompanyProvider
import 'package:zooogle/screens/transactions/create_transaction_screen.dart';

class DesktopHeader extends StatelessWidget {
  const DesktopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;
    
    // --- NEW: Listen to the CompanyProvider ---
    final companyProvider = Provider.of<CompanyProvider>(context);
    final selectedCompany = companyProvider.selectedCompany;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 8.0, right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- UPDATED: Display dynamic company name ---
              Text(
                selectedCompany?.name ?? 'My Company', // Fallback text
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)
              ),
              const SizedBox(height: 4),
              // --- UPDATED: Display dynamic registration status ---
              Text(
                selectedCompany?.gstin != null && selectedCompany!.gstin!.isNotEmpty 
                    ? 'Registered' 
                    : 'Unregistered',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14)
              ),
            ],
          ),
          Row(
            children: [
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
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateTransactionScreen(type: TransactionType.sale),
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
