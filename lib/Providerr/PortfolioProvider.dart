import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/Model/GetPortfolioList.dart';
import 'package:me_app/Model/PortfolioCloseList.dart';
import 'package:me_app/Utils/HelperFunction.dart';
import '../ApiService/ApiInterface.dart';

class PortfolioState {
  final bool isLoading;
  final GetPortfolioList portfolioList;
  final PortfolioCloseList portfolioCloseList;

  PortfolioState({
    required this.isLoading,
    required this.portfolioList,
    required this.portfolioCloseList,
  });
}

class PortfolioNotifier extends StateNotifier<PortfolioState> {
  PortfolioNotifier()
      : super(PortfolioState(
          isLoading: true,
          portfolioList: GetPortfolioList(),
          portfolioCloseList: PortfolioCloseList(),
        ));

  Future<void> getPortfolioData(BuildContext context) async {
    final response = await ApiInterface.getPortfolio(context);
    if (response?.status == 1) {
      state = PortfolioState(
        isLoading: false,
        portfolioList: response!,
        portfolioCloseList: state.portfolioCloseList,
      );
    } else {
      HelperFunction.showMessage(
          context, response?.message.toString() ?? 'Error',
          type: 3);
      state = PortfolioState(
        isLoading: false,
        portfolioList: state.portfolioList,
        portfolioCloseList: state.portfolioCloseList,
      );
    }
  }

  Future<void> getClosePortfolioData(BuildContext context) async {
    final response = await ApiInterface.getPortfolioClose(context);
    if (response?.status == 1) {
      state = PortfolioState(
        isLoading: false,
        portfolioList: state.portfolioList,
        portfolioCloseList: response!,
      );
    } else {
      HelperFunction.showMessage(
          context, response?.message.toString() ?? 'Error',
          type: 3);
      state = PortfolioState(
        isLoading: false,
        portfolioList: state.portfolioList,
        portfolioCloseList: state.portfolioCloseList,
      );
    }
  }
}

final portfolioProvider =
    StateNotifierProvider<PortfolioNotifier, PortfolioState>(
  (ref) => PortfolioNotifier(),
);
