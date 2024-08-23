import 'package:flutter/material.dart';
import 'package:me_app/Model/LiveRate.dart';
import 'package:riverpod/riverpod.dart';
import '../ApiService/ApiInterface.dart';
import '../Model/GetMCXModel.dart';
import '../Model/StatusMessage.dart';
import '../Utils/HelperFunction.dart';

class SearchState {
  final List<StockData> initialData;
  final List<StockData> list;

  SearchState({
    required this.initialData,
    required this.list,
  });

  SearchState copyWith({
    List<StockData>? initialData,
    List<StockData>? list,
  }) {
    return SearchState(
      initialData: initialData ?? this.initialData,
      list: list ?? this.list,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final String type;

  SearchNotifier(this.type) : super(SearchState(initialData: [], list: []));

  Future<void> fetchCategoryList(BuildContext context) async {
    final response =
        await ApiInterface.getStockList(context, showLoading: true);
    final data = response!.data!;
    state = state.copyWith(
      initialData: data,
      list: data.where((StockData data) => data.instrumentType == type).toList(),
    );
  }

  Future<void> fetchData(BuildContext context) async {
    final response = await ApiInterface.getLiveRate(context);
    final updatedList = state.list.map((item) {
      final matchingLiveRate = response!.livedata!.firstWhere(
        (liveRate) => liveRate.instrumentIdentifier == item.instrumentToken,
        orElse: () => Livedata(),
      );
      item = item.copyWith(
        priceChange: matchingLiveRate.priceChange,
        low: matchingLiveRate.low,
        lastTradePrice: matchingLiveRate.lastTradePrice,
        high: matchingLiveRate.high,
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
        priceChangePercentage: matchingLiveRate.priceChangePercentage,
        buyPrice: matchingLiveRate.buyPrice,
        salePrice: matchingLiveRate.sellPrice,
      );
      return item;
    }).toList();
    state = state.copyWith(list: updatedList);
  }

  void searchStock(String query) {
    state = state.copyWith(
      list: state.initialData
          .where((item) =>
              item.title
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()) &&
              type == item.instrumentType)
          .toList(),
    );
  }

  Future<void> addToWatchList(
      BuildContext context, String categoryId, int isChecked, int index) async {
    StatusMessage? response = await ApiInterface.addToWatchList(
        context, categoryId, isChecked == 1 ? 0 : 1);
    if (response!.status == 1) {
      final updatedList = [...state.list];
      updatedList[index] =
          updatedList[index].copyWith(isChecked: isChecked == 1 ? 0 : 1);
      state = state.copyWith(list: updatedList);
    } else {
      HelperFunction.showMessage(context, response.message!, type: 3);
    }
  }
}

// Create a provider for GlobalKey<NavigatorState>
final navigatorKeyProvider =
    Provider<GlobalKey<NavigatorState>>((ref) => GlobalKey<NavigatorState>());

// Define the StateNotifierProvider with context handling moved to the widget
final searchNotifierProvider =
    StateNotifierProvider.family<SearchNotifier, SearchState, String>(
        (ref, type) {
  return SearchNotifier(type);
});
