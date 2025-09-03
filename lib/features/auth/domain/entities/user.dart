class User {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final String role;
  final bool active;

  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    required this.role,
    required this.active,
  });
}
