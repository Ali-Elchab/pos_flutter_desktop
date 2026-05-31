abstract final class ApiConstants {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://localhost:7143/api',
  );

  static const products = '/products';
  static const sales = '/sales';
}
