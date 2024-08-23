import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/Model/GetPortfolioList.dart';
import 'package:me_app/Model/PortfolioCloseList.dart';
import 'package:me_app/Utils/HelperFunction.dart';
import '../ApiService/ApiInterface.dart';
import '../Dialogs/AlertBox.dart';
import '../Model/StatusMessage.dart';

class PortfolioState {
  final GetPortfolioList portfolioList;
  final PortfolioCloseList portfolioCloseList;

  PortfolioState({
    required this.portfolioList,
    required this.portfolioCloseList,
  });
}

class PortfolioNotifier extends StateNotifier<PortfolioState> {
  PortfolioNotifier()
      : super(PortfolioState(
          portfolioList: GetPortfolioList(),
          portfolioCloseList: PortfolioCloseList(),
        ));

  Future<void> getPortfolioData(BuildContext context) async {
    final response = await ApiInterface.getPortfolio(context,
        showLoading: state.portfolioList.data == null);
    if (response?.status == 1) {
      state = PortfolioState(
        portfolioList: response!,
        portfolioCloseList: state.portfolioCloseList,
      );
    } else {
      HelperFunction.showMessage(
          context, response?.message.toString() ?? 'Error',
          type: 3);
      state = PortfolioState(
        portfolioList: state.portfolioList,
        portfolioCloseList: state.portfolioCloseList,
      );
    }
  }

  Future<void> getClosePortfolioData(BuildContext context) async {
    final response = await ApiInterface.getPortfolioClose(context,
        showLoading: state.portfolioCloseList.data == null);
    if (response?.status == 1) {
      state = PortfolioState(
        portfolioList: state.portfolioList,
        portfolioCloseList: response!,
      );
    } else {
      HelperFunction.showMessage(
          context, response?.message.toString() ?? 'Error',
          type: 3);
      state = PortfolioState(
        portfolioList: state.portfolioList,
        portfolioCloseList: state.portfolioCloseList,
      );
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




final portfolioProvider =
    StateNotifierProvider<PortfolioNotifier, PortfolioState>(
  (ref) => PortfolioNotifier(),
);
