import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lakbay_pinas/widgets/breadcrumbs.dart';

class IslandsScreen extends StatelessWidget {
  const IslandsScreen({super.key});

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
                    BreadcrumbItem('Islands'),
                  ],
                ),
                Text('Best Islands in the Philippines',
                    style: GoogleFonts.poppins(
                        fontSize: isMobile ? 28 : 40,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D47A1))),
                const SizedBox(height: 16),
                Text(
                    'From Palawan’s limestone cliffs to Boracay’s white sands and Siargao’s surf breaks, the Philippines offers world-class island experiences across 7,641 islands.',
                    style: GoogleFonts.poppins(
                        fontSize: isMobile ? 16 : 18,
                        height: 1.6,
                        color: Colors.grey[800])),
                const SizedBox(height: 24),
                _islandCard(context, 'Palawan',
                    'El Nido and Coron for lagoons and shipwreck dives; Puerto Princesa Underground River.'),
                const SizedBox(height: 12),
                _islandCard(context, 'Boracay',
                    'Powdery White Beach, water sports, and lively nightlife.'),
                const SizedBox(height: 12),
                _islandCard(context, 'Bohol',
                    'Chocolate Hills, tarsiers, and beautiful Alona Beach on Panglao Island.'),
                const SizedBox(height: 12),
                _islandCard(context, 'Siargao',
                    'Cloud 9 surf, island hopping to Naked, Daku, and Guyam Islands.'),
                const SizedBox(height: 24),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  _linkButton(context,
                      label: 'Best Time to Visit', route: '/best-time'),
                  _linkButton(context,
                      label: 'Itineraries', route: '/itineraries'),
                  _linkButton(context,
                      label: 'Filipino Food Guide', route: '/food'),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _islandCard(BuildContext context, String title, String desc) {
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
