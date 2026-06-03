// lib/data/models/button_model.dart

class ButtonModel {
  final String id;
  final String title;
  final String description;
  final String logo;
  final bool active;

  ButtonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.logo,
    required this.active,
  });

  factory ButtonModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return ButtonModel(
      id: id,
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      logo: map['logo']?.toString() ?? '',
      active: map['active'] == true || map['active'] == 'true',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'logo': logo,
      'active': active,
    };
  }

  ButtonModel copyWith({
    String? id,
    String? title,
    String? description,
    String? logo,
    bool? active,
  }) {
    return ButtonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      logo: logo ?? this.logo,
      active: active ?? this.active,
    );
  }
}
