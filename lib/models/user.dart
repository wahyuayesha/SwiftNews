class UserModel {
  final String username;
  final String email;
  final String profilePictureUrl;
  final String createdAt;

  UserModel({
    required this.username,
    required this.email,
    required this.profilePictureUrl,
    required this.createdAt,
  });

  // 
  factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(
    username: map['username'] ?? 'No Username',
    email: map['email'] ?? 'No Email',
    profilePictureUrl: map['profilePicture'] ?? 'assets/profile.jpeg', // ini diperbaiki
    createdAt: map['createdAt'] ?? 'No date',
  );
}
  // konversi dari objek UserModel ke Map untuk Firestore
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
      'createdAt': createdAt,
    };
  }
}
