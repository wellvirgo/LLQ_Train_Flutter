import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:to_do_app/models/api_response.dart';
import 'package:to_do_app/models/component_create_req.dart';
import 'package:to_do_app/models/component_status.dart';
import 'package:to_do_app/models/component_status_list.dart';
import 'package:to_do_app/models/component_update_req.dart';
import 'package:to_do_app/models/detail_component.dart';
import 'package:to_do_app/models/fetch_component_response.dart';
import 'package:to_do_app/models/search_component_req.dart';

class ComponentService {
  static const String _baseUrl = 'http://localhost:8080/api/pmh-components';

  Future<ApiResponse<FetchComponentResponse>> fetchComponents(
    String authToken,
    SearchComponentReq payload,
  ) async {
    final url = Uri.parse('$_baseUrl/search');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(payload.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch components');
    }

    return ApiResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
      (data) => FetchComponentResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<http.Response> createComponent(
    String authToken,
    ComponentCreateReq payload,
  ) async {
    final url = Uri.parse(_baseUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(payload.toJson()),
    );
    return response;
  }

  Future<http.Response> updateComponent(
    String authToken,
    int id,
    ComponentUpdateReq payload,
  ) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(payload.toJson()),
    );
    return response;
  }

  Future<ApiResponse<DetailComponent>> fetchComponentById(
    String authToken,
    int id,
  ) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch component details');
    }

    return ApiResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
      (data) => DetailComponent.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<http.Response> deleteComponent(String authToken, int id) async {
    final url = Uri.parse('$_baseUrl/$id');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    return response;
  }

  Future<ApiResponse<List<ComponentStatus>>> fetchComponentStatuses(
    String authToken,
  ) async {
    final url = Uri.parse('$_baseUrl/statuses');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch component statuses');
    }

    return ApiResponse.fromJson(
      jsonDecode(response.body),
      (data) => ComponentStatusList.fromJson(data as List<dynamic>).statuses,
    );
  }
}
