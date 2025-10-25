import 'package:flutter/material.dart';

class AddMasterDialog extends StatefulWidget {
  final String masterType;
  final Function(Map<String, String>) onSave;
  const AddMasterDialog({super.key, required this.masterType, required this.onSave});

  @override
  State<AddMasterDialog> createState() => _AddMasterDialogState();
}

class _AddMasterDialogState extends State<AddMasterDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _prefixController = TextEditingController();

  bool get _hasPrefix => widget.masterType.toLowerCase().contains('series');

  @override
  void dispose() {
    _nameController.dispose();
    _prefixController.dispose();
    super.dispose();
  }

  void _onSave({bool saveAndNew = false}) {
    if (_formKey.currentState!.validate()) {
      final result = {
        'name': _nameController.text,
        'prefix': _prefixController.text,
      };
      widget.onSave(result);

      if (saveAndNew) {
        _formKey.currentState!.reset();
        _nameController.clear();
        _prefixController.clear();
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New ${widget.masterType}'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name *'),
              validator: (value) => (value == null || value.isEmpty) ? 'Please enter a name' : null,
              autofocus: true,
            ),
            if (_hasPrefix) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _prefixController,
                decoration: const InputDecoration(labelText: 'Prefix (e.g., INV-)'),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        OutlinedButton(
          onPressed: () => _onSave(saveAndNew: true),
          child: const Text('Save & New'),
        ),
        ElevatedButton(
          onPressed: _onSave,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
