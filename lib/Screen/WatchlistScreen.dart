import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/Services/Service_Api.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetLiveDataModel.dart';
import '../Model/GetMCXModel.dart';
import '../Model/LoginModel.dart';
import '../Providerr/providers.dart';
import '../Utils/AppBar.dart';
import '../Utils/AppTheme.dart';
import '../Utils/Colors.dart';
import '../Utils/Themepopup.dart';
import 'LoginScreen.dart';
import 'NSESearch.dart';
import 'PopupScreen.dart';
import 'SearchMCX.dart';
import 'BuyScreen.dart';
import 'SellandBuyScreen.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  Future<List<GetLiveData>>? futureLiveData;
  List<Datum> _categories = [];
  List<Map<String, dynamic>> filteredMCXData = [];
  List<Map<String, dynamic>> filteredNSEData = [];
  Map<String, double> previousBuyPrices = {};
  Map<String, double> previousSellPrices = {};
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    fetchData();
    _startPeriodicRefresh();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchData();
      // fetchLiveData();
    });
  }

  bool _isLoading = true;
  bool _isFirstLoad = true;

  Future<void> fetchData() async {
    if (_isFirstLoad) {
      setState(() {
        _isLoading = true; // Show loading indicator only during the first load
      });
    }
    try {
      // Fetch live data
      final liveDataList = await fetchLiveData();

      // Fetch category list
      await fetchCategoryList();

      // Separate and filter data
      List<Datum> combinedCategories =
          _categories.where((datum) => datum.isChecked == 1).toList();

      List<Map<String, dynamic>> mcxResults = [];
      List<Map<String, dynamic>> nseResults = [];

      for (var datum in combinedCategories) {
        final matchingLiveData = liveDataList.firstWhere(
          (liveData) => liveData.instrumentIdentifier == datum.instrumentToken,
          orElse: () => GetLiveData(), // Provide a default value
        );

        if (matchingLiveData.instrumentIdentifier == datum.instrumentToken) {
          double currentBuyPrice = matchingLiveData.buyPrice ?? 0;
          double currentSellPrice = matchingLiveData.sellPrice ?? 0;
          double previousBuyPrice =
              previousBuyPrices[datum.instrumentToken] ?? 0;
          double previousSellPrice =
              previousSellPrices[datum.instrumentToken] ?? 0;

          String bPriceStatus = currentBuyPrice > previousBuyPrice
              ? '1'
              : currentBuyPrice < previousBuyPrice
                  ? '2'
                  : '0';
          String sPriceStatus = currentSellPrice > previousSellPrice
              ? '1'
              : currentSellPrice < previousSellPrice
                  ? '2'
                  : '0';

          previousBuyPrices[datum.instrumentToken.toString()] = currentBuyPrice;
          previousSellPrices[datum.instrumentToken.toString()] =
              currentSellPrice;

          final priceChange = matchingLiveData.priceChange ?? 0;
          final priceChangePercentage =
              matchingLiveData.priceChangePercentage ?? 0;

          final priceChangeColor = priceChange < 0 ? Colors.red : Colors.green;
          final priceChangePercentageColor =
              priceChangePercentage < 0 ? Colors.red : Colors.green;

          final result = {
            'categoryId': datum.categoryId ?? 'Unknown',
            'identifier': datum.instrumentToken ?? 'Unknown',
            'name': datum.title ?? 'Unknown',
            'expiry': datum.expireDate ?? 0,
            'buyPrice': currentBuyPrice,
            'sellPrice': currentSellPrice,
            'high': matchingLiveData.high ?? 0,
            'low': matchingLiveData.low ?? 0,
            'lastTradePrice': matchingLiveData.lastTradePrice ?? 0,
            'changepricepercent': priceChangePercentage,
            'changeprice': priceChange,
            'bPriceStatus': bPriceStatus,
            'sPriceStatus': sPriceStatus,
            'priceChangeColor': priceChangeColor,
            'priceChangePercentageColor': priceChangePercentageColor,
          };

          if (datum.instrumentType == 'MCX') {
            mcxResults.add(result);
          } else if (matchingLiveData.exchange == 'NFO') {
            nseResults.add(result);
          }
        }
      }

      setState(() {
        filteredMCXData = mcxResults;
        filteredNSEData = nseResults;
        _isLoading = false; // Stop showing the loading indicator
        _isFirstLoad = false; // Set the flag to false after the first load
      });
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<List<GetLiveData>> fetchLiveData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final stdata = prefs.getString('apiToken');

      if (stdata != '' && stdata != null) {
        final loginModel = loginModelFromJson(stdata);
        final token = loginModel.token;

        var responseString = await ServicesApi().get_ApiwithHeader(
            "https://www.onlinetradelearn.com/mcx/authController/getLiveRate?userID=${loginModel.userId}",
            token,
            ref);
        print("responseString:$responseString");
        final jsonResponse = jsonDecode(responseString);
        final List<dynamic> dataList = jsonResponse['livedata'];

        return dataList.map((json) => GetLiveData.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> fetchCategoryList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final stdata = prefs.getString('apiToken');

      if (stdata != '' && stdata != null) {
        final loginModel = loginModelFromJson(stdata);
        final token = loginModel.token;

        String url =
            'https://www.onlinetradelearn.com/mcx/authController/getMcxCategoryList?userID=145';

        final response = await ServicesApi().get_ApiwithHeader(url, token, ref);

        final Map<String, dynamic> jsonData = jsonDecode(response);

        final List<dynamic> dataList = jsonData['data'] ?? [];
        final List<Datum> parsedData = dataList.map((item) {
          return Datum(
            categoryId: item['category_id'],
            title: item['title'],
            expireDate: item['expire_date'],
            instrumentToken: item['instrument_token'],
            instrumentType: item['instrument_type'],
            quotationLot: item['QuotationLot'],
            isChecked: _parseInt(item['is_checked']),
            status: _parseInt(item['status']),
          );
        }).toList();

        setState(() {
          _categories = parsedData;
        });
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
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
              // Replace with your logo image
              onPressed: () {
                //_showDialog(context);
              },
            ),
            Spacer(),
            IconButton(
              icon: Image.asset('assets/theme.png'),
              onPressed: () {
                showThemeSelectionDialog(context, ref);
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: TabBar(
                tabs: [
                  Tab(text: 'MCX Futures'),
                  Tab(text: 'NSE Futures'),
                  Tab(text: 'Others'),
                ],
                labelStyle: TextStyle(
                  fontSize: 12.0, // Size for selected tab
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 12.0, // Size for unselected tabs
                ),
                labelColor: Theme.of(context).tabBarTheme.labelColor,
                unselectedLabelColor:
                    Theme.of(context).tabBarTheme.unselectedLabelColor,
                indicatorColor: goldencolor,
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.white12,
          child: Column(
            children: [
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              color: containerColor,
                              // Light theme
                              //  Theme.of(context).brightness == Brightness.light ? ? Colors.white  // Light theme
                              // : Colors.blueGrey,
                              height: 40,
                              width: MediaQuery.of(context).size.width * 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.search)),
                                    7.width,
                                    Text("Search & Add",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              )).onTap(() {
                            SearchMCXScreen().launch(context);
                          }),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: _isLoading
                                ? Center(
                                    child: Image.asset('assets/loader.png'),
                                  )
                                : filteredMCXData.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: filteredMCXData.length,
                                        itemBuilder: (context, index) {
                                          final data = filteredMCXData[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(data['name'],
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                            "${data['expiry']}",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Chg:${data['changeprice']}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            8,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: data[
                                                                            'priceChangeColor']),
                                                                  ),
                                                                  Text(
                                                                    "(${data['changepricepercent']}%)",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            8,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: data[
                                                                            'priceChangePercentageColor']),
                                                                  ),
                                                                ],
                                                              ),
                                                              25.width,
                                                              Row(children: [
                                                                Text(
                                                                  "High:${data['high']}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ])
                                                            ],
                                                          ),
                                                        ]),
                                                  ],
                                                ),

                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          20.height,
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: data['bPriceStatus'] ==
                                                                            '1'
                                                                        ? Colors
                                                                            .green
                                                                        : data['bPriceStatus'] ==
                                                                                '2'
                                                                            ? Colors
                                                                                .red
                                                                            : Colors
                                                                                .transparent,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Text(
                                                              "${data['buyPrice']}",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(
                                                            "Low:${data['low']}",
                                                            style: TextStyle(
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ]),
                                                  ],
                                                ),
                                                Spacer(),
                                                Row(children: [
                                                  Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        20.height,
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  right: 8),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: data['sPriceStatus'] ==
                                                                          '1'
                                                                      ? Colors
                                                                          .green
                                                                      : data['sPriceStatus'] ==
                                                                              '2'
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .transparent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                          child: Text(
                                                            "${data['sellPrice']}",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        20.width,
                                                        Text(
                                                          "LTP:${data['lastTradePrice']}",
                                                          style: TextStyle(
                                                              fontSize: 9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ]),
                                                ]),

                                                // Column(
                                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                                //   children: [
                                                //     // Text(data['identifier'], style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                                //     Text(data['name'], style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                                //     Row(
                                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //       children: [
                                                //         Text("${data['expiry']}",
                                                //           style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                //         40.width,
                                                //         Container(
                                                //           decoration: BoxDecoration(
                                                //               color: data['bPriceStatus'] == '1'
                                                //                   ? Colors.green
                                                //                   : data['bPriceStatus'] == '2'
                                                //                   ? Colors.red
                                                //                   : Colors.transparent,
                                                //               borderRadius: BorderRadius.circular(5)
                                                //           ),
                                                //           padding: EdgeInsets.only(left:8, right:8),
                                                //
                                                //           child: Text(
                                                //             "${data['buyPrice']}",
                                                //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                //           ),
                                                //         ),
                                                //         Container(
                                                //           padding: EdgeInsets.only(left:8, right:8),
                                                //           decoration: BoxDecoration(
                                                //               color: data['sPriceStatus'] == '1'
                                                //                   ? Colors.green
                                                //                   : data['sPriceStatus'] == '2'
                                                //                   ? Colors.red
                                                //                   : Colors.transparent,
                                                //               borderRadius: BorderRadius.circular(5)
                                                //           ),
                                                //           child: Text(
                                                //             "${data['sellPrice']}",
                                                //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                //           ),
                                                //         ),
                                                //
                                                //       ],
                                                //     ),
                                                //     Row(
                                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //       children: [
                                                //         Row(
                                                //           children: [
                                                //             Text("Chg:${data['changeprice']}",
                                                //               style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,
                                                //                   color: data['priceChangeColor']),),
                                                //             Text("(${data['changepricepercent']}%)",
                                                //               style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,
                                                //                   color: data['priceChangePercentageColor']),),
                                                //
                                                //           ],
                                                //         ),
                                                //         Text("High:${data['high']}",
                                                //           style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                //         Text("Low:${data['low']}",
                                                //           style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                //         Text("LTP:${data['lastTradePrice']}",
                                                //           style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                //       ],
                                                //     ),
                                                //     Divider(
                                                //         color:Colors.black
                                                //     )
                                                //   ],
                                                // ).onTap(()async {
                                                //   print("Tapped!");
                                                //   await Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //       builder: (context) => BuyScreen(
                                                //         categoryId: data['categoryId'] ?? 'N/A',
                                                //         identifier: data['identifier'] ?? 'N/A',
                                                //         title: data['name'] ?? 'N/A',
                                                //         expiryDate: data['expiry'] ?? 'N/A',
                                                //         buyprice: data['buyPrice'],
                                                //         sellprice: data['sellPrice'],
                                                //       ),
                                                //     ),
                                                //   );
                                                //   print("qqqqqqqqqqqqqqqqqqqqqqqqq!");
                                                // }
                                                // ),
                                              ],
                                            ).onTap(() async {
                                              print("Tapped!");
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BuyScreen(
                                                    categoryId:
                                                        data['categoryId'] ??
                                                            'N/A',
                                                    identifier:
                                                        data['identifier'] ??
                                                            'N/A',
                                                    title:
                                                        data['name'] ?? 'N/A',
                                                    expiryDate:
                                                        data['expiry'] ?? 'N/A',
                                                    buyprice: data['buyPrice'],
                                                    sellprice:
                                                        data['sellPrice'],
                                                  ),
                                                ),
                                              );
                                              print(
                                                  "qqqqqqqqqqqqqqqqqqqqqqqqq!");
                                            }),
                                          );
                                        },
                                      )
                                    : Center(
                                        child: Text('No data available'),
                                      ),
                          ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                              color: Colors.white,
                              height: 50,
                              width: MediaQuery.of(context).size.width * 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 8),
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {},
                                        icon: Icon(Icons.search)),
                                    10.width,
                                    Text("Search & Add",
                                        style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )).onTap(() {
                            SearchNSEScreen().launch(context);
                          }),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: _isLoading
                                ? Center(
                                    child: Image.asset('assets/loader.png'),
                                  )
                                : filteredNSEData.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: filteredNSEData.length,
                                        itemBuilder: (context, index) {
                                          final data = filteredNSEData[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(data['name'],
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                            "${data['expiry']}",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "Chg:${data['changeprice']}",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            8,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: data[
                                                                            'priceChangeColor']),
                                                                  ),
                                                                  Text(
                                                                    "(${data['changepricepercent']}%)",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            8,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: data[
                                                                            'priceChangePercentageColor']),
                                                                  ),
                                                                ],
                                                              ),
                                                              25.width,
                                                              Row(children: [
                                                                Text(
                                                                  "High:${data['high']}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          9,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ])
                                                            ],
                                                          ),
                                                        ]),
                                                  ],
                                                ),

                                                Spacer(),
                                                Row(
                                                  children: [
                                                    Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          20.height,
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: data['bPriceStatus'] ==
                                                                            '1'
                                                                        ? Colors
                                                                            .green
                                                                        : data['bPriceStatus'] ==
                                                                                '2'
                                                                            ? Colors
                                                                                .red
                                                                            : Colors
                                                                                .transparent,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8,
                                                                    right: 8),
                                                            child: Text(
                                                              "${data['buyPrice']}",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          Text(
                                                            "Low:${data['low']}",
                                                            style: TextStyle(
                                                                fontSize: 9,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ]),
                                                  ],
                                                ),
                                                Spacer(),
                                                Row(children: [
                                                  Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        20.height,
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8,
                                                                  right: 8),
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: data['sPriceStatus'] ==
                                                                          '1'
                                                                      ? Colors
                                                                          .green
                                                                      : data['sPriceStatus'] ==
                                                                              '2'
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .transparent,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5)),
                                                          child: Text(
                                                            "${data['sellPrice']}",
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                        20.width,
                                                        Text(
                                                          "LTP:${data['lastTradePrice']}",
                                                          style: TextStyle(
                                                              fontSize: 9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ]),
                                                ]),

                                                // Column(
                                                //   crossAxisAlignment: CrossAxisAlignment.start,
                                                //   children: [
                                                //     // Text(data['identifier'], style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                                //     Text(data['name'], style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                                                //     Row(
                                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //       children: [
                                                //         Text("${data['expiry']}",
                                                //           style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                //         40.width,
                                                //         Container(
                                                //           decoration: BoxDecoration(
                                                //               color: data['bPriceStatus'] == '1'
                                                //                   ? Colors.green
                                                //                   : data['bPriceStatus'] == '2'
                                                //                   ? Colors.red
                                                //                   : Colors.transparent,
                                                //               borderRadius: BorderRadius.circular(5)
                                                //           ),
                                                //           padding: EdgeInsets.only(left:8, right:8),
                                                //
                                                //           child: Text(
                                                //             "${data['buyPrice']}",
                                                //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                //           ),
                                                //         ),
                                                //         Container(
                                                //           padding: EdgeInsets.only(left:8, right:8),
                                                //           decoration: BoxDecoration(
                                                //               color: data['sPriceStatus'] == '1'
                                                //                   ? Colors.green
                                                //                   : data['sPriceStatus'] == '2'
                                                //                   ? Colors.red
                                                //                   : Colors.transparent,
                                                //               borderRadius: BorderRadius.circular(5)
                                                //           ),
                                                //           child: Text(
                                                //             "${data['sellPrice']}",
                                                //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                //           ),
                                                //         ),
                                                //
                                                //       ],
                                                //     ),
                                                //     Row(
                                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                //       children: [
                                                //         Row(
                                                //           children: [
                                                //             Text("Chg:${data['changeprice']}",
                                                //               style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,
                                                //                   color: data['priceChangeColor']),),
                                                //             Text("(${data['changepricepercent']}%)",
                                                //               style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,
                                                //                   color: data['priceChangePercentageColor']),),
                                                //
                                                //           ],
                                                //         ),
                                                //         Text("High:${data['high']}",
                                                //           style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                //         Text("Low:${data['low']}",
                                                //           style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                //         Text("LTP:${data['lastTradePrice']}",
                                                //           style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),
                                                //       ],
                                                //     ),
                                                //     Divider(
                                                //         color:Colors.black
                                                //     )
                                                //   ],
                                                // ).onTap(()async {
                                                //   print("Tapped!");
                                                //   await Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //       builder: (context) => BuyScreen(
                                                //         categoryId: data['categoryId'] ?? 'N/A',
                                                //         identifier: data['identifier'] ?? 'N/A',
                                                //         title: data['name'] ?? 'N/A',
                                                //         expiryDate: data['expiry'] ?? 'N/A',
                                                //         buyprice: data['buyPrice'],
                                                //         sellprice: data['sellPrice'],
                                                //       ),
                                                //     ),
                                                //   );
                                                //   print("qqqqqqqqqqqqqqqqqqqqqqqqq!");
                                                // }
                                                // ),
                                              ],
                                            ),
                                          ).onTap(() async {
                                            print("Tapped!");
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => BuyScreen(
                                                  categoryId:
                                                      data['categoryId'] ??
                                                          'N/A',
                                                  identifier:
                                                      data['identifier'] ??
                                                          'N/A',
                                                  title: data['name'] ?? 'N/A',
                                                  expiryDate:
                                                      data['expiry'] ?? 'N/A',
                                                  buyprice: data['buyPrice'],
                                                  sellprice: data['sellPrice'],
                                                ),
                                              ),
                                            );
                                            print("qqqqqqqqqqqqqqqqqqqqqqqqq!");
                                          });
                                        },
                                      )
                                    : Center(
                                        child: Text('No data available'),
                                      ),
                          ),
                        ],
                      ),
                    ),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Please come here later.\n Soon some craziness will be come here",
                          style: TextStyle(fontSize: 20),
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
