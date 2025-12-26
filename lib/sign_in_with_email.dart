import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laza/components/custom_appbar.dart';
import 'package:laza/components/custom_text_field.dart';
import 'package:laza/extensions/context_extension.dart';
import 'package:laza/dashboard.dart';
import 'components/bottom_nav_button.dart';
import 'components/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInWithEmail extends StatefulWidget {
  const SignInWithEmail({super.key});

  @override
  State<SignInWithEmail> createState() => _SignInWithEmailState();
}

class _SignInWithEmailState extends State<SignInWithEmail> {
  bool rememberMe = false;
  final formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void dispose() {
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
          resizeToAvoidBottomInset: false,
          appBar: const CustomAppBar(),
          bottomNavigationBar: BottomNavButton(
            label: 'Login',
            onTap: () async {
              if (!formKey.currentState!.validate()) return;

              try {
                UserCredential userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: emailCtrl.text.trim(),
                  password: passwordCtrl.text.trim(),
                );

                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Dashboard()),
                    (Route<dynamic> route) => false);
              } on FirebaseAuthException catch (e) {
                String message = 'Login failed';
                if (e.code == 'user-not-found') message = 'User not found';
                if (e.code == 'wrong-password') message = 'Wrong password';
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
              }
            },
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                        validator: (val) {
                          if (val == null || val.isEmpty)
                            return 'Field is required';
                          if (val.length < 8)
                            return 'Password should be 8 characters long';
                          return null;
                        },
                        textInputAction: TextInputAction.done),
                    const SizedBox(height: 10),
                    SwitchListTile.adaptive(
                        activeColor:
                            Platform.isIOS ? ColorConstant.primary : null,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Remember me'),
                        value: rememberMe,
                        onChanged: (val) => setState(() => rememberMe = val))
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
