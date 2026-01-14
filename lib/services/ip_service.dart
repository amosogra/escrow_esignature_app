import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service to detect user's IP address
class IpService {
  static final IpService instance = IpService._internal();
  IpService._internal();

  String? _cachedIpAddress;

  /// Get user's IP address
  /// First tries to fetch from external API, falls back to simulated IP
  Future<String> getIpAddress() async {
    // Return cached IP if available
    if (_cachedIpAddress != null) {
      return _cachedIpAddress!;
    }

    try {
      // Try to get IP from external API (with timeout)
      final response = await http
          .get(Uri.parse('https://api.ipify.org?format=json'))
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _cachedIpAddress = data['ip'] as String;
        return _cachedIpAddress!;
      }
    } catch (e) {
      // If network request fails, use simulated IP
    }

    // Fallback to simulated IP address (for demo/offline mode)
    _cachedIpAddress = _generateSimulatedIp();
    return _cachedIpAddress!;
  }

  /// Generate a simulated IP address for demo purposes
  String _generateSimulatedIp() {
    final now = DateTime.now();
    // Generate a pseudo-random but consistent IP based on timestamp
    final octet1 = (now.hour * 10) % 256;
    final octet2 = (now.minute * 4) % 256;
    final octet3 = (now.second * 2) % 256;
    final octet4 = now.millisecond % 256;

    return '$octet1.$octet2.$octet3.$octet4';
  }

  /// Clear cached IP address
  void clearCache() {
    _cachedIpAddress = null;
  }
}
