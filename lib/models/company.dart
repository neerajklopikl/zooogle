class Company {
  final String id;
  final String name;
  final String company_code;
  final String? gstin;
  final String? phone;

  Company({
    required this.id,
    required this.name,
    required this.company_code,
    this.gstin,
    this.phone,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'],
      name: json['name'],
      company_code: json['company_code'],
      gstin: json['gstin'],
      phone: json['phone'],
    );
  }
}