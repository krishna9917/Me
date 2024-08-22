import 'dart:async';
import 'package:flutter/material.dart';
import 'package:me_app/CommonWidget/TradeHistory.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:me_app/Utils/HelperFunction.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Providerr/TradesNotifier.dart';
import '../Resources/Strings.dart';
import '../Utils/AppBar.dart';

class TradesScreen extends ConsumerStatefulWidget {
  @override
  _TradesScreenState createState() => _TradesScreenState();
}

class _TradesScreenState extends ConsumerState<TradesScreen>
    with SingleTickerProviderStateMixin {
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
          ref
              .read(tradesProvider.notifier)
              .fetchTrades(context, _tabController.index + 1);
        }
      } else {
        _refreshTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tradesState = ref.watch(tradesProvider);

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
                      trades: tradesState.pendingTrades,
                      tradeStatus: _tabController.index + 1,
                      onCancelCall: (String orderID, String type) {
                        ref
                            .read(tradesProvider.notifier)
                            .updateTradeStatus(context, orderID, type);
                      }),
                  Tradehistory(
                      trades: tradesState.activeTrades,
                      tradeStatus: _tabController.index + 1,
                      onCancelCall: (String orderID, String type) {
                        ref
                            .read(tradesProvider.notifier)
                            .updateTradeStatus(context, orderID, type);
                      }),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.748,
                        child: tradesState.closeTrades != null &&
                                tradesState.closeTrades!.isNotEmpty
                            ? ListView.builder(
                                padding: const EdgeInsets.all(8.0),
                                itemCount: tradesState.closeTrades!.length,
                                itemBuilder: (context, index) {
                                  final trade = tradesState.closeTrades![index];
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
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('${trade.categoryName}',
                                                      style: Styles.normalText(
                                                          isBold: true)),
                                                  Text('${trade.expireDate}',
                                                      style: Styles.normalText(
                                                          fontSize: 11,
                                                          isBold: true)),
                                                  Wrap(
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: [
                                                      Text('Sold by Trader',
                                                          style:
                                                              Styles.normalText(
                                                                  fontSize: 11,
                                                                  isBold:
                                                                      true)),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          border: Border.all(
                                                            color: Colors.red,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      6),
                                                          child: Text(
                                                              '${trade.bidPrice}',
                                                              style: Styles
                                                                  .normalText(
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
                                                              .formattedDate(trade
                                                                  .orderDateTime!),
                                                          style:
                                                              Styles.normalText(
                                                                  fontSize: 11,
                                                                  isBold:
                                                                      true)),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          border: Border.all(
                                                            color: trade
                                                                    .orderType!
                                                                    .contains(
                                                                        "1")
                                                                ? Colors.green
                                                                : Colors.red,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      6),
                                                          child: Text(
                                                              trade.orderType!
                                                                      .contains(
                                                                          "1")
                                                                  ? Strings
                                                                      .market
                                                                  : trade.orderType!
                                                                          .contains(
                                                                              "2")
                                                                      ? Strings
                                                                          .order
                                                                      : trade.orderType!.contains(
                                                                              "3")
                                                                          ? Strings
                                                                              .sl
                                                                          : trade.orderType!.contains(
                                                                                  "4")
                                                                              ? Strings
                                                                                  .admin
                                                                              : trade.orderType!.contains(
                                                                                      "5")
                                                                                  ? Strings
                                                                                      .carriedForward
                                                                                  : trade.orderType!.contains(
                                                                                          "6")
                                                                                      ? Strings
                                                                                          .iFund
                                                                                      : trade.orderType!.contains(
                                                                                              "7")
                                                                                          ? Strings
                                                                                              .monthSettlement
                                                                                          : "",
                                                              style: Styles.normalText(
                                                                  fontSize: 11,
                                                                  isBold: true,
                                                                  color: trade
                                                                          .orderType!
                                                                          .contains(
                                                                              "1")
                                                                      ? Colors
                                                                          .green
                                                                      : Colors.red)),
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
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          border: Border.all(
                                                            color: trade.totalProfit
                                                                        .toDouble() >
                                                                    0
                                                                ? Colors.green
                                                                : Colors.red,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      6),
                                                          child: Text(
                                                              '${trade.totalProfit}/${trade.brokerage}',
                                                              style: Styles.normalText(
                                                                  fontSize: 11,
                                                                  isBold: true,
                                                                  color: trade.totalProfit
                                                                              .toDouble() >
                                                                          0
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
                                                                  .circular(6),
                                                          border: Border.all(
                                                            color: trade.totalProfit
                                                                        .toDouble() >
                                                                    0
                                                                ? Colors.green
                                                                : Colors.red,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      6),
                                                          child: Text(
                                                              'QTY:${trade.lot}',
                                                              style: Styles.normalText(
                                                                  fontSize: 11,
                                                                  isBold: true,
                                                                  color: trade.totalProfit
                                                                              .toDouble() >
                                                                          0
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
                                                      Text('Brought By Trader',
                                                          style:
                                                              Styles.normalText(
                                                                  fontSize: 11,
                                                                  isBold:
                                                                      true)),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          border: Border.all(
                                                            color: Colors.green,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      6),
                                                          child: Text(
                                                              '${trade.sellPrice}',
                                                              style: Styles
                                                                  .normalText(
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
                                                  const SizedBox(height: 4),
                                                  Wrap(
                                                    alignment:
                                                        WrapAlignment.end,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          HelperFunction
                                                              .formattedDate(trade
                                                                  .orderUpdateDateTime!),
                                                          style:
                                                              Styles.normalText(
                                                                  fontSize: 11,
                                                                  isBold:
                                                                      true)),
                                                      const SizedBox(width: 8),
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(6),
                                                          border: Border.all(
                                                            color: trade
                                                                    .closeOrderType!
                                                                    .contains(
                                                                        "1")
                                                                ? Colors.green
                                                                : Colors.red,
                                                            width: 2,
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      6),
                                                          child: Text(
                                                              trade.closeOrderType!
                                                                      .contains(
                                                                          "1")
                                                                  ? Strings
                                                                      .market
                                                                  : trade.closeOrderType!
                                                                          .contains(
                                                                              "2")
                                                                      ? Strings
                                                                          .order
                                                                      : trade.closeOrderType!.contains(
                                                                              "3")
                                                                          ? Strings
                                                                              .sl
                                                                          : trade.closeOrderType!.contains(
                                                                                  "4")
                                                                              ? Strings
                                                                                  .admin
                                                                              : trade.closeOrderType!.contains(
                                                                                      "5")
                                                                                  ? Strings
                                                                                      .carriedForward
                                                                                  : trade.closeOrderType!.contains(
                                                                                          "6")
                                                                                      ? Strings
                                                                                          .iFund
                                                                                      : trade.closeOrderType!.contains(
                                                                                              "7")
                                                                                          ? Strings
                                                                                              .monthSettlement
                                                                                          : "",
                                                              style: Styles.normalText(
                                                                  fontSize: 11,
                                                                  isBold: true,
                                                                  color: trade
                                                                          .closeOrderType!
                                                                          .contains(
                                                                              "1")
                                                                      ? Colors.green
                                                                      : Colors.red)),
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
                      ),
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
