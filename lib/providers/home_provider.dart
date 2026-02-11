import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:to_do_app/models/component.dart';
import 'package:to_do_app/models/search_component_req.dart';
import 'package:to_do_app/services/component_service.dart';

class HomeProvider extends ChangeNotifier {
  final ComponentService _componentService = ComponentService();
  List<Component> _components = [];
  bool _isLoading = false;

  List<Component> get components => _components;
  bool get isLoading => _isLoading;

  Future<void> loadComponents(
    String authToken,
    SearchComponentReq payload,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await _componentService.fetchComponents(
        authToken,
        payload,
      );
      _components = response.data?.components ?? [];
    } catch (e) {
      log('Failed to load components: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteComponent(String authToken, int id) async {
    try {
      _isLoading = true;
      notifyListeners();
      final response = await _componentService.deleteComponent(authToken, id);
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      log('Failed to delete component: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }
}
