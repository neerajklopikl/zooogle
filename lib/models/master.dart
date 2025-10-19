// lib/models/master.dart

// Helper class for balances
class Balance {
  final double amount;
  final String type; // 'Dr' or 'Cr'

  Balance({this.amount = 0.0, this.type = 'Dr'});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] ?? 'Dr',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'type': type,
    };
  }
}


class Master {
  final String id;
  // General Info
  final String name;
  final String? alias;
  final String? printName;
  final String? group;
  final Balance opBal;
  final Balance prevYearBal;
  final String? address1;
  final String? gstin;
  final String? itPan;
  final String? email;
  final String? mobileNo;

  // Other fields can be added here as needed for display

  // Original Fields
  final String type;
  final String? prefix;

  Master({
    required this.id,
    required this.name,
    this.alias,
    this.printName,
    this.group,
    required this.opBal,
    required this.prevYearBal,
    this.address1,
    this.gstin,
    this.itPan,
    this.email,
    this.mobileNo,
    required this.type,
    this.prefix,
  });

  factory Master.fromJson(Map<String, dynamic> json) {
    return Master(
      id: json['_id'],
      name: json['name'],
      alias: json['alias'],
      printName: json['printName'],
      group: json['group'],
      opBal: json['opBal'] != null ? Balance.fromJson(json['opBal']) : Balance(),
      prevYearBal: json['prevYearBal'] != null ? Balance.fromJson(json['prevYearBal']) : Balance(),
      address1: json['address1'],
      gstin: json['gstin'],
      itPan: json['itPan'],
      email: json['email'],
      mobileNo: json['mobileNo'],
      type: json['type'],
      prefix: json['prefix'],
    );
  }

  // <-- FIX: Added the missing toJson method
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'alias': alias,
      'printName': printName,
      'group': group,
      'opBal': opBal.toJson(),
      'prevYearBal': prevYearBal.toJson(),
      'address1': address1,
      'gstin': gstin,
      'itPan': itPan,
      'email': email,
      'mobileNo': mobileNo,
      'type': type,
      'prefix': prefix,
    };
  }
}