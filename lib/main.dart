import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:get/get.dart';
import 'package:lakbay_pinas/screens/promotional_website_screen.dart';
import 'package:lakbay_pinas/screens/best_time_screen.dart';
import 'package:lakbay_pinas/screens/visa_screen.dart';
import 'package:lakbay_pinas/screens/islands_screen.dart';
import 'package:lakbay_pinas/screens/festivals_screen.dart';
import 'package:lakbay_pinas/screens/food_screen.dart';
import 'package:lakbay_pinas/screens/itineraries_screen.dart';
import 'package:lakbay_pinas/screens/safety_budget_screen.dart';
import 'package:lakbay_pinas/utils/seo_manager.dart';

void main() {
  // Remove hash (#) from Flutter web URLs for better SEO
  setUrlStrategy(PathUrlStrategy());
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
      navigatorObservers: [SeoRouteObserver()],
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
        // SEO-focused topic cluster routes
        GetPage(
          name: '/best-time',
          page: () => const BestTimeScreen(),
          title: 'Best Time to Visit the Philippines — Weather by Season',
        ),
        GetPage(
          name: '/visa',
          page: () => const VisaScreen(),
          title: 'Philippines Visa Requirements — Tourist Visa & Extensions',
        ),
        GetPage(
          name: '/islands',
          page: () => const IslandsScreen(),
          title: 'Best Islands in the Philippines — Palawan, Boracay, Siargao',
        ),
        GetPage(
          name: '/festivals',
          page: () => const FestivalsScreen(),
          title: 'Philippine Festivals — Sinulog, Ati-Atihan, Panagbenga',
        ),
        GetPage(
          name: '/food',
          page: () => const FoodScreen(),
          title: 'Filipino Food Guide — Adobo, Sinigang, Lechon & More',
        ),
        GetPage(
          name: '/itineraries',
          page: () => const ItinerariesScreen(),
          title: 'Philippines Itineraries — 7/10/14-Day Sample Routes',
        ),
        GetPage(
          name: '/safety-budget',
          page: () => const SafetyBudgetScreen(),
          title: 'Safety & Budget Tips for Traveling the Philippines',
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

class SeoRouteObserver extends NavigatorObserver {
  void _apply(Route<dynamic> route) {
    final name = route.settings.name ?? '/';
    final meta = _routeMeta[name] ?? _routeMeta['/']!;
    SeoManager.updateForRoute(
      routePath: name,
      title: meta.title,
      description: meta.description,
      breadcrumbs: meta.breadcrumbs,
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _apply(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) _apply(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) _apply(previousRoute);
    super.didPop(route, previousRoute);
  }
}

class _Meta {
  final String title;
  final String description;
  final List<String> breadcrumbs;
  const _Meta(this.title, this.description, this.breadcrumbs);
}

const Map<String, _Meta> _routeMeta = {
  '/': _Meta(
    'Discover Philippines - Your Ultimate Philippine Travel Guide',
    'Plan your trip to the Philippines with top islands, itineraries, visa info, festivals, food, and practical tips for every budget.',
    ['Home'],
  ),
  '/home': _Meta(
    'Home - Discover Philippines',
    'Discover the best of the Philippines: beaches, islands, culture, food, and travel tips for first-time and repeat visitors.',
    ['Home'],
  ),
  '/best-time': _Meta(
    'Best Time to Visit the Philippines — Weather by Season',
    'Find the best months to visit the Philippines by region, with dry/rainy seasons, typhoon tips, and crowd/price insights.',
    ['Guides', 'Best Time'],
  ),
  '/visa': _Meta(
    'Philippines Visa Requirements — Tourist Visa & Extensions',
    'Learn who needs a visa for the Philippines, entry requirements, extensions, and on-arrival policies for tourists.',
    ['Guides', 'Visa'],
  ),
  '/islands': _Meta(
    'Best Islands in the Philippines — Palawan, Boracay, Siargao',
    'Explore the top Philippine islands with highlights, how to get there, best seasons, and budget tips.',
    ['Destinations', 'Islands'],
  ),
  '/festivals': _Meta(
    'Philippine Festivals — Sinulog, Ati-Atihan, Panagbenga',
    'Experience the Philippines’ most colorful festivals with dates, locations, and travel tips for visitors.',
    ['Culture', 'Festivals'],
  ),
  '/food': _Meta(
    'Filipino Food Guide — Adobo, Sinigang, Lechon & More',
    'Taste iconic Filipino dishes, street food favorites, and regional specialties with where to try them.',
    ['Culture', 'Food'],
  ),
  '/itineraries': _Meta(
    'Philippines Itineraries — 7/10/14-Day Sample Routes',
    'Ready-made Philippines itineraries for a week or more, with route maps, costs, and transport tips.',
    ['Planning', 'Itineraries'],
  ),
  '/safety-budget': _Meta(
    'Safety & Budget Tips for Traveling the Philippines',
    'Essential safety, money, and connectivity tips to travel the Philippines confidently on any budget.',
    ['Planning', 'Safety & Budget'],
  ),
  '/404': _Meta(
    '404 - Page Not Found | Discover Philippines',
    'The page you are looking for does not exist. Explore our guides to start planning your trip.',
    ['Home', '404'],
  ),
};
