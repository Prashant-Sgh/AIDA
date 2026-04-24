class ContextModel {
  final String id;
  final String name;
  final String content;

  ContextModel({required this.id, required this.name, required this.content});

  factory ContextModel.fromJson(Map<String, dynamic> data, String id) {
    return ContextModel(
      id: data['id'],
      name: data['name'],
      content: data['content'],
    );
  }
}
