import 'package:to_do_app/models/component_status.dart';

class ComponentStatusList {
  final List<ComponentStatus> statuses;
  ComponentStatusList({required this.statuses});

  factory ComponentStatusList.fromJson(List<dynamic> json) {
    return ComponentStatusList(
      statuses: json
          .map((ele) => ComponentStatus.fromJson(ele as Map<String, dynamic>))
          .toList(),
    );
  }
}
