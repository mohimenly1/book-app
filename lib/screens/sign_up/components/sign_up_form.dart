import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../login_success/login_success_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import '../OTPVerificationScreen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? phoneNumber;
  String? name;
  String? password;
  String? confirmPassword;
  String? errorText;
  bool _isLoading = false;
  late TwilioFlutter twilioFlutter;

  @override
  void initState() {
    super.initState();
    twilioFlutter = TwilioFlutter(
      accountSid: dotenv.env['TWILIO_ACCOUNT_SID']!,
      authToken: dotenv.env['TWILIO_AUTH_TOKEN']!,
      twilioNumber: dotenv.env['TWILIO_PHONE_NUMBER']!,
    );
  }

  String _formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      return '+218' + phoneNumber.substring(1);
    }
    return '+218' + phoneNumber;
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final String apiUrl = dotenv.env['API_URL']!;
        final response = await http.post(
          Uri.parse('$apiUrl/register'),
          body: {
            'name': name,
            'phone': phoneNumber,
            'password': password,
            'password_confirmation': confirmPassword,
          },
        );

        if (response.statusCode == 201) {
          final responseBody = jsonDecode(response.body);
          final accessToken = responseBody['access_token'];

          if (accessToken != null && accessToken is String) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('access_token', accessToken);

            // Send OTP
            await _sendOTP();
          } else {
            setState(() {
              errorText =
                  'Registration failed: access token is missing or invalid.';
            });
          }
        } else {
          setState(() {
            errorText = 'Registration failed: ${response.body}';
          });
        }
      } catch (e) {
        setState(() {
          errorText = 'An error occurred: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendOTP() async {
    String formattedPhoneNumber = _formatPhoneNumber(phoneNumber!);

    try {
      await twilioFlutter.sendSMS(
        toNumber: formattedPhoneNumber,
        messageBody:
            'Your verification code is 123456', // Here you should generate and send a real OTP
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OTPVerificationScreen(phoneNumber: formattedPhoneNumber),
        ),
      );
    } catch (e) {
      setState(() {
        errorText = 'An error occurred while sending SMS: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Phone Number'),
            onChanged: (value) {
              setState(() {
                phoneNumber = value;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length != 10) {
                return 'Phone number must be 10 digits';
              }
              if (!RegExp(r'^(092|091|094|093|095)').hasMatch(value)) {
                return 'Phone number must start with "092", "091", "094", "093", or "095"';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Confirm Password'),
            onChanged: (value) {
              setState(() {
                confirmPassword = value;
              });
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != password) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          if (errorText != null)
            Text(
              errorText!,
              style: const TextStyle(color: Colors.red),
            ),
          const SizedBox(height: 16),
          _isLoading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _register,
                  child: const Text('Sign Up'),
                ),
        ],
      ),
    );
  }
}
