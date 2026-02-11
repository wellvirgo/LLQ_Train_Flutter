import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:to_do_app/models/component_create_req.dart';
import 'package:to_do_app/models/message_type.dart';
import 'package:to_do_app/services/component_service.dart';
import 'package:to_do_app/services/message_type_service.dart';

class CreationProvider extends ChangeNotifier {
  final ComponentService _componentService = ComponentService();
  final MessageTypeService _messageTypeService = MessageTypeService();

  List<MessageType> _messageTypes = [];
  bool _isLoading = false;
  bool _createSuccess = false;

  List<MessageType> get messageTypes => _messageTypes;
  bool get isLoading => _isLoading;
  bool get createSuccess => _createSuccess;

  Future<void> loadMessageTypes(String authToken) async {
    try {
      _messageTypes.clear();
      final apiResponse = await _messageTypeService.fetchMessageTypes(
        authToken,
      );
      _messageTypes = List.from(apiResponse.data?.messageTypes ?? []);
      notifyListeners();
    } catch (e) {
      log('Failed to load message types: $e');
    }
  }

  Future<void> createComponent(
    String authToken,
    ComponentCreateReq payload,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await _componentService.createComponent(
        authToken,
        payload,
      );
      if (response.statusCode == 201) {
        _createSuccess = true;
        log('Component created successfully');
      } else {
        _createSuccess = false;
        log('Failed to create component: ${response.body}');
      }
    } catch (e) {
      log('Failed to create component: $e');
      _createSuccess = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
