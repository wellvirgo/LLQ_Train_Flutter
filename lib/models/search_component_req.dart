class SearchComponentReq {
  String? componentCode;
  String? componentName;
  String? messageType;
  String? connectionMethod;
  String? checkToken;
  int? isDisplay;
  int? status;
  int? isActive;
  String? effectiveDateFrom;
  String? effectiveDateTo;
  String? endEffectiveDateFrom;
  String? endEffectiveDateTo;
  String? searchTech;
  int? page;
  int? size;

  SearchComponentReq({
    this.componentCode,
    this.componentName,
    this.messageType,
    this.connectionMethod,
    this.checkToken,
    this.isDisplay,
    this.status,
    this.isActive,
    this.effectiveDateFrom,
    this.effectiveDateTo,
    this.endEffectiveDateFrom,
    this.endEffectiveDateTo,
    this.searchTech,
    this.page,
    this.size,
  });

  SearchComponentReq.initialize() {
    componentCode = null;
    componentName = null;
    messageType = null;
    connectionMethod = null;
    checkToken = null;
    isDisplay = null;
    status = null;
    isActive = null;
    effectiveDateFrom = null;
    effectiveDateTo = null;
    endEffectiveDateFrom = null;
    endEffectiveDateTo = null;
    searchTech = null;
    page = null;
    size = null;
  }

  Map<String, dynamic> toJson() {
    return {
      'componentCode': componentCode,
      'componentName': componentName,
      'messageType': messageType,
      'connectionMethod': connectionMethod,
      'checkToken': checkToken,
      'isDisplay': isDisplay,
      'status': status,
      'isActive': isActive,
      'effectiveDateFrom': effectiveDateFrom,
      'effectiveDateTo': effectiveDateTo,
      'endEffectiveDateFrom': endEffectiveDateFrom,
      'endEffectiveDateTo': endEffectiveDateTo,
      'page': page,
      'size': size,
      'searchTech': searchTech,
    };
  }

  set setComponentCode(String? code) {
    componentCode = code;
  }

  set setComponentName(String? name) {
    componentName = name;
  }

  set setStatus(int? status) {
    status = status;
  }
}
