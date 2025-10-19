class Party {
  final String id;
  final String name;
  final String type;
  final String? gstin;
  final String? phone;
  final String? email;
  final String? billingAddress;
  final String? shippingAddress;
  final String? state;

  Party({
    required this.id,
    required this.name,
    required this.type,
    this.gstin,
    this.phone,
    this.email,
    this.billingAddress,
    this.shippingAddress,
    this.state,
  });

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      gstin: json['gstin'],
      phone: json['phone'],
      email: json['email'],
      billingAddress: json['billingAddress'],
      shippingAddress: json['shippingAddress'],
      state: json['state'],
    );
  }
}
