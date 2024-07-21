class User {
  final String? fullName; //name
  final String email; //email
  final String? phoneNumber; //phone
  final String? country; //city
  final String? address; //address
  final String? image; //avatar

  User({
    this.fullName,
    required this.email,
    this.phoneNumber,
    this.country,
    this.address,
    this.image,

  });
}
