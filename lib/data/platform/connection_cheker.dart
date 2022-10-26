import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class ConnectionCheker {
  Future<bool> get isAvailable;
}

class ConnectionChekerImpl implements ConnectionCheker {
  final InternetConnectionChecker _internetConnectionChecker;

  const ConnectionChekerImpl(
      InternetConnectionChecker internetConnectionChecker)
      : _internetConnectionChecker = internetConnectionChecker;

  @override
  Future<bool> get isAvailable => _internetConnectionChecker.hasConnection;
}
