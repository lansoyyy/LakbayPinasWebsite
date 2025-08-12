import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class SeoManager {
  static void updateForRoute({
    required String routePath,
    required String title,
    required String description,
    List<String> breadcrumbs = const [],
  }) {
    if (!kIsWeb) return;
    try {
      _setTitle(title);
      _setMetaDescription(description);
      _setCanonical(_buildCanonical(routePath));
      _setJsonLd(_buildJsonLd(routePath, title, description, breadcrumbs));
    } catch (_) {
      // Swallow errors in non-browser contexts or CSP restrictions.
    }
  }

  static void _setTitle(String title) {
    html.document.title = title;
  }

  static void _setMetaDescription(String description) {
    final meta = _ensureTag('meta', attribute: 'name', value: 'description');
    meta.setAttribute('content', description);
  }

  static void _setCanonical(String href) {
    final link = _ensureTag('link', attribute: 'rel', value: 'canonical');
    link.setAttribute('href', href);
  }

  static void _setJsonLd(Map<String, dynamic> data) {
    const scriptId = 'ld-json-dynamic';
    html.Element? script = html.document.getElementById(scriptId);
    if (script == null) {
      script = html.ScriptElement()
        ..type = 'application/ld+json'
        ..id = scriptId;
      html.document.head?.append(script);
    }
    script.text = const JsonEncoder.withIndent('  ').convert(data);
  }

  static String _buildCanonical(String routePath) {
    final loc = html.window.location;
    final origin = '${loc.protocol}//${loc.host}';
    // Ensure leading slash
    final path = routePath.startsWith('/') ? routePath : '/$routePath';
    return origin + path;
  }

  static Map<String, dynamic> _buildJsonLd(
    String routePath,
    String title,
    String description,
    List<String> breadcrumbs,
  ) {
    final canonical = _buildCanonical(routePath);
    final List<Map<String, dynamic>> itemListElements = [];

    // Home
    itemListElements.add({
      '@type': 'ListItem',
      'position': 1,
      'name': 'Home',
      'item': _buildCanonical('/'),
    });

    for (var i = 0; i < breadcrumbs.length; i++) {
      final name = breadcrumbs[i];
      // Build a simple path from breadcrumbs; fallback to route if not meaningful.
      final crumbPath = i == breadcrumbs.length - 1 ? routePath : '/';
      itemListElements.add({
        '@type': 'ListItem',
        'position': i + 2,
        'name': name,
        'item': _buildCanonical(crumbPath),
      });
    }

    return {
      '@context': 'https://schema.org',
      '@graph': [
        {
          '@type': 'WebPage',
          '@id': canonical,
          'url': canonical,
          'name': title,
          'headline': title,
          'description': description,
          'inLanguage': 'en',
          'isPartOf': {
            '@type': 'WebSite',
            'name': 'Discover Philippines',
            'url': _buildCanonical('/'),
          }
        },
        {
          '@type': 'BreadcrumbList',
          'itemListElement': itemListElements,
        },
      ],
    };
  }

  static html.Element _ensureTag(String tagName,
      {required String attribute, required String value}) {
    final selector = '$tagName[$attribute="$value"]';
    final existing = html.document.head?.querySelector(selector);
    if (existing != null) return existing;
    final el = html.Element.tag(tagName)..setAttribute(attribute, value);
    html.document.head?.append(el);
    return el;
  }
}
