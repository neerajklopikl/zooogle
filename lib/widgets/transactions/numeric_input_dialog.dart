import 'package:flutter/material.dart';

class NumericInputDialog extends StatefulWidget {
  final String title;
  final String label;
  final double initialValue;

  const NumericInputDialog({
    super.key,
    required this.title,
    required this.label,
    this.initialValue = 0.0,
  });

  @override
  State<NumericInputDialog> createState() => _NumericInputDialogState();
}

class _NumericInputDialogState extends State<NumericInputDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSave() {
    final double? value = double.tryParse(_controller.text);
    if (value != null) {
      Navigator.of(context).pop(value);
    } else {
      // Optionally show an error if the input is not a valid number
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: widget.label,
          border: const OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _onSave,
          child: const Text('Save'),
        ),
      ],
    );
  }
}