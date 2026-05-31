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
  static const salesCheckout = '/sales/checkout';

  static String apiBaseUrlFor(String serverBaseUrl) {
    return '${normalizeServerBaseUrl(serverBaseUrl)}/api';
  }

  static String normalizeServerBaseUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.endsWith('/api')) {
      return trimmed.substring(0, trimmed.length - 4);
    }
    if (trimmed.endsWith('/')) {
      return trimmed.substring(0, trimmed.length - 1);
    }
    return trimmed;
  }

  static String? resolveServerUrl(
    String? path, {
    String serverBaseUrl = ApiConstants.serverBaseUrl,
  }) {
    if (path == null || path.isEmpty) return path;

    final uri = Uri.tryParse(path);
    if (uri != null && uri.hasScheme) return path;

    return Uri.parse(
      normalizeServerBaseUrl(serverBaseUrl),
    ).resolve(path).toString();
  }
}
