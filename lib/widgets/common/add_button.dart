import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final String label;
  final bool isFab;
  final VoidCallback onPressed; // <-- ADD THIS LINE

  const AddButton({
    super.key,
    required this.label,
    required this.onPressed, // <-- ADD THIS LINE
    this.isFab = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isFab) {
      return FloatingActionButton.extended(
        onPressed: onPressed, // <-- MODIFIED THIS LINE
        label: Text(label),
        icon: const Icon(Icons.add_circle),
        backgroundColor: Colors.red.shade600,
      );
    }

    return Center(
      child: ElevatedButton.icon(
        onPressed: onPressed, // <-- MODIFIED THIS LINE
        icon: const Icon(Icons.add_circle, color: Colors.white),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.shade600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
      ),
    );
  }
}