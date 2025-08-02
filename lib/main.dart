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
        useMaterial3: true,
      ),
      // SEO-friendly routing
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const PromotionalWebsiteScreen(),
          title: 'Discover Philippines - Your Ultimate Philippine Travel Guide',
        ),
        GetPage(
          name: '/home',
          page: () => const PromotionalWebsiteScreen(),
          title: 'Home - Discover Philippines',
        ),
        GetPage(
          name: '/about',
          page: () => const PromotionalWebsiteScreen(),
          title: 'About - Discover Philippines Travel Guide',
        ),
        GetPage(
          name: '/destinations',
          page: () => const PromotionalWebsiteScreen(),
          title: 'Top Philippine Destinations - Discover Philippines',
        ),
      ],
      unknownRoute: GetPage(
        name: '/404',
        page: () => const PromotionalWebsiteScreen(),
        title: '404 - Page Not Found | Discover Philippines',
      ),
      enableLog: false, // Disable logs in production
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
