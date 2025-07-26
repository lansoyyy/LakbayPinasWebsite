import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakbay_pinas/screens/promotional_website_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Discover Philippines - Philippine Travel Guide',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Regular',
      ),
      home: PromotionalWebsiteScreen(),
    );
  }
}
