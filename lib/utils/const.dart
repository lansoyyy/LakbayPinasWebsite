// // import 'package:firebase_auth/firebase_auth.dart';

// // String userId = FirebaseAuth.instance.currentUser!.uid;

// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:intl/intl.dart';

// String currentVersion = '1.0.0';
// String logo = 'assets/images/logo.png';
// String label = 'assets/images/label.png';
// String avatar = 'assets/images/avatar.png';
// String icon = 'assets/images/icon.png';
// String textlogo = 'assets/images/textlogo.png';
// LatLngBounds calculateBounds(List<LatLng> coordinates) {
//   double minLat = coordinates.first.latitude;
//   double maxLat = coordinates.first.latitude;
//   double minLng = coordinates.first.longitude;
//   double maxLng = coordinates.first.longitude;

//   for (final coord in coordinates) {
//     if (coord.latitude < minLat) minLat = coord.latitude;
//     if (coord.latitude > maxLat) maxLat = coord.latitude;
//     if (coord.longitude < minLng) minLng = coord.longitude;
//     if (coord.longitude > maxLng) maxLng = coord.longitude;
//   }

//   return LatLngBounds(
//     southwest: LatLng(minLat, minLng),
//     northeast: LatLng(maxLat, maxLng),
//   );
// }

// List socials = [
//   'assets/images/phone.png',
//   'assets/images/apple.png',
//   'assets/images/google.png',
//   'assets/images/facebook.png'
// ];

// List foodCategories = [
//   'assets/images/fastfood.png',
//   'assets/images/coffee.png',
//   'assets/images/donut.png',
//   'assets/images/bbq.png',
//   'assets/images/pizza.png'
// ];
// List foodCategoriesName = [
//   'Fastfood',
//   'Drinks',
//   'Donut',
//   'BBQ',
//   'Pizza',
// ];

// List shopCategories = [
//   'Combo',
//   'Meals',
//   'Snacks',
//   'Drinks',
//   'Add-ons',
// ];

// String home = 'assets/images/home.png';
// String office = 'assets/images/office.png';
// String groups = 'assets/images/groups.png';
// String gcash = 'assets/images/image 5.png';
// String paymaya = 'assets/images/image 6.png';
// String bpi = 'assets/images/clarity_bank-solid.png';
// double calculateFlatInterest(
//   double amount,
//   double ratePercent,
// ) {
//   double interest = amount * (ratePercent / 100);

//   double total = amount + interest;
//   return total;
// }

// double calculateInterest(double amount, double ratePercent) {
//   double interest = amount * (ratePercent / 100);
//   // double partial = interest * duration;

//   return interest;
// }

// final List<String> shortMonths = [
//   'January',
//   'February',
//   'March',
//   'April',
//   'May',
//   'June',
//   'July',
//   'August',
//   'September',
//   'October',
//   'November',
//   'December',
// ];

// List luzonRegions = [
//   {
//     'regionNumber': 'Region I',
//     'region': 'Ilocos Region (Region I)',
//     'provinces': ['Ilocos Norte', 'Ilocos Sur', 'La Union', 'Pangasinan'],
//   },
//   {
//     'regionNumber': 'Region II',
//     'region': 'Cagayan Valley (Region II)',
//     'provinces': ['Cagayan', 'Isabela', 'Nueva Vizcaya'],
//   },
//   {
//     'regionNumber': 'Region III',
//     'region': 'Central Luzon (Region III)',
//     'provinces': ['Pampanga', 'Tarlac', 'Bulacan', 'Zambales'],
//   },
//   {
//     'regionNumber': 'Region IV-A',
//     'region': 'CALABARZON (Region IV-A)',
//     'provinces': ['Cavite', 'Laguna', 'Batangas', 'Rizal', 'Quezon'],
//   },
//   {
//     'region': 'MIMAROPA (Region IV-B)',
//     'regionNumber': 'Region IV-B',
//     'provinces': [
//       'Palawan',
//       'Oriental Mindoro',
//       'Occidental Mindoro',
//       'Romblon'
//     ],
//   },
//   {
//     'region': 'Bicol Region (Region V)',
//     'regionNumber': 'Region V',
//     'provinces': ['Albay', 'Camarines Sur', 'Camarines Norte', 'Sorsogon'],
//   },
//   {
//     'region': 'Cordillera Administrative Region (CAR)',
//     'regionNumber': 'CAR',
//     'provinces': ['Benguet', 'Ifugao', 'Mountain Province'],
//   },
//   {
//     'region': 'National Capital Region (NCR)',
//     'regionNumber': 'NCR',
//     'provinces': ['Metro Manila'],
//   },
// ];

