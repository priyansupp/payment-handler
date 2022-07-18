
class UserModel {
  final String id;
  final String email;
  final String username;

  UserModel({ required this.id, required this.email, required this.username });


  static UserModel fromJson(Map<String, dynamic> map) => UserModel(
      id: map['id'],
      email: map['email'],
      username: map['username']
  );

}