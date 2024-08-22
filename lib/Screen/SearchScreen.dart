import 'dart:async';
import 'package:flutter/material.dart';
import 'package:me_app/CommonWidget/TradeStock.dart';
import 'package:me_app/Model/StatusMessage.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:nb_utils/nb_utils.dart';
import '../ApiService/ApiInterface.dart';
import '../Model/GetLiveDataModel.dart';
import '../Model/GetMCXModel.dart';
import '../Model/LiveRate.dart';
import '../Resources/Strings.dart';
import '../Utils/HelperFunction.dart';

class Searchscreen extends StatefulWidget {
  String type;

  Searchscreen({super.key, required this.type});

  @override
  State<Searchscreen> createState() => _SearchscreenState();
}

class _SearchscreenState extends State<Searchscreen> {
  final TextEditingController _searchController = TextEditingController();
  var _isLoading = true;
  Future<List<GetLiveData>>? futureLiveData;
  late List<Datum> initialData;
  late List<Datum> list;
  Timer? _refreshTimer;

  Future<void> fetchData() async {
    final response = await ApiInterface.getLiveRate(context);
    list = list.where((item) {
      return response!.livedata!.any(
          (liveRate) => liveRate.instrumentIdentifier == item.instrumentToken);
    }).map((item) {
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
    list = initialData.where((Datum data) {
      return data.instrumentType == widget.type;
    }).toList();
    setState(() {
      _isLoading = false;
    });
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (await HelperFunction.isInternetConnected(context) &&
          initialData.isNotEmpty) {
        fetchData();
      } else if (await HelperFunction.isInternetConnected(context)) {
        fetchCategoryList();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategoryList();
    _startPeriodicRefresh();
  }

  void searchStock(String query) {
    setState(() {
      list = initialData
          .where((item) =>
              item.title
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) &&
              widget.type == item.instrumentType)
          .toList();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      body: _isLoading
          ? Center(
              child: Image.asset('assets/loader.png'),
            )
          : list.isNotEmpty
              ? ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final data = list[index];
                    return Tradestock(
                      data: data,
                      showCheckUncheck: true,
                    ).onTap(() {
                      addToWatchList(
                          data.categoryId.toString(), data.isChecked!, index);
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

  Future<void> addToWatchList(
      String categoryId, int isChecked, int index) async {
    StatusMessage? response = await ApiInterface.addToWatchList(
        context, categoryId, isChecked == 1 ? 0 : 1);
    if (response!.status == 1) {
      setState(() {
        list[index].isChecked = isChecked == 1 ? 0 : 1;
      });
    } else {
      HelperFunction.showMessage(context, response.message!, type: 3);
    }
  }
}
