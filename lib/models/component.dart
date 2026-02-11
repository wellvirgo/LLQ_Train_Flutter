import 'package:to_do_app/models/component_status.dart';
import 'package:to_do_app/models/message_type.dart';

class Component {
  int id;
  String componentCode;
  String? componentName;
  MessageType? messageType;
  String? connectionMethod;
  String? checkToken;
  ComponentStatus? status;
  String? effectiveDate;
  String? endEffectiveDate;

  Component({
    required this.id,
    required this.componentCode,
    this.componentName,
    this.messageType,
    this.connectionMethod,
    this.checkToken,
    this.status,
    this.effectiveDate,
    this.endEffectiveDate,
  });

  factory Component.fromJson(Map<String, dynamic> json) {
    return Component(
      id: json['id'] as int,
      componentCode: json['componentCode'] as String,
      componentName: json['componentName'] as String?,
      messageType: json['messageType'] != null
          ? MessageType.fromJson(json['messageType'] as Map<String, dynamic>)
          : null,
      connectionMethod: json['connectionMethod'] as String?,
      checkToken: json['checkToken'] as String?,
      status: json['status'] != null
          ? ComponentStatus.fromJson(json['status'] as Map<String, dynamic>)
          : null,
      effectiveDate: json['effectiveDate'] as String?,
      endEffectiveDate: json['endEffectiveDate'] as String?,
    );
  }
}
