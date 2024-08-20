import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/Services/Service_Api.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetLiveDataModel.dart';
import '../Model/GetMCXModel.dart';
import '../Resources/Strings.dart';
import '../Utils/Colors.dart';

class SearchNSEScreen extends ConsumerStatefulWidget {
  @override
  _SearchNSEScreenState createState() => _SearchNSEScreenState();
}

class _SearchNSEScreenState extends ConsumerState<SearchNSEScreen> {
  List<Map<String, dynamic>> filteredMCXData = [];
  List<Map<String, dynamic>> filteredNSEData = [];
  List<Map<String, dynamic>> _filteredItems = [];
  Map<String, double> previousBuyPrices = {};
  Map<String, double> previousSellPrices = {};
  List<Datum> _categories = [];
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _startPeriodicRefresh();
    fetchDataAndRemoveToken();
    fetchData();
  }

  Future<void> fetchData() async {
    if (_isFirstLoad) {
      setState(() {
        _isLoading = true; // Show loading indicator only during the first load
      });
    }
    try {
      final liveDataList = await fetchLiveData();
      await fetchCategoryList();

      // Combine checked and unchecked categories
      List<Datum> allCategories = [..._categories];

      // Sort the combined list alphabetically by the 'title' field
      allCategories.sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));

      List<Map<String, dynamic>> mcxResults = [];
      List<Map<String, dynamic>> nseResults = [];

      void processData(Datum datum) {
        final matchingLiveData = liveDataList.firstWhere(
          (liveData) => liveData.instrumentIdentifier == datum.instrumentToken,
          orElse: () => GetLiveData(),
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
            'categoryID': datum.categoryId ?? 0,
            'name': datum.title ?? 'Unknown',
            'expiry': datum.expireDate ?? 0,
            'buyPrice': matchingLiveData.buyPrice ?? 0,
            'sellPrice': matchingLiveData.sellPrice ?? 0,
            'high': matchingLiveData.high ?? 0,
            'low': matchingLiveData.low ?? 0,
            'lastTradePrice': matchingLiveData.lastTradePrice ?? 0,
            'changepricepercent': matchingLiveData.priceChangePercentage ?? 0,
            'changeprice': matchingLiveData.priceChange ?? 0,
            'isChecked': datum.isChecked ?? 0,
            'lotsize': matchingLiveData.quotationLot ?? 0,
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

      // Process all categories
      for (var datum in allCategories) {
        processData(datum);
      }

      setState(() {
        filteredMCXData = mcxResults;
        filteredNSEData = nseResults;
        _filteredItems = filteredNSEData; // Initialize with NSE data
        _isLoading = false;
        _isFirstLoad = false;
      });
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<List<GetLiveData>> fetchLiveData() async {
    try {
      // final loginModel = loginModelFromJson(stdata);
      // final token = loginModel.token;
      //
      // if (token != null && token.isNotEmpty) {
      var responseString = await ServicesApi().get_ApiwithHeader(
          "https://www.onlinetradelearn.com/mcx/authController/getLiveRate?userID=145",
          ref);

      final jsonResponse = jsonDecode(responseString);
      final List<dynamic> dataList = jsonResponse['livedata'];

      return dataList.map((json) => GetLiveData.fromJson(json)).toList();
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<void> fetchCategoryList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final stdata = prefs.getString('apiToken');

      if (stdata != '' && stdata != null) {
        String url =
            'https://www.onlinetradelearn.com/mcx/authController/getMcxCategoryList?userID=${sharedPreferences.getString(Strings.USER_ID).toString()}';

        final response = await ServicesApi().get_ApiwithHeader(url, ref);

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

  void _filterItems(String query) {
    setState(() {
      _filteredItems = filteredNSEData
          .where((item) => item['name']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  Timer? _refreshTimer;

  int? categoryId;
  int? isChecked;
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      fetchDataAndRemoveToken();
      fetchData();
    });
  }

  Future<void> fetchDataAndRemoveToken() async {
    await fetchData(); // Ensure fetchData completes

    if (_categories.isNotEmpty) {
      // Safely access the first item
      final firstCategory = _categories.first;
      final int? categoryId = _parseInt(firstCategory.categoryId);
      final int? isChecked = _parseInt(firstCategory.isChecked);

      if (categoryId != null && isChecked != null) {
        await RemoveToken(categoryId, isChecked);
      } else {
        print('Category ID or Is Checked value is null.');
      }
    } else {
      print('No categories available.');
    }
  }

  Future<void> RemoveToken(int categoryId, int isChecked) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final stdata = prefs.getString('apiToken');

      if (stdata != '' && stdata != null) {
        String url =
            'https://www.onlinetradelearn.com/mcx/authController/addUserWatchList?userID=${sharedPreferences.getString(Strings.USER_ID).toString()}&category_id=$categoryId&ischecked=$isChecked';

        final response = await ServicesApi().get_ApiwithHeader(url, ref);
        print('Response : $response');
      } else {
        print('No API token found.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            controller: _searchController,
            onChanged: _filterItems,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search & Add',
              hintStyle: TextStyle(color: Colors.white, fontSize: 12),
              border: InputBorder.none,
            ),
          ),
          // automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
        ),
        body: _isLoading
            ? Center(
                child: Image.asset('assets/loader.png'),
              )
            : _filteredItems.isNotEmpty // Check if there's data to display
                ? ListView.builder(
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final data = _filteredItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['name'],
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.only(left: 0, right: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${data['expiry']}",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  // 40.width,
                                  Container(
                                    decoration: BoxDecoration(
                                        color: data['bPriceStatus'] == '1'
                                            ? Colors.green
                                            : data['bPriceStatus'] == '2'
                                                ? Colors.red
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    child: Text(
                                      "${data['buyPrice']}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    decoration: BoxDecoration(
                                        color: data['sPriceStatus'] == '1'
                                            ? Colors.green
                                            : data['sPriceStatus'] == '2'
                                                ? Colors.red
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      "${data['sellPrice']}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // CheckboxTheme(
                                  //   data: CheckboxThemeData(
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(4.0),
                                  //     ),
                                  //     fillColor: MaterialStateProperty.resolveWith((states) {
                                  //       if (states.contains(MaterialState.selected)) {
                                  //         return green; // Checked fill color
                                  //       }
                                  //       return lightgreen; // Unchecked fill color
                                  //     }),
                                  //     side: MaterialStateBorderSide.resolveWith((states) => BorderSide(
                                  //       width: 1.0,
                                  //       color: Colors.green, // Border color
                                  //     )),
                                  //     visualDensity: VisualDensity.adaptivePlatformDensity,
                                  //   ),
                                  //   child: Transform.scale(
                                  //     scale: 1.5, // Scale factor to increase the size
                                  //     child: Checkbox(
                                  //       //activeColor: Colors.green,
                                  //       value: data['isChecked'] == 1, // Determine if the checkbox should be checked
                                  //       onChanged: (bool? value) {
                                  //         setState(() {
                                  //           data['isChecked'] = value == true ? 1 : 0;
                                  //           print('Updated Data Map: $data');
                                  //           int? categoryId = _parseInt(data['categoryID']);
                                  //           print("categoryID:$categoryId");
                                  //           if (categoryId != null) {
                                  //             RemoveToken(categoryId, data['isChecked']);
                                  //             print("333333333333");
                                  //             print("removetoken changed value:${RemoveToken(categoryId, data['isChecked'])}");
                                  //           } else {
                                  //             print('Category ID is null');
                                  //           }
                                  //         });
                                  //       },
                                  //       visualDensity: VisualDensity.compact,
                                  //       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  //     ),
                                  //   ),
                                  // ),
                                  CheckboxTheme(
                                    data: CheckboxThemeData(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return green; // Checked fill color
                                        }
                                        return lightgreen; // Unchecked fill color
                                      }),
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => BorderSide(
                                          width: 1.0,
                                          color: Colors.green, // Border color
                                        ),
                                      ),
                                      visualDensity:
                                          VisualDensity.adaptivePlatformDensity,
                                    ),
                                    child: Transform.scale(
                                      scale:
                                          1.5, // Scale factor to increase the size
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            data['isChecked'] =
                                                data['isChecked'] == 1 ? 0 : 1;
                                            print('Updated Data Map: $data');
                                            int? categoryId =
                                                _parseInt(data['categoryID']);
                                            print("categoryID:$categoryId");
                                            if (categoryId != null) {
                                              RemoveToken(categoryId,
                                                  data['isChecked']);
                                              print("333333333333");
                                              print(
                                                  "removetoken changed value:${RemoveToken(categoryId, data['isChecked'])}");
                                            } else {
                                              print('Category ID is null');
                                            }
                                          });
                                        },
                                        child: Image.asset(
                                          data['isChecked'] == 1
                                              ? 'assets/checked.png' // Replace with the path to your checked image
                                              : 'assets/unchecked.png',
                                          // Replace with the path to your unchecked image
                                          width: 20.0,
                                          // Adjust the size of the image as needed
                                          height: 20.0,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Lot Size:${data['lotsize']}",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Text("Chg:${data['changeprice']}",
                                    //   style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,
                                    //       color: data['priceChangeColor']),),
                                    // Text("(${data['changepricepercent']}%)",
                                    //   style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,
                                    //       color: data['priceChangePercentageColor']),),
                                  ],
                                ),
                                Text(
                                  "High:${data['high']}",
                                  style: TextStyle(
                                      fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Low:${data['low']}",
                                  style: TextStyle(
                                      fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "LTP:${data['lastTradePrice']}",
                                  style: TextStyle(
                                      fontSize: 8, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text('No data available'), // Fallback if no data
                  ),
      ),
    );
  }
}