// List visayasRegions = [
//   {
//     'region': 'Western Visayas (Region VI)',
//     'regionNumber': 'Region VI',
//     'provinces': ['Iloilo', 'Aklan', 'Antique', 'Capiz', 'Negros Occidental'],
//   },
//   {
//     'region': 'Central Visayas (Region VII)',
//     'regionNumber': 'Region VII',
//     'provinces': ['Cebu', 'Bohol', 'Negros Oriental', 'Siquijor'],
//   },
//   {
//     'region': 'Eastern Visayas (Region VIII)',
//     'regionNumber': 'Region VIII',
//     'provinces': ['Leyte', 'Samar', 'Eastern Samar', 'Southern Leyte'],
//   },
// ];

// List mindanaoRegions = [
//   {
//     'region': 'Zamboanga Peninsula (Region IX)',
//     'regionNumber': 'Region IX',
//     'provinces': [
//       'Zamboanga del Sur',
//       'Zamboanga del Norte',
//       'Zamboanga Sibugay'
//     ],
//   },
//   {
//     'region': 'Northern Mindanao (Region X)',
//     'regionNumber': 'Region X',
//     'provinces': ['Bukidnon', 'Misamis Oriental', 'Lanao del Norte'],
//   },
//   {
//     'region': 'Davao Region (Region XI)',
//     'regionNumber': 'Region XI',
//     'provinces': ['Davao del Sur', 'Davao del Norte', 'Davao Oriental'],
//   },
//   {
//     'region': 'SOCCSKSARGEN (Region XII)',
//     'regionNumber': 'Region XII',
//     'provinces': ['South Cotabato', 'Sultan Kudarat', 'Cotabato', 'Sarangani'],
//   },
//   {
//     'region': 'Caraga (Region XIII)',
//     'regionNumber': 'Region XIII',
//     'provinces': [
//       'Agusan del Norte',
//       'Agusan del Sur',
//       'Surigao del Norte',
//       'Surigao del Sur'
//     ],
//   },
//   {
//     'region': 'Bangsamoro Autonomous Region in Muslim Mindanao (BARMM)',
//     'regionNumber': 'BARMM',
//     'provinces': [
//       'Maguindanao del Norte',
//       'Lanao del Sur',
//       'Sulu',
//       'Tawi-Tawi'
//     ],
//   },
// ];
// List<String> regionNumbers = [
//   'Region I',
//   'Region II',
//   'Region III',
//   'Region IV-A',
//   'Region IV-B',
//   'Region V',
//   'CAR',
//   'NCR',
//   'Region VI',
//   'Region VII',
//   'Region VIII',
//   'Region IX',
//   'Region X',
//   'Region XI',
//   'Region XII',
//   'Region XIII',
//   'BARMM',
// ];

// List<String> regionNumbersArabic = [
//   'Region 1',
//   'Region 2',
//   'Region 3',
//   'Region 4-A',
//   'Region 4-B',
//   'Region 5',
//   'CAR',
//   'NCR',
//   'Region 6',
//   'Region 7',
//   'Region 8',
//   'Region 9',
//   'Region 10',
//   'Region 11',
//   'Region 12',
//   'Region 13',
//   'BARMM',
// ];

// String romanToInt(String s) {
//   Map<String, int> romanMap = {
//     'I': 1,
//     'V': 5,
//     'X': 10,
//     'L': 50,
//     'C': 100,
//     'D': 500,
//     'M': 1000,
//   };

//   int total = 0;
//   int prev = 0;

//   for (int i = s.length - 1; i >= 0; i--) {
//     int current = romanMap[s[i]] ?? 0;
//     if (current < prev) {
//       total -= current;
//     } else {
//       total += current;
//     }
//     prev = current;
//   }

//   return 'Region $total';
// }

// List<Map<String, dynamic>> allRegions = [
//   ...luzonRegions,
//   ...visayasRegions,
//   ...mindanaoRegions,
// ];

// String formatDate(String dateStr) {
//   DateTime date = DateTime.parse(dateStr); // expects 'yyyy-MM-dd' format
//   return DateFormat('MMMM dd, yyyy').format(date);
// }

// String convertImageUrlGoogleDrive(String driveLink) {
//   final regex = RegExp(r'/d/([a-zA-Z0-9_-]+)');
//   final match = regex.firstMatch(driveLink);
//   if (match != null && match.groupCount >= 1) {
//     final fileId = match.group(1);
//     return 'https://drive.google.com/uc?export=view&id=$fileId';
//   }
//   return ''; // return empty string if the link is invalid
// }
