import 'package:flutter/material.dart';
import '../services/api_service.dart';

class GstSummaryScreen extends StatefulWidget {
  final String reportType;
  const GstSummaryScreen({Key? key, required this.reportType}) : super(key: key);

  @override
  _GstSummaryScreenState createState() => _GstSummaryScreenState();
}

class _GstSummaryScreenState extends State<GstSummaryScreen> {
  final ApiService _apiService = ApiService();
  Future<dynamic>? _summaryFuture;

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _fetchSummary();
  }

  void _fetchSummary() {
    setState(() {
      if (widget.reportType == 'GSTR-3B') {
        _summaryFuture = _apiService.fetchGstr3bSummary(
          _selectedMonth.toString(), // <-- CORRECTED
          _selectedYear.toString()  // <-- CORRECTED
        );
      } else if (widget.reportType == 'GSTR-9') {
        final financialYear = (_selectedMonth < 4) ? _selectedYear - 1 : _selectedYear;
        _summaryFuture = _apiService.fetchGstr9Summary(financialYear.toString()); // <-- CORRECTED
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.reportType} Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt),
            onPressed: () {
              // Show filter dialog to select month/year
            },
          )
        ],
      ),
      body: FutureBuilder<dynamic>(
        future: _summaryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No summary data found.'));
          }
          // Display the summary data
          final summary = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(summary.toString()), // Replace with formatted widgets
          );
        },
      ),
    );
  }
}
