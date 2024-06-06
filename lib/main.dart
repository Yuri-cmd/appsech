import 'package:flutter/material.dart';
import 'package:appsech/login.dart';

void main() {
  runApp(const Directionality(
    textDirection: TextDirection.ltr, // or TextDirection.rtl if needed
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Seche App',
      // theme: AppTheme.lightTheme,
      home: LoginView(),
      // routes: {},
    );
  }
}
