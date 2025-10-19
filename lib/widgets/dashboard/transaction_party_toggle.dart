import 'package:flutter/material.dart';

class TransactionPartyToggle extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onToggle;

  const TransactionPartyToggle({super.key, required this.selectedIndex, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: OutlinedButton(onPressed: () => onToggle(0), style: _buttonStyle(isSelected: selectedIndex == 0), child: const Text('Transaction Details'))),
        const SizedBox(width: 12),
        Expanded(child: OutlinedButton(onPressed: () => onToggle(1), style: _buttonStyle(isSelected: selectedIndex == 1), child: const Text('Party Details'))),
      ],
    );
  }

  ButtonStyle _buttonStyle({required bool isSelected}) {
    return OutlinedButton.styleFrom(
      foregroundColor: isSelected ? Colors.red : Colors.grey.shade700,
      backgroundColor: isSelected ? Colors.white : Colors.transparent,
      side: BorderSide(color: isSelected ? Colors.red : Colors.grey.shade300, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      padding: const EdgeInsets.symmetric(vertical: 12),
    );
  }
}