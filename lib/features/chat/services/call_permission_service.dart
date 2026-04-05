import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

class CallPermissionService {
  static final CallPermissionService _instance =
      CallPermissionService._internal();
  factory CallPermissionService() => _instance;
  CallPermissionService._internal();

  /// Request microphone and camera permissions for calls.
  /// Returns true if all required permissions are granted.
  Future<bool> requestCallPermissions() async {
    final microphoneStatus = await Permission.microphone.status;
    final cameraStatus = await Permission.camera.status;

    // If already granted, return true
    if (microphoneStatus.isGranted && cameraStatus.isGranted) {
      return true;
    }

    // Request permissions
    final results = await [Permission.microphone, Permission.camera].request();

    final microphoneGranted =
        results[Permission.microphone]?.isGranted ?? false;
    final cameraGranted = results[Permission.camera]?.isGranted ?? false;

    debugPrint(
      'Call permissions - microphone: $microphoneGranted, camera: $cameraGranted',
    );

    return microphoneGranted && cameraGranted;
  }

  /// Check if call permissions are already granted without requesting.
  Future<bool> hasCallPermissions() async {
    final microphoneStatus = await Permission.microphone.status;
    final cameraStatus = await Permission.camera.status;
    return microphoneStatus.isGranted && cameraStatus.isGranted;
  }

  /// Request microphone only (for voice call).
  Future<bool> requestMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) return true;

    final result = await Permission.microphone.request();
    debugPrint('Microphone permission: ${result.isGranted}');
    return result.isGranted;
  }

  /// Request camera permission (for video call).
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status.isGranted) return true;

    final result = await Permission.camera.request();
    debugPrint('Camera permission: ${result.isGranted}');
    return result.isGranted;
  }

  /// Open app settings if permissions are permanently denied.
  Future<bool> openSettings() async {
    return await openAppSettings();
  }
}
