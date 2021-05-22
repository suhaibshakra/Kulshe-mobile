import 'package:shared_preferences/shared_preferences.dart';

class TimeAgo {
  static String timeAgoSinceDate(String dateString,
      {bool numericDates = true}) {
    DateTime date = DateTime.parse(dateString);
    final date2 = DateTime.now();
    final difference = date2.difference(date);

    if (difference.inSeconds < 5) {
      return 'الان ';
    } else if (difference.inSeconds < 60) {
      return '  منذ  ${difference.inSeconds} ثانية ';
    } else if (difference.inMinutes <= 1) {
      return (numericDates) ? 'منذ 1 دقيقة' : 'منذ دقيقة';
    } else if (difference.inMinutes < 60) {
      return ' منذ ${difference.inMinutes} دقيقة ';
    } else if (difference.inHours <= 1) {
      return (numericDates) ? 'منذ 1 ساعة' : 'منذ ساعة';
    } else if (difference.inHours < 60) {
      return ' منذ ${difference.inHours} ساعة ';
    } else if (difference.inDays <= 1) {
      return (numericDates) ? 'منذ 1 يوم' : 'أمس';
    } else if (difference.inDays < 6) {
      return ' منذ ${difference.inDays} يوم ';
    } else if ((difference.inDays / 7).ceil() <= 1) {
      return (numericDates) ? 'منذ 1 اسبوع' : 'منذ اسبوع';
    } else if ((difference.inDays / 7).ceil() < 4) {
      return ' منذ ${(difference.inDays / 7).ceil()} اسابيع ';
    } else if ((difference.inDays / 30).ceil() <= 1) {
      return (numericDates) ? 'منذ 1 شهر' : 'الشهر الماضي';
    } else if ((difference.inDays / 30).ceil() < 30) {
      return ' منذ ${(difference.inDays / 30).ceil()} أشهر ';
    } else if ((difference.inDays / 365).ceil() <= 1) {
      return (numericDates) ? 'منذ 1 سنة' : 'السنة الماضي';
    }
    return ' منذ ${(difference.inDays / 365).floor()} سنة ';
  }
}