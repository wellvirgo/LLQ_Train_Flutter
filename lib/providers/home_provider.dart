import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:to_do_app/models/component.dart';
import 'package:to_do_app/models/search_component_req.dart';
import 'package:to_do_app/services/component_service.dart';

class HomeProvider extends ChangeNotifier {
  final ComponentService _componentService = ComponentService();
  List<Component> _components = [];
  bool _isLoading = false;
  int _page = 1;
  int _requestSize = 10;
  int _totalElements = 0;

  List<Component> get components => _components;
  bool get isLoading => _isLoading;
  int get page => _page;
  int get size => _requestSize;
  int get totalElements => _totalElements;

  Future<void> loadComponents(
    String authToken,
    SearchComponentReq payload, {
    int? newPage,
    int? newSize,
  }) async {
    try {
      if (newPage != null) {
        _page = newPage;
      }

      if (newSize != null) {
        _requestSize = newSize;
      }

      _isLoading = true;
      notifyListeners();

      payload.page = _page;
      payload.size = _requestSize;

      final response = await _componentService.fetchComponents(
        authToken,
        payload,
      );

      _components = response.data?.components ?? [];
      _totalElements = response.data?.totalElements ?? 0;
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
