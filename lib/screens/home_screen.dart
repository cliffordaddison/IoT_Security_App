import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/tts_service.dart';
import '../widgets/monitoring_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ipController = TextEditingController();
  final FocusNode _ipFocusNode = FocusNode();
  
  bool isConnected = false;
  bool isMonitoring = false;
  bool isRecording = false;
  String statusText = "System Ready";
  String systemResponse = "Waiting for system responses...";
  
  ApiService? apiService;
  final TtsService tts = TtsService();
  
  @override
  void initState() {
    super.initState();
    tts.speak("System Initiated");
  }
  
  @override
  void dispose() {
    _ipController.dispose();
    _ipFocusNode.dispose();
    super.dispose();
  }
  
  void _setApiService() {
    final input = _ipController.text.trim();
    if (input.isNotEmpty) {
      final baseUrl = input.startsWith('http') ? input : 'http://$input';
      apiService = ApiService(baseUrl: baseUrl);
    }
  }
  
  void _connectToRaspberryPi() async {
    if (_ipController.text.trim().isEmpty) {
      _showSnackBar("Please enter Raspberry Pi IP address");
      return;
    }
    
    setState(() {
      statusText = "Connecting to Raspberry Pi...";
    });
    
    _setApiService();
    
    try {
      final response = await apiService!.testConnection();
      setState(() {
        isConnected = true;
        statusText = "Connected to Raspberry Pi";
        systemResponse = response;
      });
      tts.speak("System connected successfully");
    } catch (e) {
      setState(() {
        isConnected = false;
        statusText = "Failed to connect to Raspberry Pi";
        systemResponse = "Connection failed: ${e.toString()}";
      });
      tts.speak("Connection failed");
    }
  }
  
  void _startMonitoring() async {
    if (!isConnected || apiService == null) return;
    
    try {
      final response = await apiService!.startMonitoring();
      setState(() {
        isMonitoring = true;
        systemResponse = response;
      });
      tts.speak("Security Monitoring started");
    } catch (e) {
      _showSnackBar("Failed to start monitoring: ${e.toString()}");
    }
  }
  
  void _stopMonitoring() async {
    if (!isConnected || apiService == null) return;
    
    try {
      final response = await apiService!.stopMonitoring();
      setState(() {
        isMonitoring = false;
        isRecording = false;
        systemResponse = response;
      });
      tts.speak("Security Monitoring stopped");
    } catch (e) {
      _showSnackBar("Failed to stop monitoring: ${e.toString()}");
    }
  }
  
  void _takePicture() async {
    if (!isConnected || !isMonitoring || apiService == null) return;
    
    try {
      tts.speak("Capturing photo");
      final response = await apiService!.takePicture();
      setState(() {
        systemResponse = response;
      });
    } catch (e) {
      _showSnackBar("Failed to take picture: ${e.toString()}");
    }
  }
  
  void _toggleRecording() async {
    if (!isConnected || !isMonitoring || apiService == null) return;
    
    try {
      if (!isRecording) {
        tts.speak("Recording started");
        final response = await apiService!.startRecording();
        setState(() {
          isRecording = true;
          systemResponse = response;
        });
      } else {
        final response = await apiService!.stopRecording();
        setState(() {
          isRecording = false;
          systemResponse = response;
        });
        tts.speak("Recording stopped and uploaded");
      }
    } catch (e) {
      _showSnackBar("Recording operation failed: ${e.toString()}");
    }
  }
  
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE9E9E9),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1F2937),
          automaticallyImplyLeading: false,
          title: const Text(
            '🛡️ IOT Security System',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Status Bar
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.05,
                decoration: BoxDecoration(
                  color: isConnected ? const Color(0xFFC2FDCD) : const Color(0xFFFFE6E6),
                ),
                child: Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    statusText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isConnected ? const Color(0xFF126700) : const Color(0xFF8B0000),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              
              // Connection Section
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.2,
                decoration: const BoxDecoration(
                  color: Color(0xFFE9E9E9),
                ),
                child: Stack(
                  children: [
                    // Title
                    const Align(
                      alignment: AlignmentDirectional(-0.06, -0.92),
                      child: Text(
                        '🔗 Raspberry Pi Connection',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    // IP Input Field
                    Align(
                      alignment: AlignmentDirectional(0, -0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: TextFormField(
                          controller: _ipController,
                          focusNode: _ipFocusNode,
                          autofocus: false,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Enter Pi IP (e.g., 192.168.1.100:5000)',
                            hintStyle: const TextStyle(
                              color: Color(0xFF626A6F),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFF1F2937),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    
                    // Connection Status
                    Align(
                      alignment: AlignmentDirectional(-0.01, 0.15),
                      child: Text(
                        isConnected ? '🟢 Connected' : '🔴 Disconnected',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    
                    // Connect Button
                    Align(
                      alignment: AlignmentDirectional(-0.01, 0.81),
                      child: ElevatedButton(
                        onPressed: _connectToRaspberryPi,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F2937),
                          foregroundColor: Colors.white,
                          minimumSize: Size(
                            MediaQuery.sizeOf(context).width * 0.6,
                            MediaQuery.sizeOf(context).height * 0.06,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Connect to Raspberry Pi',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Monitoring Buttons
              MonitoringButtons(
                isConnected: isConnected,
                isMonitoring: isMonitoring,
                isRecording: isRecording,
                onStartMonitoring: _startMonitoring,
                onStopMonitoring: _stopMonitoring,
                onTakePicture: _takePicture,
                onToggleRecording: _toggleRecording,
              ),
              
              // System Response Section
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.34,
                decoration: const BoxDecoration(
                  color: Color(0xFFFBEBB7),
                ),
                child: Stack(
                  children: [
                    const Align(
                      alignment: AlignmentDirectional(0, -1),
                      child: Padding(
                        padding: EdgeInsets.all(6),
                        child: Text(
                          'System Response',
                          style: TextStyle(
                            color: Color(0xFFFD5410),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, -0.2),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          child: Text(
                            systemResponse,
                            style: const TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Footer
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * 0.035,
                decoration: const BoxDecoration(
                  color: Color(0xFF272727),
                ),
                child: const Align(
                  alignment: AlignmentDirectional.center,
                  child: Text(
                    'IoT Security System v1.2',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}