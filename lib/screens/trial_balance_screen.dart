import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooogle/models/report_models.dart';
import 'package:zooogle/services/api_service.dart';

class TrialBalanceScreen extends StatefulWidget {
  const TrialBalanceScreen({super.key});

  @override
  State<TrialBalanceScreen> createState() => _TrialBalanceScreenState();
}

class _TrialBalanceScreenState extends State<TrialBalanceScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<TrialBalanceAccount>> _trialBalanceFuture;

  @override
  void initState() {
    super.initState();
    _trialBalanceFuture = _apiService.fetchTrialBalance();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trial Balance'),
      ),
      body: FutureBuilder<List<TrialBalanceAccount>>(
        future: _trialBalanceFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No trial balance data found.'));
          }

          final accounts = snapshot.data!;
          final double totalDebit = accounts.fold(0.0, (sum, item) => sum + item.debit);
          final double totalCredit = accounts.fold(0.0, (sum, item) => sum + item.credit);
          final bool totalsMatch = (totalDebit - totalCredit).abs() < 0.01;

          return Column(
            children: [
              _buildHeader(),
              Expanded(
                child: ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    final acc = accounts[index];
                    return _buildRow(
                      context,
                      acc.accountName,
                      currencyFormat.format(acc.debit),
                      currencyFormat.format(acc.credit),
                    );
                  },
                ),
              ),
              _buildFooter(
                currencyFormat.format(totalDebit),
                currencyFormat.format(totalCredit),
                totalsMatch,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Material(
      elevation: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Row(
          children: [
            Expanded(
              flex: 3,
              child: Text('Account', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: Text('Debit', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 2,
              child: Text('Credit', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String name, String debit, String credit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(name),
          ),
          Expanded(
            flex: 2,
            child: Text(debit, textAlign: TextAlign.right),
          ),
          Expanded(
            flex: 2,
            child: Text(credit, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(String totalDebit, String totalCredit, bool totalsMatch) {
    return Material(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: totalsMatch ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: totalsMatch ? Colors.green.shade800 : Colors.red.shade800),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                totalDebit,
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: totalsMatch ? Colors.green.shade800 : Colors.red.shade800),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                totalCredit,
                textAlign: TextAlign.right,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: totalsMatch ? Colors.green.shade800 : Colors.red.shade800),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
