import 'dart:convert';
import 'dart:io';

import 'package:barterit/myconfig.dart';
import 'package:barterit/screens/User/orderScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/screens/User/loginScreen.dart';
import 'package:barterit/screens/User/registrationScreen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class profilePage extends StatefulWidget {
  final User user;

  const profilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  late double screenHeight, screenWidth;
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _checkProfilePictureExistence() async {
    if (widget.user.id != null) {
      final response = await http.head(
        Uri.parse(
            "${MyConfig().SERVER}/barterit/assets/profiles/${widget.user.id}.png"),
      );
      return response.statusCode == 200;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              height: screenHeight * 0.3,
              width: screenWidth,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FutureBuilder<bool>(
                      future: _checkProfilePictureExistence(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasData && snapshot.data!) {
                          return ClipOval(
                            child: CachedNetworkImage(
                              width: screenWidth * 0.4,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${MyConfig().SERVER}/barterit/assets/profiles/${widget.user.id}.png",
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          );
                        } else {
                          return ClipOval(
                            child: Image.asset(
                              'assets/images/profile.png',
                              width: screenWidth * 0.4,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      },
                    ),
                    Text(
                      widget.user.name.toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                        fontFamily: 'Pacifico', // Add this
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.01), // Adjust this value
                            child: ListTile(
                              leading:
                                  Icon(Icons.person, color: Colors.deepPurple),
                              title: Text("ID: ${widget.user.id.toString()}"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0), // Adjust this value
                            child: ListTile(
                              leading:
                                  Icon(Icons.email, color: Colors.deepPurple),
                              title: Text(
                                  "Email: ${widget.user.email.toString()}"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0), // Adjust this value
                            child: ListTile(
                              leading:
                                  Icon(Icons.phone, color: Colors.deepPurple),
                              title: Text(
                                  "Phone: ${widget.user.phone.toString()}"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0), // Adjust this value
                            child: ListTile(
                              leading: Icon(Icons.date_range,
                                  color: Colors.deepPurple),
                              title: Text(
                                  "Registration Date: ${widget.user.datereg.toString()}"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: screenWidth,
              alignment: Alignment.center,
              color: Theme.of(context).colorScheme.background,
              child: const Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                child: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: widget.user.id == "0"
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileScreen(user: widget.user),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.edit, size: 24),
                          const SizedBox(width: 8),
                          const Text(
                            "EDIT PROFILE",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderScreen(user: widget.user),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.shopping_cart, size: 24),
                          const SizedBox(width: 8),
                          const Text(
                            "MY ORDER",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChangePasswordDialog(user: widget.user),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock, size: 24),
                          const SizedBox(width: 8),
                          const Text(
                            "CHANGE PASSWORD",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const loginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.logout, size: 24),
                          const SizedBox(width: 8),
                          const Text(
                            "LOG OUT",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const registrationScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.deepPurple,
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_add, size: 24),
                          const SizedBox(width: 8),
                          const Text(
                            "REGISTRATION",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
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

class EditProfileScreen extends StatefulWidget {
  final User user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  final _emailController = TextEditingController();
  final _rePassController = TextEditingController();
  bool _isPasswordVisible = false;
  File? _image;

  List<File> selectedImages =
      []; // New list to store selected and cropped images

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name!;
    _phoneController.text = widget.user.phone!;
    _passController.text = widget.user.password!;
  }

  Future<void> updateUser() async {
    if (_passController.text != _rePassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }
    String? id = widget.user.id;
    String name = _nameController.text;
    String phone = _phoneController.text;
    if (_image != null) {
      String base64Image = base64Encode(await _image!.readAsBytes());
      var url = Uri.parse('${MyConfig().SERVER}/barterit/php/edit_profile.php');
      var response = await http.post(url, body: {
        'userid': id,
        'newname': name,
        'newphone': phone,
        'image': base64Image,
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update successful')),
        );
      } else {}
    }
  }

  Future<void> _selectFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        // CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        //CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio3x2,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ClipOval(
                  child: _image != null
                      ? Image.file(
                          _image!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/images/profile.png",
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              ElevatedButton(
                onPressed: _selectFromCamera,
                child: const Text("Select Images from Camera"),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: updateUser,
                child: const Text("Update Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordDialog extends StatefulWidget {
  final User user;

  const ChangePasswordDialog({required this.user});

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmNewPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your current password.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a new password.';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmNewPasswordController,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Confirm New Password'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please confirm your new password.';
                }
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _changePassword,
          child: const Text('Change Password'),
        ),
      ],
    );
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      final currentPassword =
          sha1.convert(utf8.encode(_currentPasswordController.text)).toString();
      final newPassword = _newPasswordController.text;

      try {
        final response = await http.post(
          Uri.parse('${MyConfig().SERVER}/barterit/php/change_password.php'),
          body: {
            'user_id': widget.user.id,
            'currentpassword': currentPassword,
            'newpassword': newPassword,
          },
        );

        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          Navigator.pop(context);
          Fluttertoast.showToast(
            msg: 'Password changed successfully.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: 'Failed to change password. ${jsonData['message']}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Error: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }
}
