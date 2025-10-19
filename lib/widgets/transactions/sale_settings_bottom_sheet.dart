import 'package:flutter/material.dart';
import 'package:zooogle/screens/transactions/sale_settings_screen.dart';

class SaleSettingsBottomSheet extends StatefulWidget {
  const SaleSettingsBottomSheet({super.key});

  @override
  State<SaleSettingsBottomSheet> createState() => _SaleSettingsBottomSheetState();
}

class _SaleSettingsBottomSheetState extends State<SaleSettingsBottomSheet> {
  bool _salePrefix = false;
  bool _transactionSms = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchListTile(
            title: const Text('Sale Prefix'),
            subtitle: const Text('Customize the Prefix to your Sale Invoice. Ex: INV'),
            value: _salePrefix,
            onChanged: (val) => setState(() => _salePrefix = val),
          ),
          SwitchListTile(
            title: const Text('Transaction SMS'),
            subtitle: const Text('Send an automatic SMS to your Customer with details of the Sale.'),
            value: _transactionSms,
            onChanged: (val) => setState(() => _transactionSms = val),
          ),
          ListTile(
            title: const Text('Additional Fields'),
            subtitle: const Text('Add extra fields to the Sale, like License Number, PAN Number, Additional Dates etc.'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
               Navigator.pop(context); // Close the sheet
               Navigator.push(context, MaterialPageRoute(builder: (context) => const SaleSettingsScreen()));
            },
          ),
          ListTile(
            title: const Text('Additional Charges'),
             trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
               Navigator.pop(context); // Close the sheet
               Navigator.push(context, MaterialPageRoute(builder: (context) => const SaleSettingsScreen()));
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}