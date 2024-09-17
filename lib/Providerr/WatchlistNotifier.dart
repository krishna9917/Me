import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import 'package:me_app/Model/LiveRate.dart';
import 'package:me_app/Model/GetMCXModel.dart';
import 'package:me_app/Utils/HelperFunction.dart';

class WatchlistState {
  final List<StockData> mcxList;
  final List<StockData> nseList;

  WatchlistState({
    required this.mcxList,
    required this.nseList,
  });
}

class WatchlistNotifier extends StateNotifier<WatchlistState> {
  WatchlistNotifier()
      : super(WatchlistState(
    mcxList: [],
    nseList: [],
  ));

  Timer? _refreshTimer;

  // Method to start periodic refresh
  void startPeriodicRefresh(BuildContext context) {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (await HelperFunction.isInternetConnected(context)) {
        await fetchData(context);
      }
    });
  }

  // Method to stop periodic refresh
  void stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> fetchCategoryList(BuildContext context) async {
    final response =
    await ApiInterface.getStockList(context, showLoading: true);
    if (response!.status == 1) {
      final List<StockData> initialData = response.data!;
      final mcxList = initialData.where((StockData data) {
        return data.instrumentType == "MCX" && data.isChecked == 1;
      }).toList();
      final nseList = initialData.where((StockData data) {
        return data.instrumentType == "NSE" && data.isChecked == 1;
      }).toList();
      state = WatchlistState(mcxList: mcxList, nseList: nseList);
      startPeriodicRefresh(context);
    }
  }

  Future<void> fetchData(BuildContext context) async {
    final response = await ApiInterface.getLiveRate(context);
    if (response != null && response.livedata != null) {
      final updatedMcxList = state.mcxList.map((item) {
        final matchingLiveRate = response.livedata!.firstWhere(
              (liveRate) => liveRate.instrumentIdentifier == item.instrumentToken,
          orElse: () => Livedata(), // Handle no match found
        );
        return item.copyWith(
          priceChange: matchingLiveRate.priceChange,
          low: matchingLiveRate.low,
          lastTradePrice: matchingLiveRate.lastTradePrice,
          high: matchingLiveRate.high,
          priceChangePercentage: matchingLiveRate.priceChangePercentage,
          buyPrice: matchingLiveRate.buyPrice,
          salePrice: matchingLiveRate.sellPrice,
          priceChangeColor: matchingLiveRate.priceChangePercentage! > 0
              ? Colors.green
              : Colors.red,
          buyPriceColor: item.buyPrice! < matchingLiveRate.buyPrice!
              ? Colors.green
              : item.buyPrice! == matchingLiveRate.buyPrice!
              ? Colors.transparent
              : Colors.red,
          salePriceColor: item.salePrice! < matchingLiveRate.sellPrice!
              ? Colors.green
              : item.salePrice! == matchingLiveRate.sellPrice!
              ? Colors.transparent
              : Colors.red,
        );
      }).toList();

      final updatedNseList = state.nseList.map((item) {
        final matchingLiveRate = response.livedata!.firstWhere(
              (liveRate) => liveRate.instrumentIdentifier == item.instrumentToken,
          orElse: () => Livedata(), // Handle no match found
        );
        return item.copyWith(
          priceChange: matchingLiveRate.priceChange,
          low: matchingLiveRate.low,
          lastTradePrice: matchingLiveRate.lastTradePrice,
          high: matchingLiveRate.high,
          priceChangePercentage: matchingLiveRate.priceChangePercentage,
          buyPrice: matchingLiveRate.buyPrice,
          salePrice: matchingLiveRate.sellPrice,
          priceChangeColor: matchingLiveRate.priceChangePercentage! > 0
              ? Colors.green
              : Colors.red,
          buyPriceColor: item.buyPrice! < matchingLiveRate.buyPrice!
              ? Colors.green
              : item.buyPrice! == matchingLiveRate.buyPrice!
              ? Colors.transparent
              : Colors.red,
          salePriceColor: item.salePrice! < matchingLiveRate.sellPrice!
              ? Colors.green
              : item.salePrice! == matchingLiveRate.sellPrice!
              ? Colors.transparent
              : Colors.red,
        );
      }).toList();
      state = WatchlistState(mcxList: updatedMcxList, nseList: updatedNseList);
    }
  }

  @override
  void dispose() {
    stopPeriodicRefresh();
    super.dispose();
  }
}

final watchlistProvider =
StateNotifierProvider<WatchlistNotifier, WatchlistState>(
      (ref) => WatchlistNotifier(),
);
