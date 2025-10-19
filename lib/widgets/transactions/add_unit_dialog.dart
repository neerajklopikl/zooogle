import 'package:flutter/material.dart';

class AddUnitDialog extends StatefulWidget {
  const AddUnitDialog({super.key});

  @override
  State<AddUnitDialog> createState() => _AddUnitDialogState();
}

class _AddUnitDialogState extends State<AddUnitDialog> {
  final _formKey = GlobalKey<FormState>();
  final _unitNameController = TextEditingController();
  final _shortNameController = TextEditingController();

  @override
  void dispose() {
    _unitNameController.dispose();
    _shortNameController.dispose();
    super.dispose();
  }

  void _saveUnit() {
    if (_formKey.currentState!.validate()) {
      final newUnit = {
        'name': _unitNameController.text,
        'short': _shortNameController.text,
      };
      Navigator.of(context).pop(newUnit);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Unit'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _unitNameController,
              decoration: const InputDecoration(labelText: 'Unit Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a unit name';
                }
                return null;
              },
            ),
            const SizedBox(height: 4),
            const Text('This unit cannot be deleted.', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _shortNameController,
              decoration: const InputDecoration(labelText: 'Short Name'),
               validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a short name';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveUnit,
          child: const Text('Save'),
        ),
      ],
    );
  }
}