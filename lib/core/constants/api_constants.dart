abstract final class ApiConstants {
  static const serverBaseUrl = String.fromEnvironment(
    'SERVER_BASE_URL',
    defaultValue: 'https://localhost:7143',
  );

  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '$serverBaseUrl/api',
  );

  static const products = '/products';
  static const sales = '/sales';

  static String? resolveServerUrl(String? path) {
    if (path == null || path.isEmpty) return path;

    final uri = Uri.tryParse(path);
    if (uri != null && uri.hasScheme) return path;

    return Uri.parse(serverBaseUrl).resolve(path).toString();
  }
}
