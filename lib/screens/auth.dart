import 'dart:io';
import 'package:chat_app/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/cloudinary_service.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';
  var _enteredUsername = '';
  var _isAuthenticating = false;
  File? _selectedImage;

  void _submit() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || (!_isLogin && _selectedImage == null)) return;

    _form.currentState!.save();

    try {
      setState(() => _isAuthenticating = true);

      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );

        final imageUrl =
        await CloudinaryService.uploadImage(_selectedImage!);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(_firebase.currentUser!.uid)
            .set({
          'username': _enteredUsername,
          'email': _enteredEmail,
          'image_url': imageUrl,
          'isOnline': true,
          'lastSeen': FieldValue.serverTimestamp(),
        });
      }
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
      setState(() => _isAuthenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB5838D),
              Color(0xFFF4ACB7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7F2),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 18,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _form,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.chat_rounded,
                      size: 70,
                      color: Color(0xFF5A4A5C), // darker plum
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _isLogin ? 'Welcome Back' : 'Create Account',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF3D3D3D),
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (!_isLogin)
                      UserImagePicker(
                        onPickImage: (pickedImage) {
                          _selectedImage = pickedImage;
                        },
                      ),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                        Icon(Icons.email, color: Color(0xFF5A4A5C)),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty ||
                            !value.contains('@')) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) => _enteredEmail = value!,
                    ),

                    if (!_isLogin)
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon:
                          Icon(Icons.person, color: Color(0xFF5A4A5C)),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().length < 4) {
                            return 'Minimum 4 characters';
                          }
                          return null;
                        },
                        onSaved: (value) => _enteredUsername = value!,
                      ),

                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon:
                        Icon(Icons.lock, color: Color(0xFF5A4A5C)),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Minimum 6 characters';
                        }
                        return null;
                      },
                      onSaved: (value) => _enteredPassword = value!,
                    ),

                    const SizedBox(height: 25),

                    if (_isAuthenticating)
                      const CircularProgressIndicator(
                        color: Color(0xFF5A4A5C),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color(0xFF5A4A5C), // DARKER
                            foregroundColor: Colors.white, // TEXT VISIBLE
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            _isLogin ? 'Login' : 'Signup',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    TextButton(
                      onPressed: () {
                        setState(() => _isLogin = !_isLogin);
                      },
                      child: Text(
                        _isLogin
                            ? 'Create new account'
                            : 'Already have an account?',
                        style: const TextStyle(
                          color: Color(0xFF5A4A5C),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}