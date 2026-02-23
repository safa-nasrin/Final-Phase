import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'dart:math';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/user_model.dart';
import '../services/mongo_service.dart';

class ScanScreen extends StatefulWidget {
  final User user;

  const ScanScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool _isProcessing = false;
  String? _result;

  final List<String> _possibleBloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        // On mobile it automatically gives option for camera if using specific packages/configs,
        // But for explicit camera support we could show a dialog to choose source.
        // For simplicity and web compatibility, standard image picker works well:
      );

      if (pickedFile != null) {
        setState(() {
          _imageFile = pickedFile;
          _isProcessing = true;
          _result = null;
        });
        
        _simulateProcessing();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _simulateProcessing() async {
    // Simulate API delay/YOLO processing
    await Future.delayed(const Duration(seconds: 4));
    
    // Mock Result
    final randomGroup = _possibleBloodGroups[Random().nextInt(_possibleBloodGroups.length)];
    
    // Save to DB
    final scanResult = ScanResult(
      timestamp: DateTime.now(),
      bloodGroup: randomGroup,
    );
    
    bool saved = await MongoService.addScanResult(widget.user.id, scanResult);
    
    if (mounted) {
      setState(() {
        _isProcessing = false;
        _result = randomGroup;
      });
      
      if (!saved) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save result to history.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Scan'),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[800]!, Colors.blue[200]!],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: _imageFile == null
                    ? _buildPlaceholder()
                    : _buildImagePreview(),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _pickImage,
                  icon: const Icon(Icons.document_scanner, size: 28),
                  label: const Text(
                    'Scan Fingerprint',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[800],
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.fingerprint, size: 120, color: Colors.white.withOpacity(0.5)),
        const SizedBox(height: 20),
        const Text(
          'Select an image to analyze',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 5,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Handle Web vs Mobile image display
            kIsWeb 
                ? Image.network(_imageFile!.path, fit: BoxFit.cover, width: 300, height: 400)
                : Image.file(File(_imageFile!.path), fit: BoxFit.cover, width: 300, height: 400),
                
            if (_isProcessing)
               Container(
                 width: 300,
                 height: 400,
                 color: Colors.black54,
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     // Lottie animation for processing laser
                     // Using a network URL for a generic scanning animation
                     Lottie.network(
                       'https://assets9.lottiefiles.com/packages/lf20_t2v9pksd.json', // Example fingerprint scan lottie
                       width: 150,
                       height: 150,
                       errorBuilder: (context, error, stackTrace) => const CircularProgressIndicator(color: Colors.cyanAccent),
                     ),
                     const SizedBox(height: 20),
                     const Text(
                       'Verifying...',
                       style: TextStyle(color: Colors.cyanAccent, fontSize: 24, fontWeight: FontWeight.bold),
                     ),
                   ],
                 ),
               ),
               
            if (_result != null)
              Container(
                width: 300,
                height: 400,
                color: Colors.blue[900]!.withOpacity(0.85),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.greenAccent, size: 80),
                    const SizedBox(height: 16),
                    const Text('Detected Blood Group:', style: TextStyle(color: Colors.white, fontSize: 18)),
                    const SizedBox(height: 8),
                    Text(
                      _result!,
                      style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
