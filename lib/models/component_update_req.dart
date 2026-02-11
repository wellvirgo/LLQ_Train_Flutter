import 'package:to_do_app/models/component_create_req.dart';

class ComponentUpdateReq extends ComponentCreateReq {
  int isDisplay;
  int isActive;
  int status;
  String? endEffectiveDate;

  ComponentUpdateReq({
    required super.componentCode,
    required super.componentName,
    super.messageType,
    super.connectionMethod,
    super.checkToken,
    super.effectiveDate,
    required this.isDisplay,
    required this.isActive,
    required this.status,
    this.endEffectiveDate,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'componentCode': componentCode,
      'componentName': componentName,
      'messageType': messageType,
      'connectionMethod': connectionMethod,
      'checkToken': checkToken,
      'effectiveDate': effectiveDate,
      'isDisplay': isDisplay,
      'isActive': isActive,
      'status': status,
      'endEffectiveDate': endEffectiveDate,
    };
  }
}
