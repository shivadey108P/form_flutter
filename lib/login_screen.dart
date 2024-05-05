import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:form_flutter/home_screen.dart';
import 'package:form_flutter/signUpScreen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'buttons_custom.dart';
import 'constants.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String emailAddress;
  late String password;
  bool progressBar = false;

  bool showText = false;

  final auth = FirebaseAuth.instance;
  final dbCloud = FirebaseFirestore.instance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: progressBar,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Welcome Back!",
                      style: kOnBoardingHeading,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Welcome! Please enter your name, email, contact number, and password to create your account.",
                      style: kWelcomeMessage,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an email address.';
                          } else if (!RegExp(r'^\S+@\S+\.\S+$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address.';
                          }
                          return null;
                        },
                        onChanged: (email) {
                          emailAddress = email;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: textFieldDecor(
                          "Email",
                          const Icon(
                            Icons.email,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(errorText: '* Required'),
                          MinLengthValidator(6,
                              errorText:
                                  'Your password must contain atleast 6 characters.')
                        ]).call,
                        obscureText: !showText,
                        onChanged: (pass) {
                          password = pass;
                        },
                        decoration: textFieldDecor(
                          "Your Password",
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showText = !showText;
                              });
                            },
                            child: showText
                                ? const Icon(
                                    Icons.visibility,
                                    color: Colors.teal,
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: Colors.teal,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    RoundedRectButton(
                      textInput: 'Sign up',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            progressBar = true;
                          });

                          auth
                              .signInWithEmailAndPassword(
                                  email: emailAddress, password: password)
                              .then((user) {
                            Navigator.pushNamed(context, HomeScreen.id);
                          }).catchError((e) {
                            if (e is FirebaseAuthException) {
                              Fluttertoast.showToast(
                                  msg: "Error: ${e.message}");
                            }
                          }).whenComplete(() {
                            setState(() {
                              progressBar = false;
                            });
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please enter correct values");
                        }
                      },
                      colour: kWhiteCanvas,
                    ),
                    const SizedBox(
                      height: 300,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SignupScreen.id);
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
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
