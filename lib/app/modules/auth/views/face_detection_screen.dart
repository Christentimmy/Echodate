import 'package:camera/camera.dart';
import 'package:echodate/app/controller/auth_controller.dart';
import 'package:echodate/app/services/face_detective_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class FaceDetectionScreen extends StatefulWidget {
  const FaceDetectionScreen({super.key, this.callback});
  final VoidCallback? callback;

  @override
  State<FaceDetectionScreen> createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen>
    with WidgetsBindingObserver {
  late List<CameraDescription> _cameras;
  CameraController? _cameraController;
  late FaceDetectionService _faceDetectionService;

  FaceDirection _currentDirection = FaceDirection.none;
  VerificationStatus _verificationStatus = VerificationStatus.initial;
  int _progress = 0;
  final _authController = Get.find<AuthController>();
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _faceDetectionService = FaceDetectionService();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestCameraPermission();
    });
    // _setupStreams();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopCamera();
    _faceDetectionService.dispose();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    // Add proper permission handling
    final status = await Permission.camera.request();

    if (status.isGranted) {
      _initializeCamera();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text("Camera permission is required for face verification"),
          ),
        );
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _stopCamera();
    } else if (state == AppLifecycleState.resumed && !_isCameraInitialized) {
      _initializeCamera();
    }
  }

  void _setupStreams() {
    _faceDetectionService.directionStream.listen((direction) {
      if (mounted) {
        setState(() {
          _currentDirection = direction;
        });
      }
    });

    _faceDetectionService.verificationStream.listen((status) {
      if (mounted) {
        setState(() {
          _verificationStatus = status;
        });
      }
    });

    _faceDetectionService.progressStream.listen((progress) {
      if (mounted) {
        setState(() {
          _progress = progress;
        });
      }
    });
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        // Handle case where no cameras are available
        print("No cameras available");
        return;
      }

      // Use front camera for face verification
      final frontCamera = _cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      _setupStreams();

      if (!mounted) return;

      await _cameraController!.startImageStream((image) {
        _faceDetectionService.processImage(image, frontCamera);
      });

      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      print("Error initializing camera: $e");
    }
  }

  void _stopCamera() {
    if (_cameraController != null) {
      if (_cameraController!.value.isStreamingImages) {
        _cameraController!.stopImageStream();
      }
      _cameraController!.dispose();
      _cameraController = null;
    }
    if (mounted) {
      setState(() {
        _isCameraInitialized = false;
      });
    }
  }

  void _startVerification() {
    _faceDetectionService.startVerification();
  }

  void _cancelVerification() {
    _faceDetectionService.cancelVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Verify Your Identity',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
        // iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Top section with instruction
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              _verificationStatus == VerificationStatus.inProgress
                  ? _faceDetectionService.currentStep.instruction
                  : _verificationStatus == VerificationStatus.completed
                      ? "Verification Complete"
                      : "Let's confirm it's you",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          // Subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              _verificationStatus == VerificationStatus.initial
                  ? "Follow the instructions to verify your identity"
                  : _verificationStatus == VerificationStatus.completed
                      ? "Thank you for confirming your identity"
                      : "Please follow the prompts for face verification",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          // Main circular camera view (Instagram style)
          _buildCircularCameraView(),
          const SizedBox(height: 30),
          // Status indicator
          if (_verificationStatus == VerificationStatus.inProgress)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LinearProgressIndicator(
                value: _progress / 100,
                backgroundColor: Colors.grey[800],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                minHeight: 4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          const Spacer(),
          // Action button at bottom
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 30,
            ),
            child: _buildActionButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularCameraView() {
    if (!_isCameraInitialized ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return _buildLoadingCircle();
    }

    // Additional null check for preview size
    final previewSize = _cameraController!.value.previewSize;
    if (previewSize == null) {
      return _buildLoadingCircle();
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        // Circular camera preview
        // Circular camera preview with proper fitting and mirror effect
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: _getBorderColor(),
              width: 4,
            ),
          ),
          child: ClipOval(
            child: FittedBox(
              fit: BoxFit.cover, // Ensures proper fitting
              child: SizedBox(
                width: previewSize.height,
                height: previewSize.width,
                child: Transform.scale(
                  scaleX: -1,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            ),
          ),
        ),

        // Circular guide overlay
        if (_currentDirection == FaceDirection.none)
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.red, width: 4),
            ),
            child: Center(
              child: Icon(
                Icons.face,
                color: Colors.red.withOpacity(0.7),
                size: 80,
              ),
            ),
          ),

        // Success checkmark overlay (shown briefly when step completed)
        if (_verificationStatus == VerificationStatus.completed)
          Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black.withOpacity(0.5),
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
          ),

        // Direction indicator
        if (_verificationStatus == VerificationStatus.inProgress &&
            _currentDirection != FaceDirection.none &&
            _currentDirection !=
                _faceDetectionService.currentStep.requiredDirection)
          _buildDirectionIndicator(),
      ],
    );
  }

  Widget _buildDirectionIndicator() {
    IconData iconData;
    double angle = 0;

    // Get required direction
    final requiredDirection =
        _faceDetectionService.currentStep.requiredDirection;

    switch (requiredDirection) {
      case FaceDirection.left:
        iconData = Icons.arrow_back;
        angle = 0;
        break;
      case FaceDirection.right:
        iconData = Icons.arrow_forward;
        angle = 0;
        break;
      case FaceDirection.up:
        iconData = Icons.arrow_upward;
        angle = 0;
        break;
      case FaceDirection.down:
        iconData = Icons.arrow_downward;
        angle = 0;
        break;
      default:
        iconData = Icons.adjust;
        angle = 0;
    }

    return Positioned(
      right: requiredDirection == FaceDirection.left ? 0 : null,
      left: requiredDirection == FaceDirection.right ? 0 : null,
      top: requiredDirection == FaceDirection.down ? 0 : null,
      bottom: requiredDirection == FaceDirection.up ? 0 : null,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: Transform.rotate(
          angle: angle,
          child: Icon(
            iconData,
            color: Colors.blue,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCircle() {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[900],
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    switch (_verificationStatus) {
      case VerificationStatus.initial:
        return ElevatedButton(
          onPressed: _startVerification,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Start Verification',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

      case VerificationStatus.inProgress:
        return OutlinedButton(
          onPressed: _cancelVerification,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.grey),
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        );

      case VerificationStatus.completed:
        return ElevatedButton(
          onPressed: () async {
            await _authController.verifyFace(widget.callback);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Obx(
            () => _authController.isLoading.value
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        );

      case VerificationStatus.failed:
        return ElevatedButton(
          onPressed: _startVerification,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Try Again',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    }
  }

  Color _getBorderColor() {
    if (_verificationStatus != VerificationStatus.inProgress) {
      return Colors.grey;
    }

    if (_currentDirection == FaceDirection.none) {
      return Colors.red;
    }

    final requiredDirection =
        _faceDetectionService.currentStep.requiredDirection;
    return _currentDirection == requiredDirection
        ? Colors.green
        : Colors.orange;
  }
}
