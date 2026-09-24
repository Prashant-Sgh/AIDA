import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';

class TranscriptResult {
  final String transcript;
  final bool isFinal;
  final bool speechFinal;

  const TranscriptResult({
    required this.transcript,
    required this.isFinal,
    required this.speechFinal,
  });

  factory TranscriptResult.fromJson(Map<String, dynamic> json) {
    return TranscriptResult(
      transcript: json['transcript'] as String? ?? '',
      isFinal: json['is_final'] as bool? ?? false,
      speechFinal: json['speech_final'] as bool? ?? false,
    );
  }
}

class SttWebSocketService {
  static final Uri _endpoint = Uri.parse('wss://aida-stt.onrender.com');

  WebSocketChannel? _channel;
  StreamSubscription<Uint8List>? _audioSubscription;
  StreamSubscription? _socketSubscription;

  final StreamController<TranscriptResult> _transcriptController =
      StreamController<TranscriptResult>.broadcast();

  Stream<TranscriptResult> get transcriptStream => _transcriptController.stream;

  Future<void> start(Stream<Uint8List> audioStream) async {
    await stop();

    final channel = WebSocketChannel.connect(_endpoint);
    _channel = channel;
    await channel.ready;

    _socketSubscription = channel.stream.listen((message) {
      if (message is! String) return;

      final decoded = jsonDecode(message);
      if (decoded is Map<String, dynamic> && decoded['type'] == 'transcript') {
        _transcriptController.add(TranscriptResult.fromJson(decoded));
      }
    });

    _audioSubscription = audioStream.listen(channel.sink.add);
  }

  Future<void> stop() async {
    await _audioSubscription?.cancel();
    await _socketSubscription?.cancel();
    _audioSubscription = null;
    _socketSubscription = null;
    await _channel?.sink.close();
    _channel = null;
  }

  Future<void> dispose() async {
    await stop();
    await _transcriptController.close();
  }
}
