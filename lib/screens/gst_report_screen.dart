// lib/screens/gst_report_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooogle/models/report_models.dart';
import 'package:zooogle/services/api_service.dart';

enum GstReportType { gstr1, gstr2, hsnSummary }

class GstReportScreen extends StatefulWidget {
  final String title;
  final GstReportType reportType;

  const GstReportScreen({super.key, required this.title, required this.reportType});

  @override
  State<GstReportScreen> createState() => _GstReportScreenState();
}

class _GstReportScreenState extends State<GstReportScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<dynamic>> _reportFuture;

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }
  
  void _fetchReport() {
    setState(() {
      switch (widget.reportType) {
        case GstReportType.gstr1:
          _reportFuture = _apiService.fetchGstr1Summary();
          break;
        case GstReportType.gstr2:
          _reportFuture = _apiService.fetchGstr2Summary();
          break;
        case GstReportType.hsnSummary:
          _reportFuture = _apiService.fetchHsnSummary();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _fetchReport),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _reportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No report data found.'));
          }
          
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              switch (widget.reportType) {
                case GstReportType.gstr1:
                case GstReportType.gstr2:
                  return _buildGstrTile(item as GstrData);
                case GstReportType.hsnSummary:
                  return _buildHsnTile(item as HsnSummaryData);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildGstrTile(GstrData data) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    final tax = data.taxableValue * (data.gstRate / 100);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.partyGstin, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Inv: ${data.transactionNumber}'),
                Text(DateFormat('dd MMM yyyy').format(data.transactionDate)),
              ],
            ),
             const Divider(height: 20),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildValueColumn('Taxable Value', currencyFormat.format(data.taxableValue)),
                _buildValueColumn('Tax Rate', '${data.gstRate}%'),
                _buildValueColumn('Total Tax', currencyFormat.format(tax), align: CrossAxisAlignment.end),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHsnTile(HsnSummaryData data) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹');
    return Card(
       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text('HSN: ${data.hsnCode}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
             const Divider(height: 20),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildValueColumn('Quantity', data.totalQuantity.toString()),
                _buildValueColumn('Taxable Value', currencyFormat.format(data.totalTaxableValue)),
                _buildValueColumn('Tax Rate', '${data.gstRate}%', align: CrossAxisAlignment.end),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueColumn(String label, String value, {CrossAxisAlignment align = CrossAxisAlignment.start}) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}