import 'dart:io';

/// Checks connectivity without needing a package — a lightweight DNS
/// lookup. Swap in connectivity_plus instead if you need OS-level
/// connectivity change events rather than an on-demand check.
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  const NetworkInfoImpl();

  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    }
  }
}
