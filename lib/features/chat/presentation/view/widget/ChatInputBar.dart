import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:aida/core/services/voice_recorder_service.dart';
import 'package:aida/features/chat/presentation/view/widget/voice_waveform.dart';

enum RecordingState { idle, recording }

class ChatInputBar extends StatefulWidget {
  final Future<void> Function(String) sendMessage;
  const ChatInputBar({super.key, required this.sendMessage});

  @override
  State<ChatInputBar> createState() => _ChatInputBar();
}

class _ChatInputBar extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  final VoiceRecorderService _recorderService = VoiceRecorderService();

  RecordingState _recordingState = RecordingState.idle;
  Timer? _durationTimer;
  int _durationSeconds = 0;
  double _currentAmplitude = 0.0;
  StreamSubscription? _amplitudeSubscription;

  final ScrollController _singleChildScrollController = ScrollController();

  final ScrollController _textFieldScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _singleChildScrollController.dispose();
    _textFieldScrollController.dispose();

    _controller.dispose();
    _recorderService.dispose();
    _durationTimer?.cancel();
    _amplitudeSubscription?.cancel();

    super.dispose();
  }

  void _startRecording() async {
    bool started = await _recorderService.startRecording();
    debugPrint('[Debug Print] Recording started: $started');
    if (started) {
      setState(() {
        _recordingState = RecordingState.recording;
        _durationSeconds = 0;
      });

      _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _durationSeconds++;
        });
      });

      _amplitudeSubscription =
          _recorderService.amplitudeStream.listen((amplitude) {
        setState(() {
          _currentAmplitude = amplitude;
        });
      });
    }
  }

  void _stopRecording() async {
    String? path = await _recorderService.stopRecording();
    _durationTimer?.cancel();
    await _amplitudeSubscription?.cancel();

    setState(() {
      _recordingState = RecordingState.idle;
      _currentAmplitude = 0.0;
    });

    if (path != null) {
      debugPrint('Recording stopped. File path: $path');
    }
  }

  void _cancelRecording() async {
    await _recorderService.stopRecording();
    _durationTimer?.cancel();
    await _amplitudeSubscription?.cancel();

    setState(() {
      _recordingState = RecordingState.idle;
      _durationSeconds = 0;
      _currentAmplitude = 0.0;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onSurface.withOpacity(0.7);
    // final singleChildScrollController = ScrollController();
    // final textFieldScrollController = ScrollController();
    final backgroundColor = theme.colorScheme.onSurface.withAlpha(15);
    final isEnabled = _controller.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 200,
          maxWidth: double.infinity,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(
              color: theme.colorScheme.onSurface.withAlpha(50),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0),
                child: SingleChildScrollView(
                  controller: _singleChildScrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 20,
                      maxHeight: 100,
                    ),
                    child: TextField(
                      // onChanged: (value) => setState(() {
                      //   _controller.text = value;
                      // }),
                      onChanged: (_) {
                        setState(() {});
                      },
                      controller: _controller,
                      maxLines: null,
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      cursorColor: theme.colorScheme.onSurface,
                      scrollController: _textFieldScrollController,
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'What would you like to know?',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 12),
                  if (_recordingState == RecordingState.recording)
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: iconColor),
                      onPressed: _cancelRecording,
                      splashRadius: 24,
                    ),
                  IconButton(
                    icon: Icon(
                        _recordingState == RecordingState.idle
                            ? Icons.mic_rounded
                            : Icons.stop_circle_outlined,
                        color: iconColor),
                    onPressed: () {
                      if (_recordingState == RecordingState.idle) {
                        _startRecording();
                      } else {
                        _stopRecording();
                      }
                    },
                    splashRadius: 24,
                  ),
                  if (_recordingState == RecordingState.recording) ...[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: SizedBox(
                          height: 32,
                          child: VoiceWaveform(
                            amplitude: _currentAmplitude,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        _formatDuration(_durationSeconds),
                        style: GoogleFonts.quicksand(
                          color: iconColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ] else
                    const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: isEnabled
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withAlpha(100),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_upward_rounded,
                            size: 14, color: theme.colorScheme.surface),
                        onPressed: isEnabled
                            ? () {
                                widget.sendMessage(_controller.text);
                                _controller.clear();
                              }
                            : null,
                        splashRadius: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
