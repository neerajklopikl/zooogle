class Item {
  final String id;
  final String name;
  final double purchasePrice;
  final double salePrice;
  final int stock;
  final String? hsnCode;
  final double? gstRate;

  Item({
    required this.id,
    required this.name,
    required this.purchasePrice,
    required this.salePrice,
    required this.stock,
    this.hsnCode,
    this.gstRate,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['_id'],
      name: json['name'],
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      salePrice: (json['salePrice'] as num).toDouble(),
      stock: json['stock'] ?? 0,
      hsnCode: json['hsnCode'],
      gstRate: (json['gstRate'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'stock': stock,
      'hsnCode': hsnCode,
      'gstRate': gstRate,
    };
  }
}
