import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnackBar(BuildContext context, String title, Color color) {
  final isMobile = MediaQuery.of(context).size.width < 600;
  final scaleFactor = isMobile ? 0.9 : 1.0;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14 * scaleFactor,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              child: Icon(
                Icons.close,
                color: Colors.white.withOpacity(0.8),
                size: 20 * scaleFactor,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(16 * scaleFactor),
      padding: EdgeInsets.zero,
      duration: const Duration(seconds: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12 * scaleFactor),
      ),

      showCloseIcon: false,
      clipBehavior: Clip.antiAlias,
      width: isMobile ? null : 400 * scaleFactor, // Fixed width for web
      animation: CurvedAnimation(
        parent: kAlwaysCompleteAnimation,
        curve: Curves.easeOutCubic,
      ),
      action: null,
      onVisible: () {},
    ),
  );
}
