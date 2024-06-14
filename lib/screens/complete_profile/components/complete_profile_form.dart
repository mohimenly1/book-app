import 'package:flutter/material.dart';

import '../../../components/custom_surfix_icon.dart';
import '../../../components/form_error.dart';
import '../../../constants.dart';
import 'package:app/home_screen.dart';

class CompleteProfileForm extends StatefulWidget {
  const CompleteProfileForm({super.key});

  @override
  _CompleteProfileFormState createState() => _CompleteProfileFormState();
}

class _CompleteProfileFormState extends State<CompleteProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String?> errors = [];
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? address;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              onSaved: (newValue) => firstName = newValue,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: kNamelNullError);
                }
                return;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  addError(error: kNamelNullError);
                  return "";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelStyle: TextStyle(fontFamily: 'TajawalRegular'),
                errorStyle: TextStyle(fontFamily: 'TajawalRegular'),
                hintStyle: TextStyle(fontFamily: 'TajawalRegular'),
                labelText: 'الاسم الأول',
                hintText: 'أدخل الاسم الأول',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: CustomSurffixIcon(svgIcon: 'assets/icons/User.svg'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              onSaved: (newValue) => lastName = newValue,
              decoration: const InputDecoration(
                labelStyle: TextStyle(fontFamily: 'TajawalRegular'),
                errorStyle: TextStyle(fontFamily: 'TajawalRegular'),
                hintStyle: TextStyle(fontFamily: 'TajawalRegular'),
                labelText: 'الاسم الأخير',
                hintText: 'أدخل الاسم الأخير',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: CustomSurffixIcon(svgIcon: 'assets/icons/User.svg'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextFormField(
              onSaved: (newValue) => address = newValue,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: kAddressNullError);
                }
                return;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  addError(error: kAddressNullError);
                  return "";
                }
                return null;
              },
              decoration: const InputDecoration(
                labelStyle: TextStyle(fontFamily: 'TajawalRegular'),
                errorStyle: TextStyle(fontFamily: 'TajawalRegular'),
                hintStyle: TextStyle(fontFamily: 'TajawalRegular'),
                labelText: 'العنوان',
                hintText: 'أدخل العنوان',
                floatingLabelBehavior: FloatingLabelBehavior.always,
                suffixIcon: CustomSurffixIcon(
                    svgIcon: 'assets/icons/Location point.svg'),
              ),
            ),
          ),
          FormError(errors: errors),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage()));
              }
            },
            child: const Text(
              'متابعة',
              style: TextStyle(fontFamily: 'ArslanFont', fontSize: 30),
            ),
          ),
        ],
      ),
    );
  }
}
