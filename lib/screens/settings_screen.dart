import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooogle/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // State variables for other toggles
  bool _invoiceBillNumber = true;
  bool _cashSaleByDefault = true;
  bool _poDetails = true;
  
  @override
  Widget build(BuildContext context) {
    // Access the theme provider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: [
          _buildSectionHeader('Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            secondary: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            activeColor: Colors.amber,
          ),
          const Divider(height: 24),

          _buildSectionHeader('Transaction Header'),
          _buildSwitchTile('Invoice/Bill Number', _invoiceBillNumber, (val) => setState(() => _invoiceBillNumber = val)),
          _buildSwitchTile('Cash Sale by default', _cashSaleByDefault, (val) => setState(() => _cashSaleByDefault = val)),
          _buildSwitchTile('PO Details(of customer)', _poDetails, (val) => setState(() => _poDetails = val)),
          
          // Add other settings as needed...
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6))),
    );
  }

  Widget _buildSwitchTile(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.red.shade600,
    );
  }
}