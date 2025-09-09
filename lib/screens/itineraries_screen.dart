import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lakbay_pinas/widgets/breadcrumbs.dart';

class ItinerariesScreen extends StatelessWidget {
  const ItinerariesScreen({super.key});

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
                    BreadcrumbItem('Itineraries'),
                  ],
                ),
                Text('Philippines Travel Itineraries (7/10/14 days)',
                    style: GoogleFonts.poppins(
                        fontSize: isMobile ? 28 : 40,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D47A1))),
                const SizedBox(height: 16),
                Text(
                    'Curated routes for first-timers and repeat visitors—connect islands efficiently while balancing beaches, culture, and nature.',
                    style: GoogleFonts.poppins(
                        fontSize: isMobile ? 16 : 18,
                        height: 1.6,
                        color: Colors.grey[800])),
                const SizedBox(height: 24),
                _itin(context, '7-Day Highlights',
                    'Manila → Palawan (El Nido) → Cebu/Bohol: lagoons, beaches, and Chocolate Hills.'),
                const SizedBox(height: 12),
                _itin(context, '10-Day Adventure',
                    'Manila → Siargao → Cebu → Bohol: surf, canyons, waterfalls, and island vibes.'),
                const SizedBox(height: 12),
                _itin(context, '14-Day Explorer',
                    'Manila → Palawan → Cebu → Siargao → Banaue: from lagoons to rice terraces.'),
                const SizedBox(height: 24),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  _linkButton(context,
                      label: 'Best Time to Visit', route: '/best-time'),
                  _linkButton(context, label: 'Visa Guide', route: '/visa'),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _itin(BuildContext context, String title, String desc) {
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
                offset: const Offset(0, 6))
          ]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D47A1))),
        const SizedBox(height: 8),
        Text(desc,
            style: GoogleFonts.poppins(
                fontSize: 16, height: 1.6, color: Colors.grey[800])),
      ]),
    );
  }

  Widget _linkButton(BuildContext context,
      {required String label, required String route}) {
    return OutlinedButton(
        onPressed: () => Navigator.of(context).pushNamed(route),
        child: Text(label,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)));
  }
}
