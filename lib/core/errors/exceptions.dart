class NewsAppException implements Exception {
  final String? errorMessage;

  const NewsAppException({this.errorMessage});

  @override
  String toString() {
    return 'ERROR: $errorMessage';
  }
}

class RemoteDataSourceException extends NewsAppException {
  const RemoteDataSourceException({super.errorMessage});
}

class NetworkConnectionException extends NewsAppException {
  const NetworkConnectionException({super.errorMessage});
}

class LocalDataSourceException extends NewsAppException {
  const LocalDataSourceException({super.errorMessage});
}
