import 'package:flutter/material.dart';

class SaleSettingsScreen extends StatefulWidget {
  const SaleSettingsScreen({super.key});

  @override
  State<SaleSettingsScreen> createState() => _SaleSettingsScreenState();
}

class _SaleSettingsScreenState extends State<SaleSettingsScreen> {
  // State variables for the toggles
  bool _invoiceBillNumber = true;
  bool _cashSaleByDefault = true;
  bool _poDetails = true;
  bool _addTimeToTxn = true;
  bool _printTimeOnInvoices = true;
  bool _allowInclusiveExclusiveTax = false;
  bool _displayPurchasePrice = true;
  bool _freeItemQuantity = false;
  bool _transactionWiseTax = false;
  bool _transactionWiseDiscount = true;
  bool _roundOff = true;
  String _shareTxnAs = 'Ask me Everytime';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: [
          _buildSectionHeader('Transaction Header'),
          _buildSwitchTile('Invoice/Bill Number', _invoiceBillNumber, (val) => setState(() => _invoiceBillNumber = val)),
          _buildSwitchTile('Cash Sale by default', _cashSaleByDefault, (val) => setState(() => _cashSaleByDefault = val)),
          _buildSwitchTile('PO Details(of customer)', _poDetails, (val) => setState(() => _poDetails = val)),
          _buildSwitchTile('Add Time On Transactions', _addTimeToTxn, (val) => setState(() => _addTimeToTxn = val)),
          _buildSwitchTile('Print Time on Invoices', _printTimeOnInvoices, (val) => setState(() => _printTimeOnInvoices = val)),
          const Divider(height: 24),

          _buildSectionHeader('Items Table'),
           _buildSwitchTile('Allow Inclusive/Exclusive tax on Rate(Price/unit)', _allowInclusiveExclusiveTax, (val) => setState(() => _allowInclusiveExclusiveTax = val)),
          _buildSwitchTile('Display Purchase Price', _displayPurchasePrice, (val) => setState(() => _displayPurchasePrice = val)),
          _buildSwitchTile('Free Item quantity', _freeItemQuantity, (val) => setState(() => _freeItemQuantity = val)),
          const Divider(height: 24),

          _buildSectionHeader('Taxes, Discount & Total'),
          _buildSwitchTile('Transaction wise Tax', _transactionWiseTax, (val) => setState(() => _transactionWiseTax = val)),
          _buildSwitchTile('Transaction wise Discount', _transactionWiseDiscount, (val) => setState(() => _transactionWiseDiscount = val)),
           _buildSwitchTile('Round Off Transaction amount', _roundOff, (val) => setState(() => _roundOff = val)),
          const Divider(height: 24),

          _buildSectionHeader('More Transaction Features'),
           ListTile(
            title: const Text('Share Transaction as'),
            trailing: DropdownButton<String>(
              value: _shareTxnAs,
              items: <String>['Share as PDF', 'Share as Image', 'Ask me Everytime']
                  .map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ))
                  .toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _shareTxnAs = newValue;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54)),
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