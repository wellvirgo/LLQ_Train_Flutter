import 'package:to_do_app/models/component.dart';
import 'package:to_do_app/models/component_status.dart';
import 'package:to_do_app/models/message_type.dart';

class DetailComponent extends Component {
  int? isDisplay;
  int? isActive;

  DetailComponent({
    required super.id,
    required super.componentCode,
    super.componentName,
    super.messageType,
    super.connectionMethod,
    super.checkToken,
    super.status,
    super.effectiveDate,
    super.endEffectiveDate,
    this.isDisplay,
    this.isActive,
  });

  factory DetailComponent.fromJson(Map<String, dynamic> json) {
    return DetailComponent(
      id: json['id'] as int,
      componentCode: json['componentCode'] as String,
      componentName: json['componentName'] as String?,
      messageType: json['msgTypeDetail'] != null
          ? MessageType.fromJson(json['msgTypeDetail'] as Map<String, dynamic>)
          : null,
      connectionMethod: json['connectionMethod'] as String?,
      checkToken: json['checkToken'] as String?,
      status: json['statusDetail'] != null
          ? ComponentStatus.fromJson(
              json['statusDetail'] as Map<String, dynamic>,
            )
          : null,
      effectiveDate: json['effectiveDate'] as String?,
      endEffectiveDate: json['endEffectiveDate'] as String?,
      isDisplay: json['isDisplay'] as int?,
      isActive: json['isActive'] as int?,
    );
  }

  @override
  String toString() {
    return 'DetailComponent{id: $id, componentCode: $componentCode, componentName: $componentName, messageType: $messageType, connectionMethod: $connectionMethod, checkToken: $checkToken, status: $status, effectiveDate: $effectiveDate, endEffectiveDate: $endEffectiveDate, isDisplay: $isDisplay, isActive: $isActive}';
  }
}
