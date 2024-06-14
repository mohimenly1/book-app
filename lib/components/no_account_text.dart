import 'package:flutter/material.dart';

import '../constants.dart';
import '../screens/sign_up/sign_up_screen.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: const Text(
            "سجـل الأن ",
            style: TextStyle(
                fontSize: 16, color: kPrimaryColor, fontFamily: 'HacenSamra'),
          ),
        ),
        const Text(
          "ليس لديـك حســاب ؟",
          style: TextStyle(fontSize: 16, fontFamily: 'HacenSamra'),
        )
      ],
    );
  }
}
