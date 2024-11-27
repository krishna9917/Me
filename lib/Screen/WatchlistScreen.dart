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
import '../ApiService/ApiInterface.dart';
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
  late final AppLifecycleListener lifecycleListener;

  @override
  void initState() {
    lifecycleListener =
        AppLifecycleListener(onStateChange: _onLifeCycleChanged);
    super.initState();
    Future.microtask(
        () => ref.read(watchlistProvider.notifier).fetchCategoryList(context));
  }

  @override
  void dispose() {
    lifecycleListener.dispose();
    super.dispose();
  }

  void _onLifeCycleChanged(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        ref.read(watchlistProvider.notifier).stopPeriodicRefresh();
        break;
      case AppLifecycleState.resumed:
        ref.read(watchlistProvider.notifier).startPeriodicRefresh(context);
        break;
      default:
        break;
    }
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
                      padding: EdgeInsets.only(bottom: 40),
                      itemBuilder: (context, index) {
                        final data = list[index];
                        return Tradestock(data: data).onTap(() {
                          gotoDetailPage(data);
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

  Future<void> gotoDetailPage(StockData data) async {
    final response = await ApiInterface.getLiveRate(context,
        token: data.instrumentToken.toString(), showLoading: true);
    StockDetailScreen(stockData: data,data: response!.livedata!.first,)
        .launch(context)
        .then((b) {
      Future.microtask(() => ref
          .read(watchlistProvider.notifier)
          .fetchCategoryList(context));
    });
  }
}
