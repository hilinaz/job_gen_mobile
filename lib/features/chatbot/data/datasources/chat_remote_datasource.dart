import 'package:dio/dio.dart';
import '../../../../core/constants/endpoints.dart';

abstract class ChatRemoteDataSource {
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body);
  Future<List<dynamic>> getUserSessions({int limit, int offset});
  Future<List<dynamic>> getSessionHistory(String sessionId);
  Future<void> deleteSession(String sessionId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio dio;
  ChatRemoteDataSourceImpl(this.dio);

  @override
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body) async {
    final res = await dio.post(Endpoints.sendChatMessage, data: body);
    return res.data['data'] as Map<String, dynamic>;
  }

  @override
  Future<List<dynamic>> getUserSessions({int limit = 10, int offset = 0}) async {
    final res = await dio.get(
      Endpoints.getChatSessions,
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return res.data['data'] as List<dynamic>;
  }

  @override
  Future<List<dynamic>> getSessionHistory(String sessionId) async {
    final res = await dio.get('${Endpoints.getChatSessionById}/$sessionId');
    return res.data['data'] as List<dynamic>;
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    await dio.delete('${Endpoints.deleteChatSession}/$sessionId');
  }
}
