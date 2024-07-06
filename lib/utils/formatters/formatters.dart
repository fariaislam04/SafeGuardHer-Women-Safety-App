import 'package:intl/intl.dart';

class Formatters {
  // Function to format date string "YYYY-MM-DD" into "DD MM, YYYY"
  static String formatDateString(String dateString) {
    DateTime date = DateTime.parse(dateString);
    final DateFormat formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(date);
  }

  // Function to format date into "DD MM, YYYY"
  static String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(date);
  }

  // Function to format date and time into "DD MM, YYYY HH:MM"
  static String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMM, yyyy HH:mm');
    return formatter.format(dateTime);
  }

  // Function to format time into "HH:MM AM/PM"
  static String formatTime(String timeString) {
    // Parse the input time string into a DateTime object
    DateTime time = DateFormat('HH:mm:ss').parse(timeString);

    // Format the DateTime object into "HH:MM AM/PM"
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(time);
  }

  // Function to parse a string into a DateTime object
  static DateTime parseDate(String date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.parse(date);
  }

  // Function to format duration into "HH hours, MM minutes, SS seconds"
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String hours = twoDigits(duration.inHours);
    final String minutes = twoDigits(duration.inMinutes.remainder(60));
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours hours, $minutes minutes, $seconds seconds';
  }

  // Function to format duration into "MM minutes, SS seconds"
  static String formatDurationShort(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String minutes = twoDigits(duration.inMinutes);
    final String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes minutes, $seconds seconds';
  }
}
