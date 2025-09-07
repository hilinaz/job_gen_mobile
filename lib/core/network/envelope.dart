class ErrorInfo {
  final String? code; 
  final String? message; 
  final Object? details;
  const ErrorInfo({this.code, this.message, this.details});
  factory ErrorInfo.fromJson(Map<String, dynamic>? j) =>
      ErrorInfo(code: j?['code'], message: j?['message'], details: j?['details']);
}

class ApiEnvelope<T> {
  final bool? success; 
  final String? message; 
  final T? data; 
  final ErrorInfo? error;
  ApiEnvelope({this.success, this.message, this.data, this.error});

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) parseData,
  ) => ApiEnvelope(
        success: json['success'] as bool?,
        message: json['message'] as String?,
        data: json['data'] != null ? parseData(json['data']) : null,
        error: ErrorInfo.fromJson(json['error'] as Map<String, dynamic>?),
      );
}
