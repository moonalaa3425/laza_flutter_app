import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laza/components/colors.dart';
import 'package:laza/components/custom_text_field.dart';
import 'package:laza/extensions/context_extension.dart';
import 'components/bottom_nav_button.dart';
import 'components/custom_appbar.dart';
import 'dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final usernameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  bool rememberMe = false;

  @override
  void dispose() {
    usernameCtrl.dispose();
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.theme.appBarTheme.systemOverlayStyle!,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: const CustomAppBar(),
          bottomNavigationBar: BottomNavButton(
            label: 'Sign Up',
            onTap: () async {
              if (!formKey.currentState!.validate()) return;

              try {
                UserCredential userCredential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: emailCtrl.text.trim(),
                  password: passwordCtrl.text.trim(),
                );

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(userCredential.user!.uid)
                    .set({
                  'username': usernameCtrl.text.trim(),
                  'email': emailCtrl.text.trim(),
                  'createdAt': FieldValue.serverTimestamp(),
                });

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                    (Route<dynamic> route) => false);
              } on FirebaseAuthException catch (e) {
                String message = 'An error occurred';
                if (e.code == 'email-already-in-use')
                  message = 'Email already in use';
                if (e.code == 'weak-password') message = 'Password is too weak';
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
              }
            },
          ),
          body: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  child: Center(
                    child: Text(
                      'Sign Up',
                      style: context.headlineMedium,
                    ),
                  ),
                ),
                Expanded(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextField(
                            controller: usernameCtrl,
                            labelText: 'Username',
                            validator: (val) {
                              if (val == null || val.isEmpty)
                                return 'Field is required';
                              return null;
                            },
                          ),
                          CustomTextField(
                            controller: emailCtrl,
                            labelText: 'Email Address',
                            validator: (val) {
                              if (val == null || val.isEmpty)
                                return 'Field is required';
                              return null;
                            },
                          ),
                          CustomTextField(
                            controller: passwordCtrl,
                            labelText: 'Password',
                            textInputAction: TextInputAction.done,
                            validator: (val) {
                              if (val == null || val.isEmpty)
                                return 'Field is required';
                              if (val.length < 8)
                                return 'Password should be 8 characters long';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          SwitchListTile.adaptive(
                              activeColor:
                                  Platform.isIOS ? ColorConstant.primary : null,
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Remember me'),
                              value: rememberMe,
                              onChanged: (val) =>
                                  setState(() => rememberMe = val))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
