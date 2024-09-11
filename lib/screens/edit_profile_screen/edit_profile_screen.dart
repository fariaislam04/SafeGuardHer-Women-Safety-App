import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import '../../providers.dart';
import '../../utils/constants/colors.dart';
import '../../widgets/templates/settings_template.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  bool _isUploading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String _passwordStrengthMessage = '';

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userStreamProvider);

    return userAsyncValue.when(
      data: (user)
      {
        _nameController.text = user?.name ?? '';
        _emailController.text = user?.email ?? '';

        return SettingsTemplate(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () async
                      {
                        final pickedFile = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile != null) {
                          setState(() {
                            _imageFile = pickedFile;
                          });
                        }
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            backgroundImage: _imageFile != null
                                ? FileImage(File(_imageFile!.path))
                                : user!.profilePic.isNotEmpty
                                ? NetworkImage(user.profilePic)
                                : const AssetImage('assets/placeholders/default_profile_pic.png')
                            as ImageProvider,
                            radius: 50,
                          ),
                          if (_imageFile == null && user!.profilePic.isEmpty)
                            const SizedBox(
                              width: 100,
                              height: 100,
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 24.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _oldPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Old Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _newPasswordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                      helperText: _passwordStrengthMessage,
                    ),
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _passwordStrengthMessage = _checkPasswordStrength(value);
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: _isUploading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: () => _saveChanges("01719958727"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Center(child: appHelperFunctions.appLoader(context)),
      error: (e, stack) => Center(child: Text('Error: $e')),
    );
  }

  String _checkPasswordStrength(String password) //-- move it to the validators
  {
    if (password.length < 6) return 'Password too short';
    if (!RegExp(r'[A-Z]').hasMatch(password)) return 'Add an uppercase letter';
    if (!RegExp(r'[a-z]').hasMatch(password)) return 'Add a lowercase letter';
    if (!RegExp(r'[0-9]').hasMatch(password)) return 'Add a number';
    if (!RegExp(r'[!@#\$&*~]').hasMatch(password)) return 'Add a special character';
    return 'Strong password';
  }

  Future<void> _saveChanges(String phoneNumber) async
  {
    setState(()
    {
      _isUploading = true;
    });

    try
    {
      String? imageUrl;

      if (_imageFile != null)
      {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pics/$phoneNumber/${_imageFile!.name}');
        await storageRef.putFile(File(_imageFile!.path));
        imageUrl = await storageRef.getDownloadURL();
      }

      final userRef = FirebaseFirestore.instance.collection('users').doc(phoneNumber);
      await userRef.update({
        'name': _nameController.text,
        'email': _emailController.text,
        'pwd': _newPasswordController.text,
        if (imageUrl != null) 'profilePicUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
    catch (e)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile.'),
          backgroundColor: Colors.red,
        ),
      );
    }
    finally
    {
      setState(()
      {
        _isUploading = false;
      });
    }
  }
}