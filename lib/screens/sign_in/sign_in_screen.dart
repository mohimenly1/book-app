import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app/screens/login_success/login_success_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../sign_up/sign_up_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static String routeName = "/sign_in";
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? phoneNumber;
  String? phoneErrorText;
  String? passwordText;
  String? passwordTextErrorText;
  bool _isLoading = false;

  String _formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      return '+218' + phoneNumber.substring(1);
    }
    return '+218' + phoneNumber;
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Set loading to true when login starts
    });

    try {
      final String apiUrl = dotenv.env['API_URL']!;
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        body: {
          'phone': phoneNumber,
          'password': passwordText,
        },
      );

      // Log the status code, headers, and body
      print('Status code: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body to get the access token and user ID
        final responseBody = jsonDecode(response.body);
        String accessToken = responseBody['access_token'];
        int userId = responseBody['user_id'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setInt('user_id', userId);

        // Navigate to the success screen directly
        Navigator.pushReplacementNamed(context, LoginSuccessScreen.routeName);
      } else {
        // Parse the response body if it's JSON
        String errorMessage = 'The provided credentials are incorrect.';
        try {
          final responseBody = jsonDecode(response.body);
          if (responseBody is Map<String, dynamic> &&
              responseBody.containsKey('error')) {
            errorMessage = responseBody['error'];
          }
        } catch (e) {
          print('Failed to parse response body: $e');
        }

        // Show error message
        setState(() {
          phoneErrorText = errorMessage;
          passwordTextErrorText = errorMessage;
        });
        _showErrorDialog(errorMessage);
      }
    } finally {
      setState(() {
        _isLoading = false; // Set loading to false when login is finished
      });
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorMessage),
        );
      },
    );

    // Close the dialog after 5 seconds
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Show loading indicator when _isLoading is true
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 350,
                      child: Image.asset(
                        'assets/images/FootballGoal.gif',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 60.0,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            '!سجل دخولك',
                            textStyle: const TextStyle(
                              color: Color(0xFF1C1678),
                              fontSize: 30,
                              fontStyle: FontStyle.italic,
                              fontFamily: 'ArslanFont',
                              fontWeight: FontWeight.w800,
                            ),
                            speed: const Duration(
                              milliseconds: 450,
                            ),
                          ),
                        ],
                        onTap: () {
                          debugPrint("Welcome back!");
                        },
                        isRepeatingAnimation: true,
                        totalRepeatCount: 2,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          bottom: 0.0), // Adjust the bottom padding as needed
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 32,
                      ),
                      child: Form(
                        key: _formKey, // Define a GlobalKey<FormState>
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom:
                                      20.0), // Adjust the bottom padding as needed
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                        fontFamily: 'TajawalRegular'),
                                    hintText: '',
                                    labelText: 'رقم الهاتف',
                                    errorText:
                                        phoneErrorText, // Display error text if validation fails
                                    errorStyle: const TextStyle(
                                        fontFamily: 'TajawalRegular'),
                                    suffixIcon: const Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                              8.0), // Add some padding to separate the icon from the input
                                      child: Icon(Icons.phone),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal:
                                            16.0), // Add horizontal padding
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      phoneNumber = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'يرجى إدخال رقم الهاتف';
                                    }
                                    if (value.length != 10) {
                                      return 'يجب أن يكون رقم الهاتف 10 أرقام';
                                    }
                                    if (!RegExp(r'^(092|091|094|093|095)')
                                        .hasMatch(value)) {
                                      return 'يجب أن يبدأ رقم الهاتف بـ "092" أو "091" أو "094"';
                                    }
                                    return null; // Return null if validation passes
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelStyle: const TextStyle(
                                        fontFamily: 'TajawalRegular'),
                                    hintText: '',
                                    labelText: 'كلمة السر',
                                    errorText: passwordTextErrorText,
                                    errorStyle: const TextStyle(
                                        fontFamily: 'TajawalRegular'),
                                    suffixIcon: const Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Icon(Icons.lock),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      passwordText = value;
                                    });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'يرجى إدخال كلمة المرور';
                                    }
                                    if (value.length < 8) {
                                      return 'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                'نسيـت كلمـة المـرور ؟',
                                style: TextStyle(
                                  fontFamily: 'TajawalRegular',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _login();
                                }
                              },
                              icon: const Icon(Icons.login),
                              label: Container(
                                alignment: Alignment.center,
                                width: 155,
                                height: 45,
                                padding:
                                    const EdgeInsetsDirectional.only(top: 2.5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1C1678),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(
                                    fontFamily: 'TajawalRegular',
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: (() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpScreen()));
                                  }),
                                  child: const Text(
                                    'سجـل هنا',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'TajawalRegular'),
                                  ),
                                ),
                                const Text(
                                  'ماعندكـش حسـاب ؟',
                                  style: TextStyle(
                                    fontFamily: 'TajawalRegular',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
