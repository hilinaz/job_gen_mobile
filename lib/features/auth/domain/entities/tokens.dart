import 'user.dart';

class Tokens {
  final String accessToken;
  final String refreshToken;
  final User? user; // Optional user data with role information
  
  const Tokens({
    required this.accessToken, 
    required this.refreshToken,
    this.user,
  });
}
