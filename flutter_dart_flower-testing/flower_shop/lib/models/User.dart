class User {
  final String? fullName;
  final String email;
  final String? phoneNumber;
  final String? country;
  final String? gender;
  final String? address;
  final String password;
  final String? image;

  User({
    this.fullName,
    required this.email,
    this.phoneNumber,
    this.country,
    this.gender,
    this.address,
    this.image,
    required this.password,
  });
}
