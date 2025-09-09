import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lakbay_pinas/widgets/breadcrumbs.dart';

class BestTimeScreen extends StatelessWidget {
  const BestTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 60, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Breadcrumbs(
                  items: const [
                    BreadcrumbItem('Home', route: '/'),
                    BreadcrumbItem('Best Time'),
                  ],
                ),
                Text(
                  'Best Time to Visit the Philippines',
                  style: GoogleFonts.poppins(
                      fontSize: isMobile ? 28 : 40,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D47A1)),
                ),
                const SizedBox(height: 16),
                Text(
                  'The dry season from November to May generally offers the best weather for island hopping, diving, and beach trips. Peak months (December–March) have cooler temperatures and higher crowds and prices. Shoulder months like November and May can be great for value and good weather.',
                  style: GoogleFonts.poppins(
                      fontSize: isMobile ? 16 : 18,
                      height: 1.6,
                      color: Colors.grey[800]),
                ),
                const SizedBox(height: 24),
                _buildCard(
                  context,
                  title: 'Dry Season (Nov–May)',
                  body:
                      'Best for beaches and island hopping. Expect sunny days and calmer seas. Popular destinations like Palawan, Boracay, Bohol, and Cebu shine during this period.',
                ),
                const SizedBox(height: 16),
                _buildCard(
                  context,
                  title: 'Wet Season (Jun–Oct)',
                  body:
                      'Short, intense showers are common, especially in the afternoon. Fewer crowds and lower prices. Surfing in Siargao peaks around August–November.',
                ),
                const SizedBox(height: 16),
                _buildCard(
                  context,
                  title: 'Month-by-Month Highlights',
                  body:
                      'Jan–Mar: cool and dry; Apr–May: hot and dry (summer); Jun–Oct: rainy with regional typhoons possible; Nov–Dec: cool and dry begins. Festivals occur year-round across regions.',
                ),
                const SizedBox(height: 32),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _linkButton(context,
                        label: 'Philippine Visa Guide', route: '/visa'),
                    _linkButton(context,
                        label: 'Top Islands in the Philippines',
                        route: '/islands'),
                    _linkButton(context,
                        label: 'Festivals in the Philippines',
                        route: '/festivals'),
                    _linkButton(context,
                        label: '7/10/14-day Itineraries',
                        route: '/itineraries'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title, required String body}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D47A1))),
          const SizedBox(height: 8),
          Text(body,
              style: GoogleFonts.poppins(
                  fontSize: 16, height: 1.6, color: Colors.grey[800])),
        ],
      ),
    );
  }

  Widget _linkButton(BuildContext context,
      {required String label, required String route}) {
    return OutlinedButton(
      onPressed: () => Navigator.of(context).pushNamed(route),
      style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
      child:
          Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
    );
  }
}
