import 'package:flutter/material.dart';
import 'package:app/hotel_booking/playground_home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";

  const LoginSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SvgPicture.asset(
              "assets/images/success.svg",
              height: MediaQuery.of(context).size.height * 0.4, // 40%
            ),
            const SizedBox(height: 16),
            const Text(
              "ابدأ نسق مباراتك",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'TajawalRegular',
                color: Colors.black,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PlaygroundHomeScreen()),
                  );
                },
                child: const Text(
                  "الرئيسية",
                  style: TextStyle(fontFamily: 'ArslanFont', fontSize: 27),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
