import 'package:connectivity_plus/connectivity_plus.dart';

/// An abstract class that defines the contract for network connectivity checking.
/// 
/// This interface provides methods to check current connectivity status
/// and listen to connectivity changes.
abstract class NetworkInfo {
  /// Checks if the device is currently connected to any network.
  /// 
  /// Returns `true` if connected to any network (WiFi, mobile, etc.),
  /// `false` otherwise.
  Future<bool> get isConnected;

  /// A stream that emits connectivity changes.
  /// 
  /// Emits a [ConnectivityResult] whenever the device's connectivity status changes.
  Stream<ConnectivityResult> get onConnectivityChanged;
}

/// Implementation of [NetworkInfo] using the connectivity_plus package.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectionChecker;

  /// Creates a new [NetworkInfoImpl] instance.
  /// 
  /// [connectionChecker] is the connectivity checker instance to use.
  NetworkInfoImpl(Connectivity connectionChecker) 
      : _connectionChecker = connectionChecker;

  @override
  Future<bool> get isConnected async {
    try {
      final result = await _connectionChecker.checkConnectivity();
      return !result.contains(ConnectivityResult.none);
    } catch (e) {
      // If we can't check connectivity, assume we're not connected
      return false;
    }
  }

  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    return _connectionChecker.onConnectivityChanged
        .map((results) => results.first)
        .distinct(); // Only emit when the result actually changes
  }
}
