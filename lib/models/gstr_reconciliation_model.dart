// lib/models/gstr_reconciliation_model.dart

class GstrPurchaseRecord {
  final String id;
  final String partyGstin;
  final String invoiceNumber;
  final DateTime invoiceDate;
  final double taxableValue;
  final double totalTax;
  final double? bookValue; // Used for mismatched invoices

  GstrPurchaseRecord({
    required this.id,
    required this.partyGstin,
    required this.invoiceNumber,
    required this.invoiceDate,
    required this.taxableValue,
    required this.totalTax,
    this.bookValue,
  });

  factory GstrPurchaseRecord.fromJson(Map<String, dynamic> json) {
    return GstrPurchaseRecord(
      id: json['_id'],
      partyGstin: json['partyGstin'] ?? 'N/A',
      invoiceNumber: json['invoiceNumber'] ?? '',
      invoiceDate: DateTime.parse(json['invoiceDate']),
      taxableValue: (json['taxableValue'] as num).toDouble(),
      totalTax: (json['totalTax'] as num).toDouble(),
      bookValue: (json['bookValue'] as num?)?.toDouble(),
    );
  }
}

class GstrReconciliation {
  final List<GstrPurchaseRecord> matchedInvoices;
  final List<GstrPurchaseRecord> mismatchedInvoices;
  final List<GstrPurchaseRecord> missingInBooks;
  final List<GstrPurchaseRecord> missingInGstr2a;

  GstrReconciliation({
    required this.matchedInvoices,
    required this.mismatchedInvoices,
    required this.missingInBooks,
    required this.missingInGstr2a,
  });

  factory GstrReconciliation.fromJson(Map<String, dynamic> json) {
    return GstrReconciliation(
      matchedInvoices: (json['matchedInvoices'] as List)
          .map((i) => GstrPurchaseRecord.fromJson(i))
          .toList(),
      mismatchedInvoices: (json['mismatchedInvoices'] as List)
          .map((i) => GstrPurchaseRecord.fromJson(i))
          .toList(),
      missingInBooks: (json['missingInBooks'] as List)
          .map((i) => GstrPurchaseRecord.fromJson(i))
          .toList(),
      missingInGstr2a: (json['missingInGstr2a'] as List)
          .map((i) => GstrPurchaseRecord.fromJson(i))
          .toList(),
    );
  }
}