// import 'dart:developer';

class ApiResponse<T> {
  final String _code;
  final String _message;
  final T? _data;
  ApiResponse({required String code, required String message, T? data})
    : _code = code,
      _message = message,
      _data = data;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? data) fromJsonT,
  ) {
    // log('Parsing ApiResponse from JSON: $json');
    return ApiResponse<T>(
      code: json['code'] as String,
      message: json['message'] as String,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }

  String get code => _code;
  String get message => _message;
  T? get data => _data;

  @override
  String toString() {
    return 'ApiResponse{code: $_code, message: $_message, data: $_data}';
  }
}
