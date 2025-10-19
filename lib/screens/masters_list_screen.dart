import 'package:flutter/material.dart';
import 'package:zooogle/models/master.dart';
import 'package:zooogle/services/api_service.dart';
import 'package:zooogle/screens/add_new_master_screen.dart'; // <-- Ensure this points to the new screen

class MastersListScreen extends StatefulWidget {
  final String masterType;
  const MastersListScreen({super.key, required this.masterType});

  @override
  State<MastersListScreen> createState() => _MastersListScreenState();
}

class _MastersListScreenState extends State<MastersListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Master>> _mastersFuture;

  String get _apiType {
    switch (widget.masterType) {
      case 'Sale Series':
        return 'sale_series';
      case 'Purchase Series':
        return 'purchase_series';
      case 'Expense Categories':
        return 'expense_category';
      default:
        return widget.masterType.toLowerCase().replaceAll(' ', '_');
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshMasters();
  }

  void _refreshMasters() {
    setState(() {
      _mastersFuture = _apiService.getMasters(_apiType);
    });
  }

  void _navigateToAddMasterScreen() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => AddNewMasterScreen(masterType: _apiType)),
    );

    if (result != null) {
      try {
        // Corrected API call
        await _apiService.createMaster(result);
        _refreshMasters();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving master: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.masterType),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshMasters,
          ),
        ],
      ),
      body: FutureBuilder<List<Master>>(
        future: _mastersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No ${widget.masterType} found.'));
          }

          final masters = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: masters.length,
            itemBuilder: (context, index) {
              final master = masters[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              master.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          if (master.prefix != null && master.prefix!.isNotEmpty)
                            Chip(
                              label: Text(master.prefix!),
                              backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                              labelStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
                            )
                        ],
                      ),
                      const Divider(height: 20),
                      // <-- FIX: Changed to use null-aware checks to prevent crashes
                      if (master.address1 != null && master.address1!.isNotEmpty)
                        _buildDetailRow(Icons.location_on_outlined, master.address1!),
                      if (master.gstin != null && master.gstin!.isNotEmpty)
                        _buildDetailRow(Icons.business_outlined, "GST: ${master.gstin!}"),
                      if (master.mobileNo != null && master.mobileNo!.isNotEmpty)
                        _buildDetailRow(Icons.phone_outlined, master.mobileNo!),
                      if (master.email != null && master.email!.isNotEmpty)
                        _buildDetailRow(Icons.email_outlined, master.email!),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddMasterScreen,
        label: const Text('Add New'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant))),
        ],
      ),
    );
  }
}