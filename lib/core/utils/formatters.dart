import 'package:intl/intl.dart';

class Formatters {
  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM d, yyyy h:mm a').format(dateTime);
  }

  static String formatCurrency(double amount) {
    final currencyFormatter = NumberFormat.currency(symbol: '\$');
    return currencyFormatter.format(amount);
  }

  static String formatPoints(double points) {
    return NumberFormat('#,##0.0').format(points);
  }
  
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}