// ignore_for_file: library_private_types_in_public_api

import 'package:cardapp/splash.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox(hiveBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      theme: ThemeData(
        fontFamily: "YsabeauOffice",
        primaryColor: primaryColor,
      ),
      darkTheme: ThemeData(
        fontFamily: "YsabeauOffice",
        primaryColor: primaryColor,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
    );
  }
}

const primaryColor = Color.fromRGBO(44, 15, 54, 1);
const primaryColor2 = Color.fromRGBO(36, 15, 43, 1);
const hiveBox = "userInfoBox";
