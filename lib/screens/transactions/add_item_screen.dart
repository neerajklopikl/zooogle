// lib/screens/transactions/add_item_screen.dart
import 'package:flutter/material.dart';
import 'package:zooogle/widgets/transactions/unit_selection_dialog.dart';

// This is the data class we will return to the CreateTransactionScreen
class InvoiceLineItem {
  final String name;
  final double quantity;
  final double rate;
  final String unit;
  final String taxType;
  
  InvoiceLineItem({
    required this.name,
    required this.quantity,
    required this.rate,
    required this.unit,
    required this.taxType,
  });

  // Calculated property for the total
  double get total => quantity * rate;

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
        'rate': rate,
        'unit': unit,
        'taxType': taxType,
        'total': total,
      };
}


class AddItemScreen extends StatefulWidget {
  final Function(InvoiceLineItem) onSave;
  const AddItemScreen({super.key, required this.onSave});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  // Add controllers to get the text
  final _nameController = TextEditingController();
  final _qtyController = TextEditingController(text: '1'); // Default qty to 1
  final _rateController = TextEditingController();
  final _nameFocusNode = FocusNode();

  String _selectedUnit = 'Nos';
  String _taxType = 'Without Tax';

  void _showUnitSelectionDialog() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const UnitSelectionDialog(),
    );

    if (result != null) {
      setState(() {
        _selectedUnit = result;
      });
    }
  }

  // --- NEW SAVE FUNCTION ---
  void _saveItem({bool saveAndNew = false}) {
    if (_formKey.currentState!.validate()) {
      // 1. Create the item object from controller values
      final newItem = InvoiceLineItem(
        name: _nameController.text.isNotEmpty ? _nameController.text : 'Item',
        quantity: double.tryParse(_qtyController.text) ?? 1.0,
        rate: double.tryParse(_rateController.text) ?? 0.0,
        unit: _selectedUnit,
        taxType: _taxType,
      );

      widget.onSave(newItem);

      if (saveAndNew) {
        _formKey.currentState!.reset();
        _nameController.clear();
        _qtyController.text = '1';
        _rateController.clear();
        setState(() {
          _selectedUnit = 'Nos';
          _taxType = 'Without Tax';
        });
        _nameFocusNode.requestFocus();
      } else {
        Navigator.pop(context);
      }
    }
  }
  // --- END NEW SAVE FUNCTION ---

  @override
  void dispose() {
    _nameController.dispose();
    _qtyController.dispose();
    _rateController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController, // Assign controller
                focusNode: _nameFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'e.g. Chocolate Cake',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _qtyController, // Assign controller
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: _showUnitSelectionDialog,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Unit',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_selectedUnit),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rateController, // Assign controller
                      decoration: const InputDecoration(
                        labelText: 'Rate (Price/Unit)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _taxType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: ['With Tax', 'Without Tax']
                          .map((label) => DropdownMenuItem(
                                value: label,
                                child: Text(label),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _taxType = value;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _saveItem(saveAndNew: true),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save & New'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _saveItem(), // --- CALL THE NEW SAVE FUNCTION ---
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
