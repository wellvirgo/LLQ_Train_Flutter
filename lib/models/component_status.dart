class ComponentStatus {
  int value;
  String label;

  ComponentStatus({required this.value, required this.label});

  factory ComponentStatus.fromJson(Map<String, dynamic> json) {
    return ComponentStatus(
      value: json['value'] as int,
      label: json['label'] as String,
    );
  }
}
