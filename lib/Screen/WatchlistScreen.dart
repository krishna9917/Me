import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/CommonWidget/TradeStock.dart';
import 'package:me_app/Resources/ImagePaths.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:me_app/Screen/SearchScreen.dart';
import 'package:me_app/Screen/StockDetailScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetMCXModel.dart';
import '../Providerr/WatchlistNotifier.dart';
import '../Utils/Colors.dart';
import '../Resources/Strings.dart';
import '../Utils/Themepopup.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(watchlistProvider.notifier).fetchCategoryList(context));
  }

  @override
  Widget build(BuildContext context) {
    final watchlistState = ref.watch(watchlistProvider);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Image.asset(ImagePaths.appLogo),
              onPressed: () {
                //_showDialog(context);
              },
            ),
            const Spacer(),
            IconButton(
              icon: Image.asset(ImagePaths.themeChanger),
              onPressed: () {
                showThemeSelectionDialog(context, ref);
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Container(
              color: Colors.grey.shade200,
              child: TabBar(
                tabs: const [
                  Tab(text: Strings.mcxFutures),
                  Tab(text: Strings.nseFutures),
                  Tab(text: Strings.others),
                ],
                labelStyle: Styles.normalText(fontSize: 12, isBold: true),
                unselectedLabelStyle: Styles.normalText(fontSize: 12),
                labelColor: Theme.of(context).tabBarTheme.labelColor,
                unselectedLabelColor:
                    Theme.of(context).tabBarTheme.unselectedLabelColor,
                indicatorColor: goldencolor,
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.grey.shade200,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    _buildListView(watchlistState.mcxList, context, "MCX"),
                    _buildListView(watchlistState.nseList, context, "NSE"),
                    _buildComingSoon(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListView(List<Datum> list, BuildContext context, String type) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSearchBar(context, type),
          10.height,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: list.isNotEmpty
                  ? ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final data = list[index];
                        return Tradestock(data: data).onTap(() {
                          StockDetailScreen(stockData: data)
                              .launch(context)
                              .then((b) {
                            Future.microtask(
                                    () => ref.read(watchlistProvider.notifier).fetchCategoryList(context));
                          });
                        });
                      },
                    )
                  : Center(
                      child: Text(
                        Strings.dataNotAvailable,
                        style: Styles.normalText(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          7.width,
          Text(Strings.search,
              style: Styles.normalText(isBold: true, fontSize: 12)),
        ],
      ),
    ).onTap(() {
      Searchscreen(type: type).launch(context).then((data) {
        ref.read(watchlistProvider.notifier).fetchCategoryList(context);
      });
    });
  }

  Widget _buildComingSoon() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            Strings.comingSoonMsg,
            style: Styles.normalText(fontSize: 20, isBold: true),
          ),
        ),
      ],
    );
  }
}
