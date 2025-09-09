import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lakbay_pinas/widgets/breadcrumbs.dart';

class VisaScreen extends StatelessWidget {
  const VisaScreen({super.key});

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
                    BreadcrumbItem('Visa Requirements'),
                  ],
                ),
                Text('Philippines Visa Requirements',
                    style: GoogleFonts.poppins(
                        fontSize: isMobile ? 28 : 40,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D47A1))),
                const SizedBox(height: 16),
                Text(
                  'Many nationalities can enter the Philippines visa-free for up to 30 days with an onward/return ticket and a passport valid for at least six months. Extensions are possible at immigration offices. Always verify the latest rules from official sources before travel.',
                  style: GoogleFonts.poppins(
                      fontSize: isMobile ? 16 : 18,
                      height: 1.6,
                      color: Colors.grey[800]),
                ),
                const SizedBox(height: 24),
                _section(context, 'Visa-Free Entry',
                    'Most ASEAN and many Western nationals receive 30-day visa-free entry. Proof of onward travel may be required.'),
                const SizedBox(height: 12),
                _section(context, 'Extensions',
                    'You can extend tourist stays at Bureau of Immigration offices. Fees apply; allow processing time.'),
                const SizedBox(height: 12),
                _section(context, 'Documents',
                    'Valid passport (6+ months), onward/return ticket, proof of funds/accommodation may be requested.'),
                const SizedBox(height: 24),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  _linkButton(context,
                      label: 'Best Time to Visit', route: '/best-time'),
                  _linkButton(context,
                      label: 'Itineraries', route: '/itineraries'),
                  _linkButton(context, label: 'Top Islands', route: '/islands'),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, String body) {
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
        Text(body,
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
