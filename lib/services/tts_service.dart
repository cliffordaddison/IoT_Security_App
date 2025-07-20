import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  TtsService() {
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      
      // Set up completion handler
      _flutterTts.setCompletionHandler(() {
        print("TTS completed");
      });

      // Set up error handler
      _flutterTts.setErrorHandler((msg) {
        print("TTS error: $msg");
      });

      _isInitialized = true;
    } catch (e) {
      print("TTS initialization error: $e");
      _isInitialized = false;
    }
  }

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await _initializeTts();
    }

    if (_isInitialized && text.isNotEmpty) {
      try {
        await _flutterTts.stop();
        await _flutterTts.speak(text);
      } catch (e) {
        print("TTS speak error: $e");
      }
    }
  }

  Future<void> stop() async {
    if (_isInitialized) {
      try {
        await _flutterTts.stop();
      } catch (e) {
        print("TTS stop error: $e");
      }
    }
  }

  // Predefined security announcements
  Future<void> announceFireAlarm() async {
    await speak("Fire alarm detected! Evacuate immediately!");
  }

  Future<void> announceGlassBreaking() async {
    await speak("Possible intrusion detected! Alerting security.");
  }

  Future<void> announceBabyCrying() async {
    await speak("Baby crying detected. Notifying guardian.");
  }

  Future<void> announceDoorbell() async {
    await speak("Doorbell detected. Please check the entrance.");
  }

  Future<void> announceGunshot() async {
    await speak("Gunshot detected! Take cover and call emergency services.");
  }

  Future<void> announceUnknownPerson() async {
    await speak("Unrecognized person at the door. Proceed with caution.");
  }

  Future<void> announceLowLight() async {
    await speak("Low visibility detected. Turning on night mode.");
  }

  Future<void> announceNoFaceMask() async {
    await speak("Face mask not detected! Please wear a mask.");
  }

  Future<void> announceHighCrowdDensity() async {
    await speak("High crowd density detected. Maintain social distancing.");
  }

  Future<void> announceSuspiciousObject() async {
    await speak("Unattended object detected. Please inspect.");
  }

  Future<void> announceAnimalIntrusion() async {
    await speak("Animal intrusion detected! Stay alert.");
  }

  Future<void> announceUnauthorizedMovement() async {
    await speak("Unauthorized movement detected! Security alert triggered.");
  }

  Future<void> announceSystemStatus(String status) async {
    await speak("System status: $status");
  }

  Future<void> announceConnectionStatus(bool isConnected) async {
    if (isConnected) {
      await speak("System connected successfully");
    } else {
      await speak("Connection to system lost");
    }
  }

  Future<void> announceMonitoringStatus(bool isMonitoring) async {
    if (isMonitoring) {
      await speak("Security monitoring activated");
    } else {
      await speak("Security monitoring deactivated");
    }
  }

  Future<void> announceRecordingStatus(bool isRecording) async {
    if (isRecording) {
      await speak("Audio recording started");
    } else {
      await speak("Audio recording stopped");
    }
  }

  Future<void> announcePictureTaken() async {
    await speak("Picture captured successfully");
  }

  Future<void> announceDetection(String detectionType) async {
    switch (detectionType.toLowerCase()) {
      case 'fire':
        await announceFireAlarm();
        break;
      case 'glass':
        await announceGlassBreaking();
        break;
      case 'baby':
        await announceBabyCrying();
        break;
      case 'doorbell':
        await announceDoorbell();
        break;
      case 'gunshot':
        await announceGunshot();
        break;
      case 'unknown person':
        await announceUnknownPerson();
        break;
      case 'low light':
        await announceLowLight();
        break;
      case 'no mask':
        await announceNoFaceMask();
        break;
      case 'crowd':
        await announceHighCrowdDensity();
        break;
      case 'suspicious object':
        await announceSuspiciousObject();
        break;
      case 'animal':
        await announceAnimalIntrusion();
        break;
      case 'motion':
        await announceUnauthorizedMovement();
        break;
      default:
        await speak("Security alert: $detectionType detected");
    }
  }

  // Dispose resources when no longer needed
  Future<void> dispose() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      print("Error disposing TTS: $e");
    }
  }
}