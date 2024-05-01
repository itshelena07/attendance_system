import 'package:intl/intl.dart';

class UserDataModel {
  final String user;
  final String phone;
  final DateTime checkIn;
  String timeAgo;

  UserDataModel({
    required this.user,
    required this.phone,
    required this.checkIn,
    required this.timeAgo,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    final String? checkInString = json['check-in'];
    DateTime checkInTime = DateTime.now();

    if (checkInString != null) {
      try {
        final parts = checkInString.split(' ');
        final datePart = parts[0].split('-');
        final timePart = parts[1].split(':');
        final year = int.parse(datePart[0]);
        final month = int.parse(datePart[1]);
        final day = int.parse(datePart[2]);
        final hour = int.parse(timePart[0]);
        final minute = int.parse(timePart[1]);
        final second = int.parse(timePart[2]);
        checkInTime = DateTime(year, month, day, hour, minute, second);
      } catch (e) {
        print('Error parsing check-in time: $e');
      }
    } else {
      print('Missing check-in time in JSON data');
    }

    final now = DateTime.now();
    final timeDifference = now.difference(checkInTime);
    final formattedTimeAgo = _formatTimeDifference(timeDifference);

    return UserDataModel(
      user: json['user'] ?? '',
      phone: json['phone'] ?? '',
      checkIn: checkInTime,
      timeAgo: formattedTimeAgo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'phone': phone,
      'check-in': DateFormat('yyyy-MM-dd HH:mm:ss').format(checkIn),
    };
  }

  static String _formatTimeDifference(Duration difference) {
    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
