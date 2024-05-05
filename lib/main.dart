import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_flutter/home_screen.dart';
import 'package:form_flutter/login_screen.dart';
import 'package:form_flutter/signUpScreen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FormUser());
}

class FormUser extends StatelessWidget {
  const FormUser({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.teal,
        hintColor: Colors.teal[700],
        iconTheme: const IconThemeData(
          color: Colors.teal,
        ),
        primaryTextTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Colors.teal.shade900,
          ),
          bodyLarge: TextStyle(
            color: Colors.teal.shade900,
          ),
          bodySmall: TextStyle(
            color: Colors.teal.shade900,
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(
            color: Colors.teal.shade900,
          ),
          bodyLarge: TextStyle(
            color: Colors.teal.shade900,
          ),
          bodySmall: TextStyle(
            color: Colors.teal.shade900,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const AuthCheck(),
        SignupScreen.id: (context) => const SignupScreen(),
        HomeScreen.id: (context) => const HomeScreen(),
        LoginScreen.id: (context) => const LoginScreen(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser; // Get the current user

    if (user != null) {
      // If the user is logged in, navigate to the main screen
      Future.microtask(
          () => Navigator.pushReplacementNamed(context, HomeScreen.id));
    } else {
      // If not logged in, navigate to the login screen
      Future.microtask(
          () => Navigator.pushReplacementNamed(context, HomeScreen.id));
    }

    return const Scaffold(
      body: Center(
        child: SpinKitChasingDots(
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }
}
