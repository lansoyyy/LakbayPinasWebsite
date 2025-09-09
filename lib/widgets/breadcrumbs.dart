import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BreadcrumbItem {
  final String label;
  final String? route;
  const BreadcrumbItem(this.label, {this.route});
}

class Breadcrumbs extends StatelessWidget {
  final List<BreadcrumbItem> items;
  final EdgeInsetsGeometry padding;
  const Breadcrumbs(
      {super.key,
      required this.items,
      this.padding = const EdgeInsets.only(bottom: 12)});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    return Semantics(
      label: 'Breadcrumb',
      child: Padding(
        padding: padding,
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            for (int i = 0; i < items.length; i++) ...[
              _crumb(context, items[i], isMobile),
              if (i != items.length - 1)
                Icon(Icons.chevron_right,
                    size: isMobile ? 16 : 18, color: Colors.grey[600]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _crumb(BuildContext context, BreadcrumbItem item, bool isMobile) {
    final textStyle = GoogleFonts.poppins(
      fontSize: isMobile ? 12 : 13,
      color: item.route == null ? Colors.grey[700] : const Color(0xFF0D47A1),
      fontWeight: item.route == null ? FontWeight.w500 : FontWeight.w600,
    );
    if (item.route == null) {
      return Text(item.label, style: textStyle);
    }
    return InkWell(
      onTap: () => Get.toNamed(item.route!),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(item.label, style: textStyle),
      ),
    );
  }
}
