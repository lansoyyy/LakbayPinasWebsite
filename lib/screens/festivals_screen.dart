import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lakbay_pinas/widgets/breadcrumbs.dart';

class FestivalsScreen extends StatelessWidget {
  const FestivalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 60, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Breadcrumbs(
                  items: const [
                    BreadcrumbItem('Home', route: '/'),
                    BreadcrumbItem('Festivals'),
                  ],
                ),
                Text('Philippine Festivals', style: GoogleFonts.poppins(fontSize: isMobile ? 28 : 40, fontWeight: FontWeight.w700, color: const Color(0xFF0D47A1))),
                const SizedBox(height: 16),
                Text('Vibrant and colorful celebrations happen year-round across the Philippines, showcasing local culture, faith, and community.', style: GoogleFonts.poppins(fontSize: isMobile ? 16 : 18, height: 1.6, color: Colors.grey[800])),
                const SizedBox(height: 24),
                _festival(context, 'Sinulog (Cebu)', 'January: Grand street dancing in honor of Santo Niño.'),
                const SizedBox(height: 12),
                _festival(context, 'Ati-Atihan (Kalibo)', 'January: Tribal costumes, drums, and parades.'),
                const SizedBox(height: 12),
                _festival(context, 'Panagbenga (Baguio)', 'February–March: Flower festival and parades.'),
                const SizedBox(height: 24),
                Wrap(spacing: 12, runSpacing: 12, children: [
                  _linkButton(context, label: 'Best Time to Visit', route: '/best-time'),
                  _linkButton(context, label: 'Top Islands', route: '/islands'),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _festival(BuildContext context, String name, String desc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700, color: const Color(0xFF0D47A1))),
        const SizedBox(height: 8),
        Text(desc, style: GoogleFonts.poppins(fontSize: 16, height: 1.6, color: Colors.grey[800])),
      ]),
    );
  }

  Widget _linkButton(BuildContext context, {required String label, required String route}) {
    return OutlinedButton(onPressed: () => Navigator.of(context).pushNamed(route), child: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)));
  }
}
