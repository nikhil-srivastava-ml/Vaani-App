import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async'; // Import for Completer/Future

class AudioManager {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecorderReady = false;

  // 1. Initialize the recorder and ask for permission
  Future<void> init() async {
    final status = await Permission.microphone.request();
    
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _recorder.openRecorder();
    isRecorderReady = true;
  }

  // 2. Start Recording
  Future<void> startRecording() async {
    if (!isRecorderReady) return;
    // We record to a temporary file named 'vaani_audio.aac'
    await _recorder.startRecorder(
      toFile: 'vaani_audio.wav',
      codec: Codec.pcm16WAV,
    );
  }

  // 3. Stop Recording
  Future<String?> stopRecording() async {
    if (!isRecorderReady) return null;
    return await _recorder.stopRecorder();
  }

  // 4. Clean up memory when app closes
  void dispose() {
    _recorder.closeRecorder();
  }
}