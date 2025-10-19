import 'package:zooogle/models/party.dart';
import 'item.dart';

class TransactionItem {
  final Item item;
  final int quantity;
  final double rate;

  TransactionItem({
    required this.item,
    required this.quantity,
    required this.rate,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      item: Item.fromJson(json['item']),
      quantity: json['quantity'],
      rate: (json['rate'] as num).toDouble(),
    );
  }
  
  Map<String, dynamic> toJson() {
    // Note: When sending to the backend, we only need the item's ID.
    return {
      'item': item.id,
      'quantity': quantity,
      'rate': rate,
    };
  }
}

class Transaction {
  final String id;
  final String type;
  final Party? party;
  final List<TransactionItem> items;
  final double totalAmount;
  final String transactionNumber;
  final DateTime transactionDate;
  final double amountPaid;
  final double balanceDue;
  final String? status;

  Transaction({
    required this.id,
    required this.type,
    this.party,
    required this.items,
    required this.totalAmount,
    required this.transactionNumber,
    required this.transactionDate,
    required this.amountPaid,
    required this.balanceDue,
    this.status,
  });

  // Getter for partyName
  String? get partyName => party?.name;

  // Getter for date
  DateTime get date => transactionDate;

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      type: json['type'],
      party: json['party'] != null ? Party.fromJson(json['party']) : null,
      items: (json['items'] as List<dynamic>)
          .map((item) => TransactionItem.fromJson(item))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      transactionNumber: json['transactionNumber'],
      transactionDate: DateTime.parse(json['transactionDate']),
      amountPaid: (json['amountPaid'] as num?)?.toDouble() ?? 0.0,
      balanceDue: (json['balanceDue'] as num?)?.toDouble() ?? 0.0,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // '_id': id, // Usually not sent when creating
      'type': type,
      'partyId': party?.id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'transactionNumber': transactionNumber,
      'transactionDate': transactionDate.toIso8601String(),
      'amountPaid': amountPaid,
      'balanceDue': balanceDue,
      'status': status,
    };
  }
}
