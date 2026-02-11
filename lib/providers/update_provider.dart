import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:to_do_app/models/component_status.dart';
import 'package:to_do_app/models/component_update_req.dart';
import 'package:to_do_app/models/detail_component.dart';
import 'package:to_do_app/services/component_service.dart';

class UpdateProvider extends ChangeNotifier {
  final ComponentService _componentService = ComponentService();
  List<ComponentStatus> _componentStatuses = [];

  DetailComponent? _detailComponent;
  bool _isLoading = false;
  DetailComponent? get detailComponent => _detailComponent;
  bool get isLoading => _isLoading;
  List<ComponentStatus> get componentStatuses => _componentStatuses;

  Future<void> loadComponent(String authToken, int id) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await _componentService.fetchComponentById(
        authToken,
        id,
      );
      _detailComponent = response.data;
    } catch (e) {
      log('Failed to load component: $e');
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadComponentStatus(String authToken) async {
    try {
      final response = await _componentService.fetchComponentStatuses(
        authToken,
      );
      _componentStatuses = response.data ?? [];
      notifyListeners();
    } catch (e) {
      log('Failed to load component statuses: $e');
    }
  }

  Future<bool> updateComponent(
    String authToken,
    int id,
    ComponentUpdateReq payload,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await _componentService.updateComponent(
        authToken,
        id,
        payload,
      );
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      log('Failed to update component: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
    return false;
  }
}
