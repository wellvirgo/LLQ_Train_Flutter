import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:to_do_app/models/api_response.dart';
import 'package:to_do_app/models/message_type_list.dart';

class MessageTypeService {
  static const String _baseUrl = 'http://localhost:8080/api/message-types';
  Future<ApiResponse<MessageTypeList>> fetchMessageTypes(
    String authToken,
  ) async {
    final url = Uri.parse('$_baseUrl?status=1');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final apiResponse = jsonDecode(response.body);
      return ApiResponse.fromJson(
        apiResponse,
        (data) => MessageTypeList.fromJson(data as List<dynamic>),
      );
    } else {
      throw Exception('Failed to fetch message types');
    }
  }
}
