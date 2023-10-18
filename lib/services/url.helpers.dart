class URLHelpers {
  static const String host = "localhost";
  static const int port = 7091;
  static const String scheme = "https";
  static const String apiPath = "/api/";

  static Uri buildUri(String path) {
    return Uri(scheme: scheme, host: host, port: port, path: apiPath + path);
  }

  static Uri buildUriWithParams(
      String path, Map<String, dynamic>? queryParams) {
    return Uri(
        scheme: scheme,
        host: host,
        port: port,
        path: apiPath + path,
        queryParameters: queryParams);
  }

  static Map<String, String> buildHeaders({String? accessToken}) {
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    if (accessToken != null) {
      headers['Authorization'] = 'Bearer $accessToken';
    }
    return headers;
  }
}
