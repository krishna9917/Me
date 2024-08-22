import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/GetNotification.dart';
import 'package:http/http.dart' as http;

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(
      'https://www.onlinetradelearn.com/mcx/authController/getNotificationList');
});

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, GetNotification?>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return NotificationNotifier(notificationService);
});

class NotificationNotifier extends StateNotifier<GetNotification?> {
  final NotificationService notificationService;

  NotificationNotifier(this.notificationService) : super(null);

  Future<void> fetchNotifications(String userId) async {
    try {
      final notifications = await notificationService.getNotifications(userId);
      print("Fetched notifications: ${notifications.toJson()}");
      state = notifications;
    } catch (e) {
      print("Error fetching notifications: $e");
    }
  }
}

class NotificationService {
  final String baseUrl;

  NotificationService(this.baseUrl);

  Future<GetNotification> getNotifications(String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Token':
            'bXdSSmNIOHFOS2RoQTNES0hJYndwNmxjS1ZzbkVzZzVNSWdOVHZqRmh0MUFLNTJhSXZFYUdiQzVWS2Z3Z0V5TTNTejI1WWFoRm5MTWFJcTNlczJPajRlMk9qQ2dtZ3dYcExWVU1Laml4SlE9',
        'Deviceid': '12345678',
      },
      body: {
        'userID': userId,
      },
    );

    if (response.statusCode == 200) {
      print("response.statusCode: ${response.statusCode}");
      print("response: ${response.body}");
      return getNotificationFromJson(response.body);
    } else {
      print(
          "Failed to load notifications. Status code: ${response.statusCode}");
      throw Exception('Failed to load notifications');
    }
  }
}
