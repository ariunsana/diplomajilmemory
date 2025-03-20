import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegistration() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement actual registration logic
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Бүртгүүлэх оролдлого хийж байна...')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Бүртгүүлэх',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1a1a1a)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Image
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('images/profile.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Username Field
                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Хэрэглэгчийн нэр',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.person, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue[400]!),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Хэрэглэгчийн нэрээ оруулна уу';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'И-мэйл',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.email, color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue[400]!),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'И-мэйл хаягаа оруулна уу';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Зөв и-мэйл хаяг оруулна уу';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    
                    // Password Field
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(color: Colors.white),
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Нууц үг',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue[400]!),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Нууц үгээ оруулна уу';
                        }
                        if (value.length < 6) {
                          return 'Нууц үг хамгийн багадаа 6 тэмдэгт байх ёстой';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      style: const TextStyle(color: Colors.white),
                      obscureText: !_isConfirmPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Нууц үгээ баталгаажуулах',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.blue[400]!),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.red),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Нууц үгээ дахин оруулна уу';
                        }
                        if (value != _passwordController.text) {
                          return 'Нууц үг таарахгүй байна';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Register Button
                    ElevatedButton(
                      onPressed: _handleRegistration,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Бүртгүүлэх',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Бүртгэлтэй юу? ',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Нэвтрэх',
                            style: TextStyle(
                              color: Colors.blue[400],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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