import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/tabs/home_tab.dart';
import 'package:movie_app/widgets/reusable_components/customFormField.dart';
import '../firebase/firebaseAuthCodes.dart';
import '../screens/home_screen.dart';
import '../signup/register_screen.dart';
import '../widgets/DialogUtils.dart';
import '../widgets/reusable_components/customElevatedButton.dart';
import '../widgets/reusable_components/validation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = 'login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text('Login', style: TextStyle(color: Colors.red)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Icon(Icons.lock_outline, size: 80, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  const SizedBox(height: 30),
                  Customformfield(
                    label: "Email Address",
                    keyboard: TextInputType.emailAddress,
                    controller: emailController,
                    validator: Validation.emailValidator,
                  ),
                  SizedBox(height: height * 0.02),
                  Customformfield(
                    label: "Password",
                    keyboard: TextInputType.visiblePassword,
                    controller: passwordController,
                    isPassword: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: height * 0.05),
                  CustomElevatedButton(
                    onPress: login,
                    title: 'Login',
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(RegisterScreen.routeName);
                    },
                    child: const Text(
                      "Don't have an account? Register",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        DialogUtils.ShowLoading(context);
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(HomeTab.routeName);
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop();

        String message;
        if (e.code == FireBaseAuthCodes.userNotFound) {
          message = "No user found for that email.";
        } else if (e.code == FireBaseAuthCodes.wrongPassword) {
          message = "Wrong password.";
        } else if (e.code == FireBaseAuthCodes.invalidEmail) {
          message = "Invalid email format.";
        } else if (e.code == FireBaseAuthCodes.invalidCredential) {
          message = "Login failed. Please check your email and password.";
        } else {
          message = e.message ?? "Login failed. Please try again.";
        }

        Future.microtask(() {
          DialogUtils.ShowMessage(
            context,
            message: message,
            OKButton: "OK",
            onOKPressed: () => Navigator.of(context).pop(),
          );
        });
      }
      catch (e) {
        Navigator.of(context).pop();
        DialogUtils.ShowMessage(
          context,
          message: "Unexpected error occurred.",
          OKButton: "OK",
          onOKPressed: () => Navigator.of(context).pop(),
        );
      }
    }
  }
}
