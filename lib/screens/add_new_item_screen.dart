import 'package:flutter/material.dart';
import 'package:zooogle/services/api_service.dart';
// import 'package:zooogle/models/hsn_sac.dart'; // <-- REMOVED THIS LINE
import 'package:zooogle/models/item.dart';
// import 'package:zooogle/screens/hsn_sac_selection_screen.dart'; // <-- REMOVED THIS LINE

class AddNewItemScreen extends StatefulWidget {
  const AddNewItemScreen({super.key});

  @override
  State<AddNewItemScreen> createState() => _AddNewItemScreenState();
}

class _AddNewItemScreenState extends State<AddNewItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _stockController = TextEditingController();
  // final _hsnSacController = TextEditingController(); // <-- REMOVED THIS LINE

  final _nameFocusNode = FocusNode();
  final _salePriceFocusNode = FocusNode();
  final _purchasePriceFocusNode = FocusNode();
  final _stockFocusNode = FocusNode();

  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _nameController.dispose();
    _salePriceController.dispose();
    _purchasePriceController.dispose();
    _stockController.dispose();
    // _hsnSacController.dispose(); // <-- REMOVED THIS LINE

    _nameFocusNode.dispose();
    _salePriceFocusNode.dispose();
    _purchasePriceFocusNode.dispose();
    _stockFocusNode.dispose();
    super.dispose();
  }

  void _saveItem({bool saveAndNew = false}) async {
    if (_formKey.currentState!.validate()) {
      final newItem = {
        'name': _nameController.text,
        'salePrice': double.tryParse(_salePriceController.text) ?? 0.0,
        'purchasePrice': double.tryParse(_purchasePriceController.text) ?? 0.0,
        'stock': int.tryParse(_stockController.text) ?? 0,
        // hsnCode: _hsnSacController.text.isNotEmpty ? _hsnSacController.text : null, // <-- REMOVED THIS LINE
      };
      try {
        await _apiService.createItem(newItem);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item saved successfully')),
        );
        if (saveAndNew) {
          _formKey.currentState!.reset();
          _nameController.clear();
          _salePriceController.clear();
          _purchasePriceController.clear();
          _stockController.clear();
          _nameFocusNode.requestFocus();
        } else {
          Navigator.pop(context, true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save item: $e')),
        );
      }
    }
  }

  // --- ENTIRE _selectHsnSacCode METHOD REMOVED ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                focusNode: _nameFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Item Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter an item name';
                  return null;
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_salePriceFocusNode);
                },
              ),
              // --- HSN/SAC TEXTFIELD WIDGET REMOVED ---
              const SizedBox(height: 16),
              TextFormField(
                controller: _salePriceController,
                focusNode: _salePriceFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Sale Price',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_purchasePriceFocusNode);
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purchasePriceController,
                focusNode: _purchasePriceFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Purchase Price',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_stockFocusNode);
                },
              ),
              const SizedBox(height: 16),
               TextFormField(
                controller: _stockController,
                focusNode: _stockFocusNode,
                decoration: const InputDecoration(
                  labelText: 'Initial Stock Quantity',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _saveItem(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => _saveItem(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _saveItem(saveAndNew: true),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save and New'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
