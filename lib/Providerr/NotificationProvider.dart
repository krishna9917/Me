import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import '../Model/GetNotification.dart';

class NotificationState {
  final GetNotification? notifications;

  NotificationState({
    required this.notifications,
  });

  NotificationState copyWith({
    GetNotification? notifications,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier() : super(NotificationState(notifications: null));

  Future<void> fetchNotifications(BuildContext context,
      {bool showLoading = false}) async {
    final response =
        await ApiInterface.getNotifications(context, showLoading: showLoading);
    if (response != null) {
      state = state.copyWith(notifications: response);
    } else {}
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>(
  (ref) => NotificationNotifier(),
);
