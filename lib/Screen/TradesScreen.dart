import 'dart:async';
import 'package:flutter/material.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import 'package:me_app/CommonWidget/TradeHistory.dart';
import 'package:me_app/Dialogs/AlertBox.dart';
import 'package:me_app/Model/StatusMessage.dart';
import 'package:me_app/Model/TradeData.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:me_app/Utils/HelperFunction.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Resources/Strings.dart';
import '../Utils/AppBar.dart';

class TradesScreen extends ConsumerStatefulWidget {
  @override
  _TradesScreenState createState() => _TradesScreenState();
}

class _TradesScreenState extends ConsumerState<TradesScreen>
    with SingleTickerProviderStateMixin {
  List<Data>? pendingTrades;
  List<Data>? activeTrades;
  List<Data>? closeTrades;
  bool isLoading = true;
  late TabController _tabController;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _startPeriodicRefresh();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (mounted) {
        if (await HelperFunction.isInternetConnected(context)) {
          getTrades(type: _tabController.index + 1);
        }
      } else {
        _refreshTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void getTrades({int type = 1}) async {
    TradeData? response = await ApiInterface.tradeList(context, type);
    if (response!.status == 1) {
      if (type == 1) {
        pendingTrades = response.data!;
      } else if (type == 2) {
        activeTrades = response.data!;
      } else {
        closeTrades = response.data!;
      }
    }
    setState(() {
      isLoading = false;
    });

    if (activeTrades == null) {
      getTrades(type: 2);
    }
    if (closeTrades == null) {
      getTrades(type: 3);
    }
  }

  Future<void> updateTradeStatus(String orderId, String type) async {
    StatusMessage? response =
        await ApiInterface.updateTradeStatus(context, orderId, type);
    AlertBox.showStatus(
        context, response!.message.toString(), response.status == 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(ref: ref),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Center(
                      child: Text(Strings.pending,
                          style: Styles.normalText(
                              isBold: true, color: Colors.amber))),
                ),
                Tab(
                  child: Center(
                      child: Text(Strings.active,
                          style: Styles.normalText(
                              isBold: true, color: Colors.green))),
                ),
                Tab(
                  child: Center(
                      child: Text(Strings.close,
                          style: Styles.normalText(
                              isBold: true, color: Colors.red))),
                ),
              ],
              labelStyle: Styles.normalText(isBold: true),
              unselectedLabelStyle: Styles.normalText(),
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.amber.shade700,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Tradehistory(
                      trades: pendingTrades,
                      isLoading: isLoading,
                      tradeStatus: _tabController.index + 1,
                      onCancelCall: (String orderID, String type) {
                        updateTradeStatus(orderID, type);
                      }),
                  Tradehistory(
                      trades: activeTrades,
                      isLoading: isLoading,
                      tradeStatus: _tabController.index + 1,
                      onCancelCall: (String orderID, String type) {
                        updateTradeStatus(orderID, type);
                      }),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.748,
                        child: isLoading
                            ? Center(
                                child: Image.asset('assets/loader.png'),
                              )
                            : closeTrades != null && closeTrades!.isNotEmpty
                                ? ListView.builder(
                                    padding: const EdgeInsets.all(8.0),
                                    itemCount: closeTrades!.length ?? 0,
                                    itemBuilder: (context, index) {
                                      final trade = closeTrades![index];
                                      return Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          '${trade.categoryName}',
                                                          style:
                                                              Styles.normalText(
                                                                  isBold:
                                                                      true)),
                                                      Text(
                                                          '${trade.expireDate}',
                                                          style:
                                                              Styles.normalText(
                                                                  fontSize: 11,
                                                                  isBold:
                                                                      true)),
                                                      Wrap(
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: [
                                                          Text('Sold by Trader',
                                                              style: Styles
                                                                  .normalText(
                                                                      fontSize:
                                                                          11,
                                                                      isBold:
                                                                          true)),
                                                          const SizedBox(
                                                              width: 8),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              border:
                                                                  Border.all(
                                                                color:
                                                                    Colors.red,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          3,
                                                                      horizontal:
                                                                          6),
                                                              child: Text(
                                                                  '${trade.bidPrice}',
                                                                  style: Styles.normalText(
                                                                      fontSize:
                                                                          11,
                                                                      isBold:
                                                                          true,
                                                                      color: Colors
                                                                          .red)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      5.height,
                                                      Wrap(
                                                        children: [
                                                          Text(
                                                              HelperFunction
                                                                  .formattedDate(
                                                                      trade
                                                                          .orderDateTime!),
                                                              style: Styles
                                                                  .normalText(
                                                                      fontSize:
                                                                          11,
                                                                      isBold:
                                                                          true)),
                                                          SizedBox(width: 8),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              border:
                                                                  Border.all(
                                                                color: trade
                                                                        .orderType!
                                                                        .contains(
                                                                            "1")
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          3,
                                                                      horizontal:
                                                                          6),
                                                              child: Text(
                                                                  trade.orderType!
                                                                          .contains(
                                                                              "1")
                                                                      ? Strings
                                                                          .market
                                                                      : trade.orderType!.contains(
                                                                              "2")
                                                                          ? Strings
                                                                              .order
                                                                          : trade.orderType!.contains("3")
                                                                              ? Strings.sl
                                                                              : trade.orderType!.contains("4")
                                                                                  ? Strings.admin
                                                                                  : trade.orderType!.contains("5")
                                                                                      ? Strings.carriedForward
                                                                                      : trade.orderType!.contains("6")
                                                                                          ? Strings.iFund
                                                                                          : trade.orderType!.contains("7")
                                                                                              ? Strings.monthSettlement
                                                                                              : "",
                                                                  style: Styles.normalText(fontSize: 11, isBold: true, color: trade.orderType!.contains("1") ? Colors.green : Colors.red)),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              border:
                                                                  Border.all(
                                                                color: trade.totalProfit
                                                                            .toDouble() >
                                                                        0
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          3,
                                                                      horizontal:
                                                                          6),
                                                              child: Text(
                                                                  '${trade.totalProfit}/${trade.brokerage}',
                                                                  style: Styles.normalText(
                                                                      fontSize:
                                                                          11,
                                                                      isBold:
                                                                          true,
                                                                      color: trade.totalProfit.toDouble() > 0
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red)),
                                                            ),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              border:
                                                                  Border.all(
                                                                color: trade.totalProfit
                                                                            .toDouble() >
                                                                        0
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          3,
                                                                      horizontal:
                                                                          6),
                                                              child: Text(
                                                                  'QTY:${trade.lot}',
                                                                  style: Styles.normalText(
                                                                      fontSize:
                                                                          11,
                                                                      isBold:
                                                                          true,
                                                                      color: trade.totalProfit.toDouble() > 0
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Wrap(
                                                        alignment:
                                                            WrapAlignment.end,
                                                        children: [
                                                          Text(
                                                              'Brought By Trader',
                                                              style: Styles
                                                                  .normalText(
                                                                      fontSize:
                                                                          11,
                                                                      isBold:
                                                                          true)),
                                                          const SizedBox(
                                                              width: 8),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              border:
                                                                  Border.all(
                                                                color: Colors
                                                                    .green,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          3,
                                                                      horizontal:
                                                                          6),
                                                              child: Text(
                                                                  '${trade.sellPrice}',
                                                                  style: Styles.normalText(
                                                                      fontSize:
                                                                          11,
                                                                      isBold:
                                                                          true,
                                                                      color: Colors
                                                                          .green)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 4),
                                                      Wrap(
                                                        alignment:
                                                            WrapAlignment.end,
                                                        crossAxisAlignment:
                                                            WrapCrossAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              HelperFunction
                                                                  .formattedDate(
                                                                      trade
                                                                          .orderUpdateDateTime!),
                                                              style: Styles
                                                                  .normalText(
                                                                      fontSize:
                                                                          11,
                                                                      isBold:
                                                                          true)),
                                                          SizedBox(width: 8),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          6),
                                                              border:
                                                                  Border.all(
                                                                color: trade
                                                                        .closeOrderType!
                                                                        .contains(
                                                                            "1")
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                                width: 2,
                                                              ),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          3,
                                                                      horizontal:
                                                                          6),
                                                              child: Text(
                                                                  trade.closeOrderType!
                                                                          .contains(
                                                                              "1")
                                                                      ? Strings
                                                                          .market
                                                                      : trade.closeOrderType!.contains(
                                                                              "2")
                                                                          ? Strings
                                                                              .order
                                                                          : trade.closeOrderType!.contains("3")
                                                                              ? Strings.sl
                                                                              : trade.closeOrderType!.contains("4")
                                                                                  ? Strings.admin
                                                                                  : trade.closeOrderType!.contains("5")
                                                                                      ? Strings.carriedForward
                                                                                      : trade.closeOrderType!.contains("6")
                                                                                          ? Strings.iFund
                                                                                          : trade.closeOrderType!.contains("7")
                                                                                              ? Strings.monthSettlement
                                                                                              : "",
                                                                  style: Styles.normalText(fontSize: 11, isBold: true, color: trade.closeOrderType!.contains("1") ? Colors.green : Colors.red)),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                        ],
                                      );
                                    },
                                  )
                                : Center(
                                    child: Text(
                                    Strings.dataNotAvailable,
                                    style: Styles.normalText(),
                                  )),
                      )

                      //Divider(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
