class Feature {
  final String name;

  Feature({
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  factory Feature.fromJson(Map<String, dynamic> json) {
    return Feature(name: json['name']);
  }
}
