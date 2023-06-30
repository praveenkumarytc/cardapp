// ignore_for_file: use_build_context_synchronously

import 'package:cardapp/dashboard/home.dart';
import 'package:cardapp/model/user_model.dart';
import 'package:cardapp/utils/sized_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Hive/hive_methods.dart';
import 'auth/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = ColorTween(
      begin: Colors.transparent,
      end: Colors.white,
    ).animate(_animationController);
    _animationController.repeat(reverse: true);
    routes();
  }

  routes() {
    Future.delayed(const Duration(seconds: 2), () async {
      UserModel? userModel;

      userModel = await HiveMethods.getUser();
      if (userModel == null) {
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => const LoginPage(),
            ));
      } else {
        Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (context) => const MyHomePage(),
            ));
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Color.fromRGBO(69, 35, 78, 1),
              Color.fromRGBO(36, 15, 43, 1),
            ],
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            40.heightBox,
            const Text(
              "Card-App",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 58,
                color: Colors.white,
              ),
            ),
            20.heightBox,
            Column(
              children: [
                CircularProgressIndicator(
                  valueColor: _animation,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
