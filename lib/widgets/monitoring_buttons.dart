import 'package:flutter/material.dart';

class MonitoringButtons extends StatelessWidget {
  final bool isConnected;
  final bool isMonitoring;
  final bool isRecording;
  final VoidCallback onStartMonitoring;
  final VoidCallback onStopMonitoring;
  final VoidCallback onTakePicture;
  final VoidCallback onToggleRecording;

  const MonitoringButtons({
    super.key,
    required this.isConnected,
    required this.isMonitoring,
    required this.isRecording,
    required this.onStartMonitoring,
    required this.onStopMonitoring,
    required this.onTakePicture,
    required this.onToggleRecording,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Start/Stop Monitoring Row
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.1,
          decoration: const BoxDecoration(
            color: Color(0xFFC6F3FD),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: isConnected && !isMonitoring ? onStartMonitoring : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF119402),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade400,
                  disabledForegroundColor: Colors.grey.shade600,
                  minimumSize: Size(
                    MediaQuery.sizeOf(context).width * 0.4,
                    MediaQuery.sizeOf(context).height * 0.07,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Start Monitoring',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                onPressed: isConnected && isMonitoring ? onStopMonitoring : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF84F22),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade400,
                  disabledForegroundColor: Colors.grey.shade600,
                  minimumSize: Size(
                    MediaQuery.sizeOf(context).width * 0.4,
                    MediaQuery.sizeOf(context).height * 0.07,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Stop Monitoring',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        
        // Picture/Audio Row
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.1,
          decoration: const BoxDecoration(
            color: Color(0xFFC6F3FD),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: isConnected && isMonitoring ? onTakePicture : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2B81F4),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade400,
                  disabledForegroundColor: Colors.grey.shade600,
                  minimumSize: Size(
                    MediaQuery.sizeOf(context).width * 0.4,
                    MediaQuery.sizeOf(context).height * 0.07,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Take Picture',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                onPressed: isConnected && isMonitoring ? onToggleRecording : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isRecording ? const Color(0xFFF84F22) : const Color(0xFFFB981C),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade400,
                  disabledForegroundColor: Colors.grey.shade600,
                  minimumSize: Size(
                    MediaQuery.sizeOf(context).width * 0.4,
                    MediaQuery.sizeOf(context).height * 0.07,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isRecording ? '🛑 Stop Recording' : 'Record Audio',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}