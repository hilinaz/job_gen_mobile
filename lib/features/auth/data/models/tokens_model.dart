import '../../domain/entities/tokens.dart';

class TokensModel extends Tokens {
  const TokensModel({required super.accessToken, required super.refreshToken});

  factory TokensModel.fromJson(Map<String, dynamic> j) =>
      TokensModel(
        accessToken: j['access_token'] as String,
        refreshToken: j['refresh_token'] as String,
      );

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
  };
}
