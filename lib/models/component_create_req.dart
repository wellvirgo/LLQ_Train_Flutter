class ComponentCreateReq {
  String componentCode;
  String componentName;
  String? messageType;
  String? connectionMethod;
  String? checkToken;
  String? effectiveDate;

  ComponentCreateReq({
    required this.componentCode,
    required this.componentName,
    this.messageType,
    this.connectionMethod,
    this.checkToken,
    this.effectiveDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'componentCode': componentCode,
      'componentName': componentName,
      'messageType': messageType,
      'connectionMethod': connectionMethod,
      'checkToken': checkToken,
      'effectiveDate': effectiveDate,
    };
  }
}
