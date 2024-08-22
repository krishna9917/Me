import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Providerr/SearchNotifier.dart';
import '../Resources/Styles.dart';
import '../Resources/Strings.dart';
import '../Utils/HelperFunction.dart';
import '../CommonWidget/TradeStock.dart';

class Searchscreen extends ConsumerStatefulWidget {
  final String type;

  Searchscreen({super.key, required this.type});

  @override
  ConsumerState<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends ConsumerState<Searchscreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    ref
        .read(searchNotifierProvider(widget.type).notifier)
        .fetchCategoryList(context);
    _startPeriodicRefresh();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (await HelperFunction.isInternetConnected(context)) {
        ref
            .read(searchNotifierProvider(widget.type).notifier)
            .fetchData(context);
      }
    });
  }

  void searchStock(String query) {
    ref.read(searchNotifierProvider(widget.type).notifier).searchStock(query);
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider(widget.type));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: searchStock,
          style: Styles.normalText(color: Colors.white),
          decoration: InputDecoration(
            hintText: Strings.search,
            hintStyle: Styles.normalText(color: Colors.white),
            border: InputBorder.none,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: searchState.list.isNotEmpty
          ? ListView.builder(
              itemCount: searchState.list.length,
              itemBuilder: (context, index) {
                final data = searchState.list[index];
                return Tradestock(
                  data: data,
                  showCheckUncheck: true,
                ).onTap(() {
                  ref
                      .read(searchNotifierProvider(widget.type).notifier)
                      .addToWatchList(context, data.categoryId.toString(),
                          data.isChecked!, index);
                });
              },
            )
          : Center(
              child: Text(
                Strings.dataNotAvailable,
                style: Styles.normalText(),
              ),
            ),
    );
  }
}
