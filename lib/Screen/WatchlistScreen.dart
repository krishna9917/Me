import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import 'package:me_app/CommonWidget/TradeStock.dart';
import 'package:me_app/Model/LiveRate.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:me_app/Screen/BuyScreen.dart';
import 'package:me_app/Screen/SearchScreen.dart';
import 'package:me_app/Screen/StockDetailScreen.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetMCXModel.dart';
import '../Resources/Strings.dart';
import '../Utils/AppTheme.dart';
import '../Utils/Colors.dart';
import '../Utils/HelperFunction.dart';
import '../Utils/Themepopup.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  List<Livedata>? futureLiveData;
  late List<Datum> initialData;
  late List<Datum> mcxList;
  late List<Datum> nseList;
  bool _isLoading = true;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    fetchCategoryList();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (mounted) {
        if (await HelperFunction.isInternetConnected(context) &&
            initialData.isNotEmpty) {
          fetchData();
        } else if (await HelperFunction.isInternetConnected(context)) {
          fetchCategoryList();
        }
      } else {
        _refreshTimer?.cancel();
      }
    });
  }

  Future<void> fetchData() async {
    final response = await ApiInterface.getLiveRate(context);
    mcxList = mcxList.where((item) {
      // Check if any item in response.livedata matches the condition
      return response!.livedata!.any(
          (liveRate) => liveRate.instrumentIdentifier == item.instrumentToken);
    }).map((item) {
      // Find the matching liveRate from response.livedata
      final matchingLiveRate = response!.livedata!.firstWhere(
        (liveRate) => liveRate.instrumentIdentifier == item.instrumentToken,
      );
      item.priceChange = matchingLiveRate.priceChange;
      item.low = matchingLiveRate.low;
      item.lastTradePrice = matchingLiveRate.lastTradePrice;
      item.high = matchingLiveRate.high;
      item.priceChangeColor =
          item.priceChangePercentage! > 0 ? Colors.green : Colors.red;
      item.buyPriceColor = item.buyPrice! < matchingLiveRate.buyPrice!
          ? Colors.green
          : item.buyPrice! == matchingLiveRate.buyPrice!
              ? Colors.transparent
              : Colors.red;
      item.salePriceColor = item.salePrice! < matchingLiveRate.sellPrice!
          ? Colors.green
          : item.salePrice! == matchingLiveRate.sellPrice!
              ? Colors.transparent
              : Colors.red;
      item.priceChangePercentage = matchingLiveRate.priceChangePercentage;
      item.buyPrice = matchingLiveRate.buyPrice;
      item.salePrice = matchingLiveRate.sellPrice;
      return item;
    }).toList();

    nseList = nseList.where((item) {
      // Check if any item in response.livedata matches the condition
      return response!.livedata!.any(
          (liveRate) => liveRate.instrumentIdentifier == item.instrumentToken);
    }).map((item) {
      // Find the matching liveRate from response.livedata
      final matchingLiveRate = response!.livedata!.firstWhere(
        (liveRate) => liveRate.instrumentIdentifier == item.instrumentToken,
      );
      item.priceChange = matchingLiveRate.priceChange;
      item.low = matchingLiveRate.low;
      item.lastTradePrice = matchingLiveRate.lastTradePrice;
      item.high = matchingLiveRate.high;
      item.priceChangeColor =
          item.priceChangePercentage! > 0 ? Colors.green : Colors.red;
      item.buyPriceColor = item.buyPrice! < matchingLiveRate.buyPrice!
          ? Colors.green
          : item.buyPrice! == matchingLiveRate.buyPrice!
              ? Colors.transparent
              : Colors.red;
      item.salePriceColor = item.salePrice! < matchingLiveRate.sellPrice!
          ? Colors.green
          : item.salePrice! == matchingLiveRate.sellPrice!
              ? Colors.transparent
              : Colors.red;
      item.priceChangePercentage = matchingLiveRate.priceChangePercentage;
      item.buyPrice = matchingLiveRate.buyPrice;
      item.salePrice = matchingLiveRate.sellPrice;
      return item;
    }).toList();
    setState(() {});
  }

  Future<void> fetchCategoryList() async {
    final response = await ApiInterface.getStockList(context);
    initialData = response!.data!;
    mcxList = initialData.where((Datum data) {
      return data.instrumentType == "MCX" && data.isChecked == 1;
    }).toList();
    nseList = initialData.where((Datum data) {
      return data.instrumentType == "NSE" && data.isChecked == 1;
    }).toList();
    setState(() {
      _isLoading = false;
    });
    _startPeriodicRefresh();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>();

    // Check if the theme is golden by comparing color1 to Colors.amber
    final isGoldenTheme = appColors?.color1 == Colors.amber;

    // Determine the container color
    final containerColor =
        isGoldenTheme || Theme.of(context).brightness == Brightness.dark
            ? Colors.blueGrey[900] // Use blue-grey for golden and dark themes
            : Colors.white; // Use white for light theme

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: Image.asset('assets/logo.png'),
              onPressed: () {
                //_showDialog(context);
              },
            ),
            const Spacer(),
            IconButton(
              icon: Image.asset('assets/theme.png'),
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
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              color: Colors.white,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.search)),
                                  7.width,
                                  Text(Strings.search,
                                      style: Styles.normalText(
                                          isBold: true, fontSize: 12)),
                                ],
                              )).onTap(() {
                            Searchscreen(
                              type: "MCX",
                            ).launch(context).then((data) {
                              fetchCategoryList();
                            });
                          }),
                          10.height,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: _isLoading
                                  ? Center(
                                      child: Image.asset('assets/loader.png'),
                                    )
                                  : mcxList.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: mcxList.length,
                                          itemBuilder: (context, index) {
                                            final data = mcxList[index];
                                            return Tradestock(data: data)
                                                .onTap(() {
                                                  StockDetailScreen(stockData: data).launch(context);
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
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              color: Colors.white,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.search)),
                                  7.width,
                                  Text(Strings.search,
                                      style: Styles.normalText(
                                          isBold: true, fontSize: 12)),
                                ],
                              )).onTap(() {
                            Searchscreen(
                              type: "NSE",
                            ).launch(context).then((data) {
                              fetchCategoryList();
                            });
                          }),
                          10.height,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: _isLoading
                                  ? Center(
                                      child: Image.asset('assets/loader.png'),
                                    )
                                  : nseList.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: nseList.length,
                                          itemBuilder: (context, index) {
                                            final data = nseList[index];
                                            return Tradestock(data: data)
                                                .onTap(() {
                                              BuyScreen(
                                                      categoryId: data
                                                          .categoryId
                                                          .toString(),
                                                      title:
                                                          data.title.toString(),
                                                      expiryDate: data
                                                          .expireDate
                                                          .toString(),
                                                      buyPrice: data.buyPrice
                                                              ?.toDouble() ??
                                                          0.0,
                                                      sellPrice: data.salePrice
                                                              ?.toDouble() ??
                                                          0.0,
                                                      identifier: data
                                                          .instrumentToken
                                                          .toString())
                                                  .launch(context);
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
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            Strings.comingSoonMsg,
                            style:
                                Styles.normalText(fontSize: 20, isBold: true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
