import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import 'package:nb_utils/nb_utils.dart';
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
            ? notificationState.notifications!.data!.isEmpty
                ? Center(
                    child: Text(
                      Strings.dataNotAvailable,
                      style: Styles.normalText(context: context),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount:
                          notificationState.notifications?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  notificationState
                                      .notifications!.data![index].message
                                      .toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineLarge,
                                ),
                                10.height,
                                Text(
                                  notificationState
                                      .notifications!.data![index].created
                                      .toString(),
                                  style:
                                  Theme.of(context).textTheme.titleMedium,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
            : SizedBox());
  }
}
