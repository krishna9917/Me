import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Providerr/NotificationProvider.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final getNotification = ref.watch(notificationProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Notifications'),
      ),
      body: getNotification == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: getNotification.data?.length ?? 0,
              itemBuilder: (context, index) {
                final notification = getNotification.data![index];
                return ListTile(
                  title: Text(notification
                      .toString()), // Modify this to display relevant info
                );
              },
            ),
    );
  }
}
