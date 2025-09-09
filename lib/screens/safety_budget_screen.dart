import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lakbay_pinas/widgets/breadcrumbs.dart';

class SafetyBudgetScreen extends StatelessWidget {
  const SafetyBudgetScreen({super.key});

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
                    BreadcrumbItem('Safety & Budget'),
                  ],
                ),
                Text('Safety & Budget Tips for the Philippines',
                    style: GoogleFonts.poppins(
                        fontSize: isMobile ? 28 : 40,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D47A1))),
                const SizedBox(height: 16),
                Text(
                    'Plan smarter: typical daily costs, safety basics, scams to avoid, health and insurance tips, and staying connected with SIM/eSIM.',
                    style: GoogleFonts.poppins(
                        fontSize: isMobile ? 16 : 18,
                        height: 1.6,
                        color: Colors.grey[800])),
                const SizedBox(height: 24),
                _tip(context, 'Daily Costs',
                    'Budget (\$30–\$50), Mid-range (\$60–\$120), High-end (\$150+). Vary by island and season.'),
                const SizedBox(height: 12),
                _tip(context, 'Safety Basics',
                    'Use registered transport, avoid flashing valuables, and monitor local advisories.'),
                const SizedBox(height: 12),
                _tip(context, 'Connectivity',
                    'Buy a local SIM or eSIM (Globe/Smart) for data and maps. Wi-Fi quality varies by island.'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tip(BuildContext context, String title, String desc) {
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
}
