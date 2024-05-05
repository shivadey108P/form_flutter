import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:form_flutter/home_screen.dart';
import 'package:form_flutter/login_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'buttons_custom.dart';
import 'constants.dart';

class SignupScreen extends StatefulWidget {
  static const String id = 'signup_screen';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late String emailAddress;
  late String password;
  late String name;
  late String contact;
  bool showText = false;
  bool progressBar = false;
  final List<String> genderOptions = ['Male', 'Female'];
  String? selectedGender;

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
                      "Sign up",
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
                        validator: MultiValidator([
                          RequiredValidator(errorText: '* Required'),
                          PatternValidator(r'^[a-zA-Z\s]+$',
                              errorText:
                                  'Full name must contain only letters and spaces. ')
                        ]).call,
                        onChanged: (personName) {
                          name = personName;
                        },
                        keyboardType: TextInputType.text,
                        decoration: textFieldDecor(
                          "Full Name",
                          const Icon(
                            Icons.person,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        validator: MultiValidator([
                          LengthRangeValidator(
                              min: 10,
                              max: 10,
                              errorText: 'Number must be of 10 digits'),
                          PatternValidator(
                            r'^[0-9]+$',
                            errorText: 'Number must contain only digits',
                          ),
                        ]).call,
                        onChanged: (contactUser) {
                          contact = contactUser;
                        },
                        keyboardType: TextInputType.number,
                        decoration: textFieldDecor(
                          "Contact",
                          const Icon(
                            Icons.phone,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        validator: MultiValidator([
                          RequiredValidator(errorText: "* Required"),
                          EmailValidator(errorText: "Enter valid email id"),
                        ]).call,
                        onChanged: (email) {
                          emailAddress = email;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: textFieldDecor(
                          "Email",
                          const Icon(Icons.email, color: Colors.teal),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButtonFormField<String>(
                        hint: const Text('Gender'),
                        dropdownColor: Colors.white,
                        style: TextStyle(
                          color: Colors.teal[900],
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35),
                          ),
                          labelStyle: TextStyle(
                            color: Colors.teal[900],
                          ),
                          hintStyle: TextStyle(
                            color: Colors.teal[900],
                            fontSize: 30,
                          ),
                        ),
                        items: genderOptions.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: (value) {
                          selectedGender = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select your gender";
                          }
                          return null;
                        },
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
                      height: 20,
                    ),
                    RoundedRectButton(
                      textInput: 'Sign up',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            progressBar = true;
                          });

                          auth
                              .createUserWithEmailAndPassword(
                                  email: emailAddress!, password: password!)
                              .then((userCredential) {
                            final user = userCredential.user;
                            if (user != null) {
                              final userId = user.uid;

                              dbCloud.collection("User").doc(userId).set({
                                'Name': name,
                                'Contact': contact,
                                'Email': emailAddress,
                                'Gender': selectedGender,
                              }).then((_) {
                                Navigator.pushNamed(context, HomeScreen.id);
                              }).catchError((error) {
                                Fluttertoast.showToast(
                                    msg:
                                        "Error writing to Firestore: ${error.toString()}");
                              });
                            }
                          }).catchError((error) {
                            if (error is FirebaseAuthException) {
                              Fluttertoast.showToast(
                                  msg: "FirebaseAuth error: ${error.message}");
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Error: ${error.toString()}");
                            }
                          }).whenComplete(() {
                            setState(() {
                              progressBar = false;
                            });
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg:
                                  "Please correct the errors before proceeding.");
                        }
                      },
                      colour: kWhiteCanvas,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                          child: const Text(
                            "Login here",
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
