import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool>? get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool>? get isConnected async {
    Future<bool>? hasConnection = connectivity.hasConnection;
    return hasConnection;
  }

}
