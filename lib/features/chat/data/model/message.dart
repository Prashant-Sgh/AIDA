class Message {
  final String id;
  final String autherId;
  final DateTime? createdAt;
  final String senderName;

  const Message(
      {required this.id,
      required this.autherId,
      this.createdAt,
      required this.senderName});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      autherId: json['autherId'],
      createdAt: json['createdAt'],
      senderName: json['senderName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'autherId': autherId,
      'DateTime': createdAt,
      'senderName': senderName,
    };
  }
}
