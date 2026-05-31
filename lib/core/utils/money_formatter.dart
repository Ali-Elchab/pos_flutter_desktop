import 'package:intl/intl.dart';

abstract final class MoneyFormatter {
  static final NumberFormat _currency = NumberFormat.currency(symbol: '\$');

  static String format(double value) => _currency.format(value);
}
