class SignupRequestModel {
  const SignupRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.photo,
  });

  final String name;
  final String email;
  final String password;
  final String phone;
  final String photo;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'photo': photo,
      };
}
