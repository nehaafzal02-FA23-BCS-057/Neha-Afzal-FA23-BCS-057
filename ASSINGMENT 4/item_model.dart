class Item {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String gender;
  final DateTime createdAt;
  final DateTime updatedAt;

  Item({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Item to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'gender': gender,
    };
  }

  // Create Item from JSON (Supabase response)
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] != null ? json['id'].toString() : '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      gender: json['gender'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  // Copy with method for updates
  Item copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? gender,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Item(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
