// ignore_for_file: use_build_context_synchronously

import 'package:cardapp/Hive/hive_methods.dart';
import 'package:cardapp/dashboard/home.dart';
import 'package:cardapp/main.dart';
import 'package:cardapp/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.isEditPage = false}) : super(key: key);
  final bool? isEditPage;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  late FocusNode _nameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _phoneFocusNode;

  @override
  void initState() {
    super.initState();
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.isEditPage! ? "Edit Profile" : 'Login',
        ),
        backgroundColor: primaryColor2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32.0),
            CustomTextField(
              controller: _nameController,
              focusNode: _nameFocusNode,
              labelText: 'Name',
              textCapitalization: TextCapitalization.words,
              nextFocusNode: _emailFocusNode,
              textInputType: TextInputType.name,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _emailController,
              focusNode: _emailFocusNode,
              textCapitalization: TextCapitalization.none,
              labelText: 'Email',
              textInputType: TextInputType.emailAddress,
              nextFocusNode: _phoneFocusNode,
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _phoneController,
              focusNode: _phoneFocusNode,
              textInputType: const TextInputType.numberWithOptions(decimal: false, signed: false),
              labelText: 'Phone',
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: addUserData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addUserData() async {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String phone = _phoneController.text.trim();

    if (name.isNotEmpty && email.isNotEmpty && phone.length == 10 && int.tryParse(phone) != null) {
      final userModel = UserModel(name: name, email: email, phone: phone);
      await HiveMethods.addUser(userModel);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MyHomePage(),
          ));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Validation Error'),
          content: const Text('Please fill all fields correctly.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String labelText;
  final FocusNode? nextFocusNode;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextInputType textInputType;
  const CustomTextField({
    required this.controller,
    required this.focusNode,
    required this.labelText,
    required this.textInputType,
    required this.textCapitalization,
    this.nextFocusNode,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      textCapitalization: textCapitalization,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: primaryColor,
        floatingLabelStyle: const TextStyle(color: Colors.white),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      onFieldSubmitted: (_) {
        if (nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
    );
  }
}
