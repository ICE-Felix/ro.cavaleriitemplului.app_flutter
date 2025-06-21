import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    try {
      if (kDebugMode) {
        print('🔍 Checking connectivity...');
      }

      // First check if device has any connection (WiFi/cellular)
      final results = await connectivity.checkConnectivity();

      if (kDebugMode) {
        print('🔍 Connectivity results: $results');
      }

      // Check if any connection type is available (not none)
      final hasConnection = results.any(
        (result) => result != ConnectivityResult.none,
      );

      if (kDebugMode) {
        print('🔍 Has connection: $hasConnection');
      }

      if (!hasConnection) {
        if (kDebugMode) {
          print('❌ No network connection detected at device level');
        }
        return false;
      }

      // Now check if we can actually reach the internet
      if (kDebugMode) {
        print('🔍 Testing actual internet connectivity...');
      }

      try {
        // Try to lookup Google DNS - this is lightweight and reliable
        final result = await InternetAddress.lookup('google.com');

        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if (kDebugMode) {
            print('✅ Internet connectivity confirmed');
          }
          return true;
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Internet lookup failed: $e');
        }
        return false;
      }

      if (kDebugMode) {
        print('❌ No real internet connection detected');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error checking connectivity: $e');
      }
      return false;
    }
  }
}
