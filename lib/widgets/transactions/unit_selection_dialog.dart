import 'package:flutter/material.dart';
import 'add_unit_dialog.dart';

class UnitSelectionDialog extends StatelessWidget {
  const UnitSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample list of units from the video
    // In a real app, this should be a stateful widget managing this list.
    final List<Map<String, String>> units = [
      {'name': 'BAGS', 'short': 'Bag'},
      {'name': 'BOTTLES', 'short': 'Btl'},
      {'name': 'BOX', 'short': 'Box'},
      {'name': 'BUNDLES', 'short': 'Bdl'},
      {'name': 'CANS', 'short': 'Can'},
      {'name': 'CARTONS', 'short': 'Ctn'},
      {'name': 'DOZENS', 'short': 'Dzn'},
      {'name': 'GRAMMES', 'short': 'Gm'},
      {'name': 'KILOGRAMS', 'short': 'Kg'},
      {'name': 'LITRE', 'short': 'Ltr'},
      {'name': 'METERS', 'short': 'Mtr'},
      {'name': 'NUMBERS', 'short': 'Nos'},
    ];

    void _showAddUnitDialog() {
      showDialog<void>(
        context: context,
        builder: (dialogContext) => AddUnitDialog(
          onSave: (newUnit) {
            // In a real app, you'd likely call an API to save this
            // and then update the state of a StatefulWidget to show the new unit.
            // For now, we just show a confirmation.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Unit "${newUnit['name']}" added!')),
            );
            // The list isn't updated here because this is a StatelessWidget.
          },
        ),
      );
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (_, controller) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Change Item Unit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 8),
              // --- Search Bar ---
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Search for a Unit',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // --- Add New Unit Button ---
              ListTile(
                leading: const Icon(Icons.add_circle_outline, color: Colors.blue),
                title: const Text('Add New Unit', style: TextStyle(color: Colors.blue)),
                onTap: _showAddUnitDialog, // Corrected onTap
              ),
              const Divider(),
              // --- Unit List ---
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: units.length,
                  itemBuilder: (context, index) {
                    final unit = units[index];
                    return ListTile(
                      title: Text(unit['name']!),
                      subtitle: Text(unit['short']!),
                      onTap: () {
                        Navigator.pop(context, unit['short']);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
