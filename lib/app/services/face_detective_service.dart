
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:flutter/services.dart';

enum FaceDirection {
  straight,
  left,
  right,
  up,
  down,
  none,
}

enum VerificationStatus {
  initial,
  inProgress,
  completed,
  failed,
}

class FaceVerificationStep {
  final String instruction;
  final FaceDirection requiredDirection;

  FaceVerificationStep({
    required this.instruction,
    required this.requiredDirection,
  });
}

class FaceDetectionService {
  final FaceDetector _faceDetector;
  bool _isBusy = false;

  // Stream controllers for state management
  final _directionController = StreamController<FaceDirection>.broadcast();
  final _verificationController =
      StreamController<VerificationStatus>.broadcast();
  final _progressController = StreamController<int>.broadcast();

  // Steps for verification process
  final List<FaceVerificationStep> _verificationSteps = [
    FaceVerificationStep(
      instruction: "Center your face",
      requiredDirection: FaceDirection.straight,
    ),
    FaceVerificationStep(
      instruction: "Turn right",
      requiredDirection: FaceDirection.right,
    ),
    FaceVerificationStep(
      instruction: "Turn left",
      requiredDirection: FaceDirection.left,
    ),
    FaceVerificationStep(
      instruction: "Look up",
      requiredDirection: FaceDirection.up,
    ),
  ];

  int _currentStepIndex = 0;
  List<bool> _completedSteps = [];
  bool _isVerificationInProgress = false;

  // Public streams
  Stream<FaceDirection> get directionStream => _directionController.stream;
  Stream<VerificationStatus> get verificationStream =>
      _verificationController.stream;
  Stream<int> get progressStream => _progressController.stream;

  // Current verification step
  FaceVerificationStep get currentStep => _verificationSteps[_currentStepIndex];

  FaceDetectionService()
      : _faceDetector = FaceDetector(
            options: FaceDetectorOptions(
          enableContours: true,
          enableLandmarks: true,
          enableTracking: true,
          performanceMode: FaceDetectorMode.accurate,
        )) {
    _completedSteps = List.filled(_verificationSteps.length, false);
  }

  Future<void> processImage(
      CameraImage cameraImage, CameraDescription camera) async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      final inputImage =
          await _convertCameraImageToInputImage(cameraImage, camera);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        _directionController.add(FaceDirection.none);
      } else {
        final face = faces.first;
        final direction = _detectFaceDirection(face);
        _directionController.add(direction);

        if (_isVerificationInProgress) {
          _processVerificationStep(direction);
        }
      }
    } catch (e) {
      print("Error processing image: $e");
    } finally {
      _isBusy = false;
    }
  }

  void startVerification() {
    _isVerificationInProgress = true;
    _currentStepIndex = 0;
    _completedSteps = List.filled(_verificationSteps.length, false);
    _verificationController.add(VerificationStatus.inProgress);
    _progressController.add(0);
  }

  void cancelVerification() {
    _isVerificationInProgress = false;
    _verificationController.add(VerificationStatus.initial);
  }

  void _processVerificationStep(FaceDirection detectedDirection) {
    final requiredDirection = currentStep.requiredDirection;

    if (detectedDirection == requiredDirection) {
      // Mark current step as completed if not already
      if (!_completedSteps[_currentStepIndex]) {
        _completedSteps[_currentStepIndex] = true;

        // Move to next step if available
        if (_currentStepIndex < _verificationSteps.length - 1) {
          _currentStepIndex++;
        }

        // Calculate progress percentage
        int completedCount =
            _completedSteps.where((completed) => completed).length;
        int progressPercentage =
            ((completedCount / _verificationSteps.length) * 100).round();
        _progressController.add(progressPercentage);

        // Check if all steps are completed
        if (_completedSteps.every((completed) => completed)) {
          _isVerificationInProgress = false;
          _verificationController.add(VerificationStatus.completed);
        }
      }
    }
  }

  FaceDirection _detectFaceDirection(Face face) {
    final headEulerAngleY = face.headEulerAngleY ?? 0; // Left/right rotation
    final headEulerAngleX = face.headEulerAngleX ?? 0; // Up/down rotation

    // Adjust the direction logic
    if (headEulerAngleY > 30)
      return FaceDirection.left; // Swapped right -> left
    if (headEulerAngleY < -30)
      return FaceDirection.right; // Swapped left -> right
    if (headEulerAngleX < -15) return FaceDirection.down; // Swapped up -> down
    if (headEulerAngleX > 15) return FaceDirection.up; // Swapped down -> up

    return FaceDirection.straight;
  }

  Future<InputImage> _convertCameraImageToInputImage(
    CameraImage cameraImage,
    CameraDescription camera,
  ) async {
    // Complex conversion based on camera rotation and format
    // This is a simplified version - you might need to adjust for different platforms

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final imageRotation = _getImageRotation(camera.sensorOrientation);

    final inputImageFormat = InputImageFormat.nv21;

    final inputImageMetadata = InputImageMetadata(
      size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: cameraImage.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: inputImageMetadata,
    );
  }

  InputImageRotation _getImageRotation(int sensorOrientation) {
    switch (sensorOrientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  void dispose() {
    _faceDetector.close();
    _directionController.close();
    _verificationController.close();
    _progressController.close();
  }
}
