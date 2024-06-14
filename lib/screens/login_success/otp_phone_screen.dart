import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_success/login_success_screen.dart';

class OTPPhoneScreen extends StatefulWidget {
  final String verificationId;

  const OTPPhoneScreen({super.key, required this.verificationId});

  static String routeName = "/otp_phone";

  @override
  State<OTPPhoneScreen> createState() => _OTPPhoneScreenState();
}

class _OTPPhoneScreenState extends State<OTPPhoneScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? otpCode;
  String? otpErrorText;

  Future<void> _verifyOTP() async {
    if (otpCode == null || otpCode!.isEmpty) {
      setState(() {
        otpErrorText = 'Please enter the OTP code.';
      });
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpCode!,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      // Set the OTP verification flag
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_otp_verified', true);

      Navigator.pushReplacementNamed(context, LoginSuccessScreen.routeName);
    } catch (e) {
      setState(() {
        otpErrorText = 'Invalid OTP. Please try again.';
      });
      print('Error during OTP verification: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
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
                      'أدخل رمز التحقق',
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
                    debugPrint("Enter your OTP!");
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
                              labelStyle:
                                  const TextStyle(fontFamily: 'TajawalRegular'),
                              hintText: 'رمز التحقق',
                              labelText: 'OTP',
                              errorText:
                                  otpErrorText, // Display error text if validation fails
                              errorStyle:
                                  const TextStyle(fontFamily: 'TajawalRegular'),
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(
                                    left:
                                        8.0), // Add some padding to separate the icon from the input
                                child: Icon(Icons.lock),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0), // Add horizontal padding
                            ),
                            onChanged: (value) {
                              setState(() {
                                otpCode = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'يرجى إدخال رمز التحقق';
                              }
                              if (value.length != 6) {
                                return 'يجب أن يكون رمز التحقق 6 أرقام';
                              }
                              return null; // Return null if validation passes
                            },
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _verifyOTP();
                          }
                        },
                        icon: const Icon(Icons.verified),
                        label: Container(
                          alignment: Alignment.center,
                          width: 155,
                          height: 45,
                          padding: const EdgeInsetsDirectional.only(top: 2.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1678),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text(
                            'تحقق',
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
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'إعادة إرسال الرمز',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'TajawalRegular'),
                            ),
                          ),
                          const Text(
                            'لم تستلم رمز التحقق؟',
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
