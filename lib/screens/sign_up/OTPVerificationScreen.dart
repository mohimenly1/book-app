import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_success/login_success_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? otpCode;
  String? errorText;
  bool _isLoading = false;

  Future<void> _verifyOTP() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Dummy verification for demonstration. Replace with your actual OTP verification logic.
      if (otpCode == '123456') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_otp_verified', true);

        Navigator.pushReplacementNamed(context, LoginSuccessScreen.routeName);
      } else {
        setState(() {
          errorText = 'Invalid OTP code';
        });
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'OTP Code'),
                onChanged: (value) {
                  setState(() {
                    otpCode = value;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the OTP code';
                  }
                  if (value.length != 6) {
                    return 'OTP code must be 6 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              if (errorText != null)
                Text(
                  errorText!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _verifyOTP,
                      child: const Text('Verify'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
