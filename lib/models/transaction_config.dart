import 'package:zooogle/models/transaction_type.dart';

class TransactionConfig {
  final String title;
  final String numberLabel;
  final String partyLabel;
  final String amountLabel;
  final bool hasItems;
  final bool hasPaymentToggle;
  final bool hasPoDetails;
  final String? originalInvoiceNumberLabel;
  final String? originalInvoiceDateLabel;
  final String amountReceivedLabel;

  TransactionConfig({
    required this.title,
    required this.numberLabel,
    required this.partyLabel,
    this.amountLabel = 'Amount',
    this.hasItems = false,
    this.hasPaymentToggle = false,
    this.hasPoDetails = false,
    this.originalInvoiceNumberLabel,
    this.originalInvoiceDateLabel,
    this.amountReceivedLabel = 'Amount Received',
  });

  factory TransactionConfig.fromType(TransactionType type) {
    switch (type) {
      case TransactionType.sale:
        return TransactionConfig(
          title: 'Sale Invoice',
          numberLabel: 'Invoice No',
          partyLabel: 'Party Name',
          hasItems: true,
          hasPaymentToggle: true,
          amountReceivedLabel: 'Amount Received',
        );
      case TransactionType.purchase:
        return TransactionConfig(
          title: 'Purchase Bill',
          numberLabel: 'Bill No',
          partyLabel: 'Supplier Name',
          hasItems: true,
          hasPaymentToggle: true,
          hasPoDetails: true,
          amountReceivedLabel: 'Amount Paid',
        );
      case TransactionType.saleReturn:
        return TransactionConfig(
          title: 'Sale Return',
          numberLabel: 'Return No',
          partyLabel: 'Party Name',
          hasItems: true,
          hasPaymentToggle: true,
          originalInvoiceNumberLabel: 'Original Inv No',
          originalInvoiceDateLabel: 'Original Inv Date',
          amountReceivedLabel: 'Amount Refunded',
        );
      case TransactionType.purchaseReturn:
        return TransactionConfig(
          title: 'Purchase Return',
          numberLabel: 'Return No',
          partyLabel: 'Supplier Name',
          hasItems: true,
          hasPaymentToggle: true,
          originalInvoiceNumberLabel: 'Original Bill No',
          originalInvoiceDateLabel: 'Original Bill Date',
          amountReceivedLabel: 'Amount Received',
        );
      case TransactionType.paymentIn:
        return TransactionConfig(
          title: 'Payment In',
          numberLabel: 'Receipt No',
          partyLabel: 'Received From',
          amountLabel: 'Amount Received',
        );
      case TransactionType.paymentOut:
        return TransactionConfig(
          title: 'Payment Out',
          numberLabel: 'Voucher No',
          partyLabel: 'Paid To',
          amountLabel: 'Amount Paid',
        );
      case TransactionType.estimate:
        return TransactionConfig(
          title: 'Estimate/Quotation',
          numberLabel: 'Estimate No',
          partyLabel: 'Party Name',
          hasItems: true,
        );
      case TransactionType.saleOrder:
         return TransactionConfig(
          title: 'Sale Order',
          numberLabel: 'Order No',
          partyLabel: 'Party Name',
          hasItems: true,
        );
      case TransactionType.purchaseOrder:
        return TransactionConfig(
          title: 'Purchase Order',
          numberLabel: 'Order No',
          partyLabel: 'Supplier Name',
          hasItems: true,
        );
      case TransactionType.expense:
         return TransactionConfig(
          title: 'Expense',
          numberLabel: 'Voucher No',
          partyLabel: 'Paid To',
          amountLabel: 'Expense Amount',
        );
       default:
        throw UnimplementedError('Configuration for $type is not defined.');
    }
  }
}
