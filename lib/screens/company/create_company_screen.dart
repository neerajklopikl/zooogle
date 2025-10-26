import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/company.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({Key? key}) : super(key: key);

  @override
  _CreateCompanyScreenState createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  final _nameController = TextEditingController();
  final _gstinController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isSaving = false;

  Future<void> _saveCompany() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      final companyData = {
        'name': _nameController.text,
        'gstin': _gstinController.text,
        'phone': _phoneController.text,
      };

      try {
        // The API service now returns the created company
        final newCompany = await _apiService.createCompany(companyData);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Company created successfully!')),
        );
        
        // Pop the screen and pass the new company back to the previous screen
        Navigator.pop(context, newCompany);

      } catch (e) {
        setState(() {
          _isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create company: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gstinController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Company'),
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
                decoration: const InputDecoration(
                  labelText: 'Company Name',
                  border: OutlineInputBorder(),
                  hintText: 'Enter your business name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _gstinController,
                decoration: const InputDecoration(
                  labelText: 'GSTIN (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (Optional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveCompany,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: _isSaving 
                    ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : const Text('Save Company'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
