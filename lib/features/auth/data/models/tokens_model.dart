import '../../domain/entities/tokens.dart';
import 'user_model.dart';

class TokensModel extends Tokens {
  const TokensModel({
    required super.accessToken,
    required super.refreshToken,
    super.user,
  });

  factory TokensModel.fromJson(Map<String, dynamic> json) {
    return TokensModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String? ?? '',
      user: json['user'] != null 
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'refresh_token': refreshToken,
        if (user != null) 'user': (user as UserModel).toJson(),
      };
}
