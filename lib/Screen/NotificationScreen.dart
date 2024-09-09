import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Providerr/NotificationProvider.dart';
import '../Resources/Strings.dart';
import '../Resources/Styles.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    ref.read(notificationProvider.notifier).fetchNotifications(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notificationState = ref.watch(notificationProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Notifications'),
        ),
        body: notificationState.notifications != null
            ? notificationState.notifications!.data!.length == 0
                ? Center(
                    child: Text(
                      Strings.dataNotAvailable,
                      style: Styles.normalText(context: context),
                    ),
                  )
                : ListView.builder(
                    itemCount:
                        notificationState.notifications?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      final notification = notificationState
                          .notifications?.data![index]
                          .toString();
                      return ListTile(
                        title: Text(notification
                            .toString()), // Modify this to display relevant info
                      );
                    },
                  )
            : SizedBox());
  }
}
