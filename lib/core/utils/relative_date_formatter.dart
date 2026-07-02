class RelativeDateFormatter {
  static const String unavailable = 'Not available';

  static String format(
    DateTime? dateTime, {
    String fallback = unavailable,
  }) {
    if (dateTime == null) return fallback;

    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.isNegative) return 'Just now';
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) {
      final minutes = difference.inMinutes;
      return '$minutes min ago';
    }
    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hr ago';
    }
    if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days day${days == 1 ? '' : 's'} ago';
    }
    if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    }
    if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '$months month${months == 1 ? '' : 's'} ago';
    }

    final years = difference.inDays ~/ 365;
    return '$years year${years == 1 ? '' : 's'} ago';
  }
}
