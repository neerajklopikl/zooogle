class ConsolidatedReportData {
  final String type;
  final double totalAmount;
  final int count;

  ConsolidatedReportData({
    required this.type,
    required this.totalAmount,
    required this.count,
  });

  factory ConsolidatedReportData.fromJson(Map<String, dynamic> json) {
    return ConsolidatedReportData(
      type: json['type'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      count: json['count'] as int,
    );
  }
}

class ProfitAndLossData {
  final double revenue;
  final double costOfGoodsSold;
  final double grossProfit;
  final double expenses;
  final double netProfit;

  ProfitAndLossData({
    required this.revenue,
    required this.costOfGoodsSold,
    required this.grossProfit,
    required this.expenses,
    required this.netProfit,
  });

  factory ProfitAndLossData.fromJson(Map<String, dynamic> json) {
    return ProfitAndLossData(
      revenue: (json['revenue'] as num).toDouble(),
      costOfGoodsSold: (json['costOfGoodsSold'] as num).toDouble(),
      grossProfit: (json['grossProfit'] as num).toDouble(),
      expenses: (json['expenses'] as num).toDouble(),
      netProfit: (json['netProfit'] as num).toDouble(),
    );
  }
}

// NEW: A proper model for the balance sheet data from the backend
class BalanceSheetData {
  // Assets
  final double cashAndBank;
  final double accountsReceivable;
  final double inventoryValue;

  // Liabilities & Equity
  final double accountsPayable;
  final double ownerCapital;
  final double netProfit;

  BalanceSheetData({
    required this.cashAndBank,
    required this.accountsReceivable,
    required this.inventoryValue,
    required this.accountsPayable,
    required this.ownerCapital,
    required this.netProfit,
  });

  // Calculated properties for totals
  double get totalAssets => cashAndBank + accountsReceivable + inventoryValue;
  double get totalLiabilitiesAndEquity => accountsPayable + ownerCapital + netProfit;

  factory BalanceSheetData.fromJson(Map<String, dynamic> json) {
    return BalanceSheetData(
      cashAndBank: (json['cashAndBank'] as num? ?? 0).toDouble(),
      accountsReceivable: (json['accountsReceivable'] as num? ?? 0).toDouble(),
      inventoryValue: (json['inventoryValue'] as num? ?? 0).toDouble(),
      accountsPayable: (json['accountsPayable'] as num? ?? 0).toDouble(),
      ownerCapital: (json['ownerCapital'] as num? ?? 0).toDouble(),
      netProfit: (json['netProfit'] as num? ?? 0).toDouble(),
    );
  }
}


// A wrapper class to hold all our report data
class AllReportsData {
  final List<ConsolidatedReportData> consolidatedReport;
  final ProfitAndLossData profitAndLossReport;
  // UPDATED: Use the new BalanceSheetData model
  final BalanceSheetData balanceSheetReport;

  AllReportsData({
    required this.consolidatedReport,
    required this.profitAndLossReport,
    required this.balanceSheetReport,
  });
}

class TrialBalanceAccount {
  final String accountName;
  final double debit;
  final double credit;

  TrialBalanceAccount({
    required this.accountName,
    required this.debit,
    required this.credit,
  });

  factory TrialBalanceAccount.fromJson(Map<String, dynamic> json) {
    return TrialBalanceAccount(
      accountName: json['accountName'] as String,
      debit: (json['debit'] as num).toDouble(),
      credit: (json['credit'] as num).toDouble(),
    );
  }
}


// --- GST Report Models ---

class GstrData {
  final String partyGstin;
  final String transactionNumber;
  final DateTime transactionDate;
  final double taxableValue;
  final double gstRate;

  GstrData({
    required this.partyGstin,
    required this.transactionNumber,
    required this.transactionDate,
    required this.taxableValue,
    required this.gstRate,
  });

  factory GstrData.fromJson(Map<String, dynamic> json) {
    return GstrData(
      partyGstin: json['partyGstin'] ?? 'N/A',
      transactionNumber: json['transactionNumber'] ?? '',
      transactionDate: DateTime.parse(json['transactionDate']),
      taxableValue: (json['taxableValue'] as num).toDouble(),
      gstRate: (json['gstRate'] as num? ?? 0).toDouble(),
    );
  }
}

class HsnSummaryData {
  final String hsnCode;
  final int totalQuantity;
  final double totalTaxableValue;
  final double gstRate;

  HsnSummaryData({
    required this.hsnCode,
    required this.totalQuantity,
    required this.totalTaxableValue,
    required this.gstRate,
  });

  factory HsnSummaryData.fromJson(Map<String, dynamic> json) {
    return HsnSummaryData(
      hsnCode: json['hsnCode'] ?? 'N/A',
      totalQuantity: (json['totalQuantity'] as num).toInt(),
      totalTaxableValue: (json['totalTaxableValue'] as num).toDouble(),
      gstRate: (json['gstRate'] as num? ?? 0).toDouble(),
    );
  }
}

class Gstr3bSummaryData {
  final double outwardTaxableSupplies;
  final double outwardCgst;
  final double outwardSgst;
  final double itcAvailableCgst;
  final double itcAvailableSgst;

  Gstr3bSummaryData({
    required this.outwardTaxableSupplies,
    required this.outwardCgst,
    required this.outwardSgst,
    required this.itcAvailableCgst,
    required this.itcAvailableSgst,
  });

  factory Gstr3bSummaryData.fromJson(Map<String, dynamic> json) {
    return Gstr3bSummaryData(
      outwardTaxableSupplies: (json['outwardTaxableSupplies'] as num).toDouble(),
      outwardCgst: (json['outwardCgst'] as num).toDouble(),
      outwardSgst: (json['outwardSgst'] as num).toDouble(),
      itcAvailableCgst: (json['itcAvailableCgst'] as num).toDouble(),
      itcAvailableSgst: (json['itcAvailableSgst'] as num).toDouble(),
    );
  }
}

class Gstr9SummaryData {
  final double totalTaxableValue;
  final double totalTaxPayable;
  final double totalItcClaimed;

  Gstr9SummaryData({
    required this.totalTaxableValue,
    required this.totalTaxPayable,
    required this.totalItcClaimed,
  });

   factory Gstr9SummaryData.fromJson(Map<String, dynamic> json) {
    return Gstr9SummaryData(
      totalTaxableValue: (json['totalTaxableValue'] as num).toDouble(),
      totalTaxPayable: (json['totalTaxPayable'] as num).toDouble(),
      totalItcClaimed: (json['totalItcClaimed'] as num).toDouble(),
    );
  }
}
