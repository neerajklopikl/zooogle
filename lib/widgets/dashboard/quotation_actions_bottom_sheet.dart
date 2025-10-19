import 'package:flutter/material.dart';
import 'package:zooogle/models/transaction_type.dart';
import 'package:zooogle/screens/transactions/create_transaction_screen.dart';
import 'package:zooogle/screens/transactions/estimate_screen.dart';
import 'package:zooogle/screens/transactions/sale_settings_screen.dart';
import 'package:zooogle/screens/quotations/quotation_follow_ups_screen.dart';

class QuotationActionsBottomSheet extends StatelessWidget {
  const QuotationActionsBottomSheet({super.key});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close the bottom sheet first
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quotation Actions',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 24,
            alignment: WrapAlignment.spaceAround,
            children: [
              _buildActionItem(
                context,
                icon: Icons.add,
                label: 'New Quotation',
                onTap: () => _navigateTo(context, const CreateTransactionScreen(type: TransactionType.estimate)), // Corrected
              ),
              _buildActionItem(
                context,
                icon: Icons.list_alt_outlined,
                label: 'View All',
                onTap: () => _navigateTo(context, const EstimateScreen()),
              ),
              _buildActionItem(
                context,
                icon: Icons.transform_outlined,
                label: 'Convert to Invoice',
                isSelected: true,
                onTap: () {
                   // Navigate to the list screen where the user can select which one to convert
                   _navigateTo(context, const EstimateScreen());
                },
              ),
              _buildActionItem(
                context,
                icon: Icons.settings_outlined,
                label: 'Settings',
                onTap: () => _navigateTo(context, const SaleSettingsScreen()),
              ),
               _buildActionItem(
                context,
                icon: Icons.schedule_outlined,
                label: 'Follow-ups',
                onTap: () => _navigateTo(context, const QuotationFollowUpsScreen()),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = isSelected ? colorScheme.primary.withOpacity(0.1) : Colors.amber.shade100.withOpacity(0.5);
    final iconColor = isSelected ? colorScheme.primary : Colors.amber.shade800;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: backgroundColor,
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}