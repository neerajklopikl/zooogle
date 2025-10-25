import 'package:flutter/material.dart';
import '../../models/party.dart';
import '../../services/api_service.dart';

class AddNewPartyScreen extends StatefulWidget {
  final Party? party;

  const AddNewPartyScreen({Key? key, this.party}) : super(key: key);

  @override
  _AddNewPartyScreenState createState() => _AddNewPartyScreenState();
}

class _AddNewPartyScreenState extends State<AddNewPartyScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // Controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _gstinController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _billingAddressController;
  late TextEditingController _shippingAddressController;

  // --- NEW STATE VARIABLES FOR THE DROPDOWN ---
  List<Map<String, String>> _states = [];
  String? _selectedState;
  bool _isLoadingStates = true;
  // --- END NEW STATE VARIABLES ---

  String _partyType = 'Customer'; // Default party type

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.party?.name);
    _gstinController = TextEditingController(text: widget.party?.gstin);
    _phoneController = TextEditingController(text: widget.party?.phone);
    _emailController = TextEditingController(text: widget.party?.email);
    _billingAddressController = TextEditingController(text: widget.party?.billingAddress);
    _shippingAddressController = TextEditingController(text: widget.party?.shippingAddress);
    _partyType = widget.party?.type ?? 'Customer';
    _selectedState = widget.party?.state;

    // --- NEW: Fetch states when the screen loads ---
    _fetchStates();
  }

  // --- NEW METHOD TO FETCH STATES FROM THE API ---
  Future<void> _fetchStates() async {
    try {
      final states = await _apiService.fetchIndianStates();
      setState(() {
        _states = states;
        // If we are editing a party, ensure their saved state is in the list
        if (_selectedState != null && !_states.any((s) => s['name'] == _selectedState)) {
             // Handle case where saved state is not in the list (e.g., old data)
             // You could add it to the list or clear the selection
        }
        _isLoadingStates = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingStates = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load states: $e')),
      );
    }
  }
  // --- END NEW METHOD ---

  @override
  void dispose() {
    _nameController.dispose();
    _gstinController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _billingAddressController.dispose();
    _shippingAddressController.dispose();
    super.dispose();
  }

  Future<void> _saveParty({bool saveAndNew = false}) async {
    if (_formKey.currentState!.validate()) {
      try {
        final partyData = {
          'name': _nameController.text,
          'gstin': _gstinController.text,
          'phone': _phoneController.text,
          'email': _emailController.text,
          'billingAddress': _billingAddressController.text,
          'shippingAddress': _shippingAddressController.text,
          'type': _partyType,
          'state': _selectedState,
        };

        if (widget.party == null) {
          // Creating a new party
          await _apiService.createParty(partyData);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Party created successfully!')),
          );
          if (saveAndNew) {
            _formKey.currentState!.reset();
            _nameController.clear();
            _gstinController.clear();
            _phoneController.clear();
            _emailController.clear();
            _billingAddressController.clear();
            _shippingAddressController.clear();
            setState(() {
              _selectedState = null;
              _partyType = 'Customer';
            });
          } else {
            Navigator.of(context).pop(true);
          }
        } else {
          // Updating an existing party
          // await _apiService.updateParty(widget.party!.id, partyData);
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(content: Text('Party updated successfully!')),
          // );
          Navigator.of(context).pop(true); // Return true to indicate success
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save party: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.party == null ? 'Add New Party' : 'Edit Party'),
        actions: [
          if (widget.party == null)
            TextButton(
              onPressed: () => _saveParty(saveAndNew: true),
              child: const Text('Save & New'),
            ),
          TextButton(
            onPressed: () => _saveParty(),
            child: const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Party Name*'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a party name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _gstinController,
                  decoration: const InputDecoration(labelText: 'GSTIN (Optional)'),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number (Optional)'),
                  keyboardType: TextInputType.phone,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email (Optional)'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // --- NEW STATE DROPDOWN WIDGET ---
                _isLoadingStates
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                        value: _selectedState,
                        decoration: const InputDecoration(
                          labelText: 'State',
                          border: OutlineInputBorder(),
                        ),
                        hint: const Text('Select State'),
                        isExpanded: true,
                        items: _states.map<DropdownMenuItem<String>>((Map<String, String> state) {
                          return DropdownMenuItem<String>(
                            value: state['name'],
                            child: Text(state['name']!),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedState = newValue;
                          });
                        },
                        // You can add a validator if needed
                        // validator: (value) => value == null ? 'Please select a state' : null,
                      ),
                // --- END STATE DROPDOWN WIDGET ---
                
                const SizedBox(height: 20),
                TextFormField(
                  controller: _billingAddressController,
                  decoration: const InputDecoration(labelText: 'Billing Address (Optional)'),
                  maxLines: 3,
                ),
                TextFormField(
                  controller: _shippingAddressController,
                  decoration: const InputDecoration(labelText: 'Shipping Address (Optional)'),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                const Text('Party Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Customer',
                      groupValue: _partyType,
                      onChanged: (value) {
                        setState(() {
                          _partyType = value!;
                        });
                      },
                    ),
                    const Text('Customer'),
                    Radio<String>(
                      value: 'Supplier',
                      groupValue: _partyType,
                      onChanged: (value) {
                        setState(() {
                          _partyType = value!;
                        });
                      },
                    ),
                    const Text('Supplier'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
