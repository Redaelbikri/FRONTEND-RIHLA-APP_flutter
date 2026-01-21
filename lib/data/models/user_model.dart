class UserModel {
  final String id;
  final String name;
  final String email;
  final String country;
  final bool premium;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.country,
    required this.premium,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: (json['id'] ?? '').toString(),
    name: (json['name'] ?? '').toString(),
    email: (json['email'] ?? '').toString(),
    country: (json['country'] ?? 'Morocco').toString(),
    premium: (json['premium'] ?? false) == true,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'country': country,
    'premium': premium,
  };
}
