import 'package:to_do_app/models/component.dart';
import 'package:to_do_app/models/page_info.dart';

class FetchComponentResponse extends PageInfo {
  final List<Component> components;
  FetchComponentResponse({
    required this.components,
    required super.page,
    required super.size,
    required super.totalElements,
    required super.totalPages,
  });

  factory FetchComponentResponse.fromJson(Map<String, dynamic> json) {
    final componentsJson = json['components'] as List<dynamic>;
    final componentList = componentsJson
        .map((ele) => Component.fromJson(ele))
        .toList();
    return FetchComponentResponse(
      components: componentList,
      page: json['page'] as int,
      size: json['size'] as int,
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}
