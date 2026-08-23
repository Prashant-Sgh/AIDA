/// Represents an application session with its unique identifier and metadata.
class AppSession {
  /// The unique session identifier for this app instance.
  final String sessionId;

  /// Timestamp when this session was created.
  final DateTime createdAt;

  /// Optional metadata for future extensibility (e.g., device info, app version).
  final Map<String, dynamic>? metadata;

  const AppSession({
    required this.sessionId,
    required this.createdAt,
    this.metadata,
  });

  /// Creates a copy of this session with optionally updated fields.
  AppSession copyWith({
    String? sessionId,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) {
    return AppSession(
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSession &&
          runtimeType == other.runtimeType &&
          sessionId == other.sessionId &&
          createdAt == other.createdAt &&
          metadata == other.metadata;

  @override
  int get hashCode => Object.hash(sessionId, createdAt, metadata);

  @override
  String toString() =>
      'AppSession(sessionId: $sessionId, createdAt: $createdAt, metadata: $metadata)';
}