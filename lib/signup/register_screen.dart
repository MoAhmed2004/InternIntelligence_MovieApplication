import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/firebase/model/user.dart' as MyUser;
import 'package:movie_app/firebase/fireStore_handler.dart';
import 'package:movie_app/firebase/firebaseAuthCodes.dart';
import 'package:movie_app/tabs/home_tab.dart';
import 'package:movie_app/widgets/DialogUtils.dart';
import 'package:movie_app/widgets/reusable_components/customElevatedButton.dart';
import 'package:movie_app/widgets/reusable_components/customFormField.dart';
import 'package:movie_app/widgets/reusable_components/validation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  static const String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController passwordConfirmationController;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    ageController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    passwordConfirmationController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
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
        title: const Text('Create Account', style: TextStyle(color: Colors.red)),
        iconTheme: const IconThemeData(color: Colors.red),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Icon(Icons.person_add, size: 80, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                const SizedBox(height: 30),
                Customformfield(
                  label: "Full Name",
                  keyboard: TextInputType.name,
                  controller: nameController,
                  validator: (value) =>
                      Validation.nameValidator(value, "Please enter your name"),
                ),
                SizedBox(height: height * 0.02),
                Customformfield(
                  label: "Email Address",
                  keyboard: TextInputType.emailAddress,
                  controller: emailController,
                  validator: Validation.emailValidator,
                ),
                SizedBox(height: height * 0.02),
                Customformfield(
                  label: "Age",
                  keyboard: TextInputType.number,
                  controller: ageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
                Customformfield(
                  label: "Password",
                  keyboard: TextInputType.visiblePassword,
                  controller: passwordController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
                Customformfield(
                  label: "Password Confirmation",
                  keyboard: TextInputType.visiblePassword,
                  controller: passwordConfirmationController,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.06),
                CustomElevatedButton(
                  onPress: createAccount,
                  title: 'Create Account',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void createAccount() async {
    if (!formKey.currentState!.validate()) return;

    DialogUtils.ShowLoading(context);

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await userCredential.user?.updateDisplayName(nameController.text.trim());


      await FireStoreHandler.createUser(MyUser.User(
        id: userCredential.user!.uid,
        name: nameController.text.trim(),
        age: int.parse(ageController.text),
        email: emailController.text.trim(),
      ));

      if (!mounted) return;

      Navigator.of(context).pop();
      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeTab.routeName,
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (mounted) Navigator.of(context).pop();

      String message;
      if (e.code == FireBaseAuthCodes.emailAlreadyInUse) {
        message = "Email is already in use.";
      } else if (e.code == FireBaseAuthCodes.weakPassword) {
        message = "Password is too weak.";
      } else if (e.code == FireBaseAuthCodes.invalidEmail) {
        message = "Invalid email format.";
      } else {
        message = e.message ?? "Registration failed.";
      }

      Future.microtask(() {
        DialogUtils.ShowMessage(
          context,
          message: message,
          OKButton: "OK",
          onOKPressed: () => Navigator.of(context).pop(),
        );
      });
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      Future.microtask(() {
        DialogUtils.ShowMessage(
          context,
          message: "Unexpected error occurred.",
          OKButton: "OK",
          onOKPressed: () => Navigator.of(context).pop(),
        );
      });
    }
  }

}
