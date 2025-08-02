import 'dart:convert';
import 'package:http/http.dart' as http;

class GeolocationService {
  // Free IP geolocation APIs
  static const String _ipApiUrl = 'http://ip-api.com/json/';
  static const String _ipInfoUrl = 'https://ipinfo.io/json';

  /// Get user's country using IP geolocation
  /// Returns a Map with country information
  static Future<Map<String, dynamic>?> getUserCountry() async {
    try {
      // Try ip-api.com first (free, no API key required)
      final response = await http.get(
        Uri.parse(_ipApiUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          return {
            'country': data['country'],
            'countryCode': data['countryCode'],
            'region': data['regionName'],
            'city': data['city'],
            'latitude': data['lat'],
            'longitude': data['lon'],
            'timezone': data['timezone'],
            'currency': data['currency'] ?? 'Unknown',
            'provider': 'ip-api.com',
          };
        }
      }

      // Fallback to ipinfo.io
      return await _getCountryFromIPInfo();
    } catch (e) {
      // Fallback to alternative service
      return await _getCountryFromIPInfo();
    }
  }

  /// Fallback method using ipinfo.io
  static Future<Map<String, dynamic>?> _getCountryFromIPInfo() async {
    try {
      final response = await http.get(
        Uri.parse(_ipInfoUrl),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return {
          'country': data['country'] ?? 'Unknown',
          'countryCode': data['country'] ?? 'Unknown',
          'region': data['region'] ?? 'Unknown',
          'city': data['city'] ?? 'Unknown',
          'latitude': null,
          'longitude': null,
          'timezone': data['timezone'] ?? 'Unknown',
          'currency': 'Unknown',
          'provider': 'ipinfo.io',
        };
      }
    } catch (e) {
      // Error handled silently for production
    }

    return null;
  }

  /// Get country name from country code
  static String getCountryName(String countryCode) {
    final countries = {
      'PH': 'Philippines',
      'US': 'United States',
      'GB': 'United Kingdom',
      'CA': 'Canada',
      'AU': 'Australia',
      'JP': 'Japan',
      'KR': 'South Korea',
      'CN': 'China',
      'IN': 'India',
      'SG': 'Singapore',
      'MY': 'Malaysia',
      'TH': 'Thailand',
      'VN': 'Vietnam',
      'ID': 'Indonesia',
      'DE': 'Germany',
      'FR': 'France',
      'IT': 'Italy',
      'ES': 'Spain',
      'NL': 'Netherlands',
      'BE': 'Belgium',
      'CH': 'Switzerland',
      'AT': 'Austria',
      'SE': 'Sweden',
      'NO': 'Norway',
      'DK': 'Denmark',
      'FI': 'Finland',
      'BR': 'Brazil',
      'MX': 'Mexico',
      'AR': 'Argentina',
      'CL': 'Chile',
      'CO': 'Colombia',
      'PE': 'Peru',
      'ZA': 'South Africa',
      'EG': 'Egypt',
      'NG': 'Nigeria',
      'KE': 'Kenya',
      'RU': 'Russia',
      'TR': 'Turkey',
      'SA': 'Saudi Arabia',
      'AE': 'United Arab Emirates',
      'IL': 'Israel',
      'NZ': 'New Zealand',
    };

    return countries[countryCode.toUpperCase()] ?? countryCode;
  }

  /// Check if user is from Philippines
  static bool isFromPhilippines(Map<String, dynamic>? locationData) {
    if (locationData == null) return false;
    final countryCode = locationData['countryCode']?.toString().toUpperCase();
    return countryCode == 'PH';
  }

  /// Get welcome message based on country
  static String getWelcomeMessage(Map<String, dynamic>? locationData) {
    if (locationData == null) {
      return 'Welcome to Discover Philippines!';
    }

    final country = locationData['country'] ?? 'Unknown';

    return 'Welcome to the Philippines from $country!';
  }

  /// Get currency suggestion based on country
  static String getCurrencySuggestion(Map<String, dynamic>? locationData) {
    if (locationData == null) return 'PHP (Philippine Peso)';

    final countryCode = locationData['countryCode']?.toString().toUpperCase();

    final currencies = {
      'PH': 'PHP (Philippine Peso)',
      'US': 'USD (US Dollar)',
      'GB': 'GBP (British Pound)',
      'CA': 'CAD (Canadian Dollar)',
      'AU': 'AUD (Australian Dollar)',
      'JP': 'JPY (Japanese Yen)',
      'KR': 'KRW (Korean Won)',
      'CN': 'CNY (Chinese Yuan)',
      'IN': 'INR (Indian Rupee)',
      'SG': 'SGD (Singapore Dollar)',
      'MY': 'MYR (Malaysian Ringgit)',
      'TH': 'THB (Thai Baht)',
      'VN': 'VND (Vietnamese Dong)',
      'ID': 'IDR (Indonesian Rupiah)',
      'EU': 'EUR (Euro)',
    };

    return currencies[countryCode] ?? 'PHP (Philippine Peso)';
  }
}
