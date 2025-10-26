import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/transaction.dart';
import '../models/report_models.dart';
import '../models/item.dart';
import '../models/party.dart';
import '../models/master.dart';
import '../models/gstr_reconciliation_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/company.dart';

class ApiService {
  final String _baseUrl = dotenv.env['BASE_URL'] ?? '';

  Future<Company> createCompany(Map<String, dynamic> companyData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/companies'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(companyData),
    );
    if (response.statusCode == 201) {
      return Company.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create company. Status: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<List<Company>> getUserCompanies() async {
    final response = await http.get(Uri.parse('$_baseUrl/companies'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Company.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load companies');
    }
  }

  Future<String> getNextTransactionNumber(String type) async {
    final response = await http.get(Uri.parse('$_baseUrl/transactions/next-number/$type'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['nextNumber'];
    } else {
      throw Exception('Failed to get next transaction number');
    }
  }

  Future<List<Map<String, String>>> fetchIndianStates() async {
    final response = await http.get(Uri.parse('$_baseUrl/data/states'));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Map<String, String>.from(item)).toList();
    } else {
      throw Exception('Failed to load states from API');
    }
  }

  Future<List<Transaction>> getTransactions({
    String? type,
    String? partyId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final Map<String, String> queryParams = {};
    if (type != null) queryParams['type'] = type;
    if (partyId != null) queryParams['partyId'] = partyId;
    if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
    if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
    final uri = Uri.parse('$_baseUrl/transactions').replace(queryParameters: queryParams);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Transaction.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  Future<Transaction> createTransaction(Map<String, dynamic> transactionData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/transactions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(transactionData),
    );
    if (response.statusCode == 201) {
      return Transaction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create transaction. Status code: ${response.statusCode}, Body: ${response.body}');
    }
  }

  Future<void> deleteTransaction(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/transactions/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete transaction');
    }
  }

  Future<Transaction> convertQuotation(String quotationId) async {
    final response = await http.post(Uri.parse('$_baseUrl/transactions/$quotationId/convert'));
    if (response.statusCode == 201) {
      return Transaction.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to convert quotation');
    }
  }

  Future<List<Party>> getParties({String? type}) async {
    final uri = Uri.parse('$_baseUrl/parties').replace(queryParameters: type != null ? {'type': type} : {});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Party.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load parties');
    }
  }

  Future<Party> createParty(Map<String, dynamic> partyData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/parties'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(partyData),
    );
    if (response.statusCode == 201) {
      return Party.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create party');
    }
  }

  Future<List<Item>> getItems() async {
    final response = await http.get(Uri.parse('$_baseUrl/items'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Item.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<Item> createItem(Map<String, dynamic> itemData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/items'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(itemData),
    );
    if (response.statusCode == 201) {
      return Item.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create item');
    }
  }

  Future<List<Master>> getMasters(String type) async {
    final response = await http.get(Uri.parse('$_baseUrl/masters/$type'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Master.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load masters for type $type');
    }
  }

  Future<Master> createMaster(Map<String, dynamic> masterData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/masters'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(masterData),
    );
    if (response.statusCode == 201) {
      return Master.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create master');
    }
  }

  Future<ProfitAndLossData> getProfitAndLoss(String startDate, String endDate) async { 
    final response = await http.get(Uri.parse('$_baseUrl/reports/profit-and-loss?startDate=$startDate&endDate=$endDate'));
    if (response.statusCode == 200) {
      return ProfitAndLossData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load P&L report');
    }
  }

  Future<BalanceSheetData> getBalanceSheet(String endDate) async { 
    final response = await http.get(Uri.parse('$_baseUrl/reports/balance-sheet?endDate=$endDate'));
    if (response.statusCode == 200) {
      return BalanceSheetData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Balance Sheet');
    }
  }

  Future<List<TrialBalanceAccount>> fetchTrialBalance() async {
    final response = await http.get(Uri.parse('$_baseUrl/reports/trial-balance'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => TrialBalanceAccount.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Trial Balance');
    }
  }

  Future<List<dynamic>> fetchGstr1Summary() async {
    final response = await http.get(Uri.parse('$_baseUrl/reports/gstr1'));
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Failed to load GSTR1 Summary');
  }

  Future<List<dynamic>> fetchGstr2Summary() async {
    final response = await http.get(Uri.parse('$_baseUrl/reports/gstr2'));
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Failed to load GSTR2 Summary');
  }

  Future<List<dynamic>> fetchHsnSummary() async {
    final response = await http.get(Uri.parse('$_baseUrl/reports/hsn-summary'));
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Failed to load HSN Summary');
  }

  Future<dynamic> fetchGstr3bSummary(String month, String year) async {
    final response = await http.get(Uri.parse('$_baseUrl/reports/gstr3b?month=$month&year=$year'));
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Failed to load GSTR-3B Summary');
  }

  Future<dynamic> fetchGstr9Summary(String year) async {
    final response = await http.get(Uri.parse('$_baseUrl/reports/gstr9?financialYear=$year'));
    if (response.statusCode == 200) return json.decode(response.body);
    throw Exception('Failed to load GSTR-9 Summary');
  }

  Future<GstrReconciliation> fetchGstrReconciliation(String month, String year) async {
    final response = await http.get(Uri.parse('$_baseUrl/reports/gstr-reconciliation?month=$month&year=$year'));
    if (response.statusCode == 200) {
      return GstrReconciliation.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load GSTR Reconciliation');
    }
  }
  
  Future<AllReportsData> fetchAllReports() async {
    return AllReportsData(
      consolidatedReport: [
        ConsolidatedReportData(type: 'Sale', totalAmount: 0, count: 0),
        ConsolidatedReportData(type: 'Purchase', totalAmount: 0, count: 0),
      ],
      profitAndLossReport: ProfitAndLossData(
        revenue: 0,
        costOfGoodsSold: 0,
        grossProfit: 0,
        expenses: 0,
        netProfit: 0,
      ),
      balanceSheetReport: BalanceSheetData(
        cashAndBank: 0,
        accountsReceivable: 0,
        inventoryValue: 0,
        accountsPayable: 0,
        ownerCapital: 0,
        netProfit: 0,
      ),
    );
  }
}