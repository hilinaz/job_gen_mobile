import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'custom_http_client.dart';

abstract class NetworkInfo {
  /// Check if device is connected to internet
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  late final CustomHttpClient _httpClient;
  
  NetworkInfoImpl({
    required Connectivity connectivity,
    CustomHttpClient? httpClient,
  }) : _connectivity = connectivity {
    _httpClient = httpClient ?? CustomHttpClient(connectivity: _connectivity);
  }

  @override
  Future<bool> get isConnected async {
    try {
      // For web, avoid external HTTP probes (blocked by CORS). Rely on connectivity_plus only.
      if (kIsWeb) {
        final connectivityResult = await _connectivity.checkConnectivity();
        return connectivityResult != ConnectivityResult.none;
      }

      // For mobile/desktop, first check connectivity status
      final connectivityResult = await _connectivity.checkConnectivity();
      
      // If no network interfaces are connected, return false immediately
      if (connectivityResult == ConnectivityResult.none) {
        return false;
      }
      
      // For mobile data, WiFi, or Ethernet, verify with a request
      return await _checkInternetConnection();
    } catch (e) {
      return false;
    } finally {
      _httpClient.close();
    }
  }

  Future<bool> _checkInternetConnection() async {
    final urls = [
      Uri.https('www.google.com', ''),
      Uri.https('www.cloudflare.com', ''),
      Uri.https('www.apple.com', ''),
    ];

    for (var uri in urls) {
      try {
        final response = await _httpClient.get(uri);
        if (response.statusCode == 200) {
          return true;
        }
      } catch (e) {
        continue;
      }
    }
    
    return false;
  }
}
