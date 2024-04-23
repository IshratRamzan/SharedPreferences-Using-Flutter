import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  File? _pickedImage;

  void _saveLoginStatus(bool isLoggedIn, String email) async {
    var sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool('login', isLoggedIn);
    sharedPref.setString('email', email);
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  _getImageFromCamera(context);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  _getImageFromGallery(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }
  Future<void> _getImageFromCamera(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      _captureImage(context);
    } else {
      if (await _requestCameraPermission()) {
        _captureImage(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera permission denied.')),
        );
      }
    }
  }
  void _captureImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected from camera.')),
      );
    }
  }

  Future<bool> _requestGalleryPermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }
  Future<void> _getImageFromGallery(BuildContext context) async {
    final status = await Permission.photos.status;

    if (status.isGranted) {
      _pickImageFromGallery(context);
    } else {
      if (await _requestGalleryPermission()) {
        _pickImageFromGallery(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gallery permission denied.')),
        );
      }
    }
  }
  void _pickImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected from gallery.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: GestureDetector(
                onTap: () {
                  _showImagePickerOptions(context);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _pickedImage != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        _pickedImage!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    )
                        : ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        'https://th.bing.com/th/id/R.95c74e73a0802296ef631dd71dfa09d2?rik=eIiF8VmPmhhzXw&riu=http%3a%2f%2fwww.pngall.com%2fwp-content%2fuploads%2f5%2fUser-Profile-PNG-Image.png&ehk=YvjAOG2T71oFU41G13CCoak98yJU3f0YK669MQiOROg%3d&risl=&pid=ImgRaw&r=0',
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sandra Adams\nsandra_a88@gmail.com',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center, // Center the text
                    ),
                  ],
                ),
              ),
            ),
            const ListTile(
              title: Text('Home'),
              leading: Icon(Icons.home),
            ),
            const ListTile(
              title: Text('My Files'),
              leading: Icon(Icons.drive_file_move_sharp),
            ),
            const ListTile(
              title: Text('Shared with me'),
              leading: Icon(Icons.person),
            ),
            const ListTile(
              title: Text('Starred'),
              leading: Icon(Icons.star),
            ),
            const ListTile(
              title: Text('Recent'),
              leading: Icon(Icons.access_time),
            ),
            const ListTile(
              title: Text('Offline'),
              leading: Icon(Icons.offline_pin_outlined),
            ),
            const ListTile(
              title: Text('Upload'),
              leading: Icon(Icons.upload_sharp),
            ),
            const ListTile(
              title: Text('Logout'),
              leading: Icon(Icons.logout),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Email:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.lightBlueAccent,
                          errorText: _emailError,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Password:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.lightBlueAccent,
                          errorText: _passwordError,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _emailError = validateEmail(_emailController.text);
                    _passwordError = validatePassword(_passwordController.text);

                    if (_emailError == null && _passwordError == null) {
                      _saveLoginStatus(true, _emailController.text);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    }
                  });
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter an email address.';
    }
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter a password.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    return null;
  }
}