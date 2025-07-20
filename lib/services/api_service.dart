import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;
  static const Duration _timeout = Duration(seconds: 10);

  ApiService({required this.baseUrl});

  // Test connection to Raspberry Pi
  Future<String> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/status'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Connected to Raspberry Pi successfully';
      } else {
        throw Exception('Failed to connect: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Connection failed: $e');
    }
  }

  // Start monitoring
  Future<String> startMonitoring() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/start_monitoring'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Security monitoring started successfully';
      } else {
        throw Exception('Failed to start monitoring: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Start monitoring failed: $e');
    }
  }

  // Stop monitoring
  Future<String> stopMonitoring() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/stop_monitoring'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Security monitoring stopped successfully';
      } else {
        throw Exception('Failed to stop monitoring: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Stop monitoring failed: $e');
    }
  }

  // Take picture
  Future<String> takePicture() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/take_picture'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Picture captured successfully';
      } else {
        throw Exception('Failed to take picture: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Take picture failed: $e');
    }
  }

  // Start recording audio
  Future<String> startRecording() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/start_recording'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Audio recording started';
      } else {
        throw Exception('Failed to start recording: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Start recording failed: $e');
    }
  }

  // Stop recording audio
  Future<String> stopRecording() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/stop_recording'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Audio recording stopped and processed';
      } else {
        throw Exception('Failed to stop recording: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Stop recording failed: $e');
    }
  }

  // Get system status
  Future<Map<String, dynamic>> getSystemStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/system_status'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get system status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Get system status failed: $e');
    }
  }

  // Get latest detection results
  Future<Map<String, dynamic>> getLatestDetections() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/latest_detections'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get detections: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Get detections failed: $e');
    }
  }

  // Upload audio file (if needed for manual upload)
  Future<String> uploadAudio(String audioPath) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload_audio'));
      request.files.add(await http.MultipartFile.fromPath('audio', audioPath));
      
      final streamedResponse = await request.send().timeout(_timeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Audio uploaded and processed successfully';
      } else {
        throw Exception('Failed to upload audio: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Upload audio failed: $e');
    }
  }

  // Emergency alert
  Future<String> sendEmergencyAlert(String alertType, String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/emergency_alert'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'alert_type': alertType,
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['message'] ?? 'Emergency alert sent successfully';
      } else {
        throw Exception('Failed to send alert: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Send alert failed: $e');
    }
  }
}