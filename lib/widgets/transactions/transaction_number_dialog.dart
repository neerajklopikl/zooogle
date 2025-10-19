// lib/widgets/transactions/transaction_number_dialog.dart

import 'package:flutter/material.dart';

class TransactionNumberDialog extends StatefulWidget {
  final String title;
  final String label;
  final String initialPrefix;
  final int initialNumber;

  const TransactionNumberDialog({
    super.key,
    required this.title,
    required this.label,
    required this.initialPrefix,
    required this.initialNumber,
  });

  @override
  State<TransactionNumberDialog> createState() => _TransactionNumberDialogState();
}

class _TransactionNumberDialogState extends State<TransactionNumberDialog> {
  late TextEditingController _numberController;
  late String _selectedPrefix;
  final List<String> _prefixes = ['INV', 'B2B', 'PO', 'BILLS'];

  @override
  void initState() {
    super.initState();
    _selectedPrefix = widget.initialPrefix;
    _numberController = TextEditingController(text: widget.initialNumber.toString());
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  void _addPrefix() async {
    // ... (add prefix logic is the same as before)
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: [
                ChoiceChip(
                  label: const Text('None'),
                  selected: _selectedPrefix.isEmpty,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedPrefix = '');
                  },
                ),
                ..._prefixes.map((prefix) => ChoiceChip(
                      label: Text(prefix),
                      selected: _selectedPrefix == prefix,
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedPrefix = prefix);
                      },
                    )),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 18),
                  label: const Text('Add Prefix'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: widget.label,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final result = {
                      'prefix': _selectedPrefix,
                      'number': int.tryParse(_numberController.text) ?? 0,
                    };
                    Navigator.pop(context, result);
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}