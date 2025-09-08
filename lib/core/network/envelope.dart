class ErrorInfo {
  final String? code;
  final String? message;
  final Object? details;
  const ErrorInfo({this.code, this.message, this.details});
  factory ErrorInfo.fromJson(Map<String, dynamic>? j) {
    if (j == null) return const ErrorInfo();

    return ErrorInfo(
      code: j['code']?.toString(),
      message: j['message']?.toString(),
      details: j['details'],
    );
  }
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
  ) {
    print('ApiEnvelope parsing: ${json.toString()}');

    // Handle data field
    T? data;
    try {
      data = json['data'] != null ? parseData(json['data']) : null;
    } catch (e) {
      print('Error parsing data field: $e');
    }

    // Handle error field more robustly
    ErrorInfo? error;
    try {
      if (json['error'] != null) {
        if (json['error'] is Map<String, dynamic>) {
          error = ErrorInfo.fromJson(json['error'] as Map<String, dynamic>);
        } else {
          print('Error field is not a Map: ${json['error'].runtimeType}');
        }
      }
    } catch (e) {
      print('Error parsing error field: $e');
    }

    return ApiEnvelope(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: data,
      error: error,
    );
  }
}
