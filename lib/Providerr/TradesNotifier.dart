import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ApiService/ApiInterface.dart';
import '../Dialogs/AlertBox.dart';
import '../Model/StatusMessage.dart';
import '../Model/TradeData.dart';

class TradesState {
  final List<Data>? pendingTrades;
  final List<Data>? activeTrades;
  final List<Data>? closeTrades;

  TradesState({
    this.pendingTrades,
    this.activeTrades,
    this.closeTrades,
  });
}

class TradesNotifier extends StateNotifier<TradesState> {
  TradesNotifier()
      : super(TradesState(
          pendingTrades: [],
          activeTrades: [],
          closeTrades: [],
        ));

  Future<void> fetchTrades(BuildContext context, int type) async {
    TradeData? response = await ApiInterface.tradeList(context, type,
        showLoading: (state.pendingTrades == null && type == 1) ||
            (state.activeTrades == null && type == 2) ||
            (state.closeTrades == null && type == 3));
    if (response?.status == 1) {
      switch (type) {
        case 1:
          state = TradesState(
            pendingTrades: response?.data,
            activeTrades: state.activeTrades,
            closeTrades: state.closeTrades,
          );
          break;
        case 2:
          state = TradesState(
            pendingTrades: state.pendingTrades,
            activeTrades: response?.data,
            closeTrades: state.closeTrades,
          );
          break;
        case 3:
          state = TradesState(
            pendingTrades: state.pendingTrades,
            activeTrades: state.activeTrades,
            closeTrades: response?.data,
          );
          break;
      }
    }
  }

  Future<void> updateTradeStatus(
      BuildContext context, String orderId, String type) async {
    StatusMessage? response =
        await ApiInterface.updateTradeStatus(context, orderId, type);
    AlertBox.showStatus(
        context, response!.message.toString(), response.status == 0);
  }
}

final tradesProvider = StateNotifierProvider<TradesNotifier, TradesState>(
  (ref) => TradesNotifier(),
);
