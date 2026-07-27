class ContextModel {
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  final String name;
  final String content;

  ContextModel({required this.id, required this.name, required this.content});

  ContextModel copyWith({
    String? id,
    String? name,
    String? content,
  }) {
    return ContextModel(
      id: id ?? this.id,
      name: name ?? this.name,
      content: content ?? this.content,
    );
  }
  
  factory ContextModel.fromJson(Map<String, dynamic> data) {
    return ContextModel(
      id: data['id'],
      name: data['name'],
      content: data['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content': content,
    };
  }
}
