import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../models/company.dart';
import 'create_company_screen.dart';

class CompanySelectionScreen extends StatefulWidget {
  const CompanySelectionScreen({Key? key}) : super(key: key);

  @override
  _CompanySelectionScreenState createState() => _CompanySelectionScreenState();
}

class _CompanySelectionScreenState extends State<CompanySelectionScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Company>> _companiesFuture;

  @override
  void initState() {
    super.initState();
    _loadCompanies();
  }

  void _loadCompanies() {
    setState(() {
      _companiesFuture = _apiService.getUserCompanies();
    });
  }

  void _navigateToCreateCompany() async {
    final bool? companyCreated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateCompanyScreen()),
    );
    if (companyCreated == true) {
      _loadCompanies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Company'),
      ),
      body: FutureBuilder<List<Company>>(
        future: _companiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No companies found. Please create one.',
                textAlign: TextAlign.center,
              ),
            );
          }

          final companies = snapshot.data!;
          return ListView.builder(
            itemCount: companies.length,
            itemBuilder: (context, index) {
              final company = companies[index];
              return ListTile(
                title: Text(company.name),
                subtitle: Text(company.company_code),
                onTap: () {
                  print('Selected company: ${company.name} (${company.company_code})');
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreateCompany,
        icon: const Icon(Icons.add),
        label: const Text('Create Company'),
      ),
    );
  }
}
