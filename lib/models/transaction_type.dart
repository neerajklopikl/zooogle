import 'package:flutter/material.dart';

enum TransactionType {
  sale,
  purchase,
  saleReturn,
  purchaseReturn,
  paymentIn,
  paymentOut,
  expense,
  estimate,
  saleOrder,
  purchaseOrder,
  p2pTransfer,
}

extension TransactionTypeExtension on TransactionType {
  String toJson() => this.toString().split('.').last;
}
