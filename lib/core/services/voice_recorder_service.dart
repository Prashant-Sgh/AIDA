import 'dart:async';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class VoiceRecorderService {
  final AudioRecorder _audioRecorder = AudioRecorder();
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  
  // Controller to broadcast amplitude updates to the UI
  final StreamController<double> _amplitudeController = StreamController<double>.broadcast();
  Stream<double> get amplitudeStream => _amplitudeController.stream;

  Future<bool> isRecording() async => await _audioRecorder.isRecording();

  /// Starts the audio recording process.
  /// Returns true if started successfully, false otherwise.
  Future<bool> startRecording() async {
    try {
      // Handle permissions for Mobile platforms
      if (!kIsWeb) {
        final status = await Permission.microphone.request();
        if (status != PermissionStatus.granted) {
          return false;
        }
      }

      // Check if already recording
      if (await _audioRecorder.isRecording()) {
        return false;
      }

      // Configuration for the recording
      const config = RecordConfig(); // Default config

      // Define path for mobile; for web, this is ignored by the package
      String path = '';
      if (!kIsWeb) {
        path = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
      }

      await _audioRecorder.start(config, path: path);

      // Start listening to amplitude
      // Fixed: record package 5.x+ typically requires a duration for onAmplitudeChanged()
      _amplitudeSubscription = _audioRecorder.onAmplitudeChanged(const Duration(milliseconds: 100)).listen((amplitude) {
        // record package provides amplitude in decibels (dB). 
        // Normalize -60dB as 0 and 0dB as 1.
        double normalized = (amplitude.current.toDouble() + 60) / 60;
        _amplitudeController.add(normalized.clamp(0.0, 1.0));
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Stops the recording process.
  /// Returns the path to the recorded file.
  Future<String?> stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      
      await _amplitudeSubscription?.cancel();
      _amplitudeSubscription = null;
      
      // Reset amplitude to 0
      _amplitudeController.add(0.0);
      
      return path;
    } catch (e) {
      return null;
    }
  }

  /// Disposes of the recorder and controllers.
  void dispose() {
    _amplitudeSubscription?.cancel();
    _amplitudeController.close();
    _audioRecorder.dispose();
  }
}
