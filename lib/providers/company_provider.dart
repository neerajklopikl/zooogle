import 'package:flutter/foundation.dart';
import '../models/company.dart';

class CompanyProvider with ChangeNotifier {
  Company? _selectedCompany;

  Company? get selectedCompany => _selectedCompany;

  void selectCompany(Company company) {
    _selectedCompany = company;
    notifyListeners();
  }

  void clearCompany() {
    _selectedCompany = null;
    notifyListeners();
  }
}
