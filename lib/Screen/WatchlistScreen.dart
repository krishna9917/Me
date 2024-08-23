import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/CommonWidget/TradeStock.dart';
import 'package:me_app/Resources/ImagePaths.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:me_app/Screen/SearchScreen.dart';
import 'package:me_app/Screen/StockDetailScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Dialogs/AlertBox.dart';
import '../Model/GetMCXModel.dart';
import '../Providerr/WatchlistNotifier.dart';
import '../Utils/AppTheme.dart';
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
          actions: [
            IconButton(
              icon: Image.asset(ImagePaths.appLogo),
              onPressed: () {
                AlertBox.showAlert(
                    context,
                    Text(
                      Strings.areYouSureToClose,
                      style: Theme.of(context).textTheme.titleLarge,
                    ), () {
                  SystemNavigator.pop();
                });
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
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: TabBar(
              tabs: [
                Tab(text: Strings.mcxFutures),
                Tab(text: Strings.nseFutures),
                Tab(text: Strings.others),
              ],
              indicatorColor: goldencolor,
            ),
          ),
        ),
        body: Column(
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
    );
  }

  Widget _buildListView(
      List<StockData> list, BuildContext context, String type) {
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
                            Future.microtask(() => ref
                                .read(watchlistProvider.notifier)
                                .fetchCategoryList(context));
                          });
                        });
                      },
                    )
                  : Center(
                      child: Text(
                        Strings.dataNotAvailable,
                        style: Styles.normalText(context: context),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, String type) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: appColors.color1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
              )),
          7.width,
          Text(Strings.search,
              style: Theme.of(context).textTheme.headlineLarge),
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
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
