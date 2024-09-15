import 'dart:async';
import 'package:flutter/material.dart';
import 'package:me_app/CommonWidget/TradeHistory.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:me_app/Utils/Colors.dart';
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
              indicatorColor: goldencolor,
              tabs: [
                Tab(
                  child: Center(
                      child: Text(Strings.pending,
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.amber))),
                ),
                Tab(
                  child: Center(
                      child: Text(Strings.active,
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.green))),
                ),
                Tab(
                  child: Center(
                      child: Text(Strings.close,
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: Colors.red))),
                ),
              ],
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
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.748,
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
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleLarge),
                                                  Text('${trade.expireDate}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium),
                                                  5.height,
                                                  Wrap(
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .center,
                                                    children: [
                                                      Text('Sold by Trader',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium),
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
                                                                  vertical: 1,
                                                                  horizontal:
                                                                      4),
                                                          child: Text(
                                                              '${trade.bidPrice}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
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
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleMedium!),
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
                                                                  vertical: 1,
                                                                  horizontal:
                                                                      4),
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
                                                                          : trade.orderType!.contains("4")
                                                                              ? Strings.admin
                                                                              : trade.orderType!.contains("5")
                                                                                  ? Strings.carriedForward
                                                                                  : trade.orderType!.contains("6")
                                                                                      ? Strings.iFund
                                                                                      : trade.orderType!.contains("7")
                                                                                          ? Strings.monthSettlement
                                                                                          : "",
                                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: trade.orderType!.contains("1") ? Colors.green : Colors.red)),
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
                                              padding: const EdgeInsets.only(
                                                  top: 8,
                                                  bottom: 2,
                                                  right: 8,
                                                  left: 4),
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
                                                                  vertical: 1,
                                                                  horizontal:
                                                                      4),
                                                          child: Text(
                                                              '${trade.totalProfit}/${trade.brokerage}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                      color: trade.totalProfit.toDouble() > 0
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red)),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
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
                                                                  vertical: 1,
                                                                  horizontal:
                                                                      6),
                                                          child: Text(
                                                              'QTY:${trade.lot}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                      color: trade.totalProfit.toDouble() > 0
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .red)),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Wrap(
                                                    alignment:
                                                        WrapAlignment.end,
                                                    children: [
                                                      Text('Brought By Trader',
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleMedium),
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
                                                                  vertical: 1,
                                                                  horizontal:
                                                                      4),
                                                          child: Text(
                                                              '${trade.sellPrice}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
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
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleMedium!),
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
                                                                  vertical: 1,
                                                                  horizontal:
                                                                      4),
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
                                                                          : trade.closeOrderType!.contains("4")
                                                                              ? Strings.admin
                                                                              : trade.closeOrderType!.contains("5")
                                                                                  ? Strings.carriedForward
                                                                                  : trade.closeOrderType!.contains("6")
                                                                                      ? Strings.iFund
                                                                                      : trade.closeOrderType!.contains("7")
                                                                                          ? Strings.monthSettlement
                                                                                          : "",
                                                              style: Theme.of(context).textTheme.titleMedium!.copyWith(color: trade.closeOrderType!.contains("1") ? Colors.green : Colors.red)),
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
                                      const Divider(
                                        thickness: 0.4,
                                        color: Colors.blueGrey,
                                      )
                                    ],
                                  );
                                },
                              )
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
                                        const EdgeInsets.all(0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text('${trade.categoryName}',
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .titleLarge),
                                            Text('${trade.expireDate}',
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .titleMedium),
                                            8.height,
                                            Wrap(
                                              crossAxisAlignment:
                                              WrapCrossAlignment
                                                  .center,
                                              children: [
                                                Text('Sold by Trader',
                                                    style:
                                                    Theme
                                                        .of(context)
                                                        .textTheme
                                                        .titleMedium?.copyWith(fontSize: 11)),
                                                const SizedBox(width: 5),
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
                                                        horizontal:
                                                        2),
                                                    child: Text(
                                                        '${trade.bidPrice}',
                                                        style: Theme
                                                            .of(
                                                            context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                            color: Colors
                                                                .red, fontSize: 11)),
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
                                                    style: Theme
                                                        .of(
                                                        context)
                                                        .textTheme
                                                        .titleMedium?.copyWith(fontSize: 11)),
                                                const SizedBox(width: 5),
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
                                                        horizontal:
                                                        2),
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
                                                            : trade.orderType!
                                                            .contains(
                                                            "3")
                                                            ? Strings
                                                            .sl
                                                            : trade.orderType!
                                                            .contains("4")
                                                            ? Strings.admin
                                                            : trade.orderType!
                                                            .contains("5")
                                                            ? Strings
                                                            .carriedForward
                                                            : trade.orderType!
                                                            .contains("6")
                                                            ? Strings.iFund
                                                            : trade.orderType!
                                                            .contains("7")
                                                            ? Strings
                                                            .monthSettlement
                                                            : "",
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                            color: trade
                                                                .orderType!
                                                                .contains("1")
                                                                ? Colors.green
                                                                : Colors.red,fontSize: 11)),
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
                                        const EdgeInsets.all(0),
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
                                                        vertical: 2,
                                                        horizontal:
                                                        4),
                                                    child: Text(
                                                        '${trade
                                                            .totalProfit}/${trade
                                                            .brokerage}',
                                                        style: Theme
                                                            .of(
                                                            context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                            color: trade
                                                                .totalProfit
                                                                .toDouble() > 0
                                                                ? Colors
                                                                .green
                                                                : Colors
                                                                .red)),
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
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
                                                        vertical: 2,
                                                        horizontal:
                                                        4),
                                                    child: Text(
                                                        'QTY:${trade.lot}',
                                                        style: Theme
                                                            .of(
                                                            context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                            color: trade
                                                                .totalProfit
                                                                .toDouble() > 0
                                                                ? Colors
                                                                .green
                                                                : Colors
                                                                .red)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 20),
                                            Wrap(
                                              alignment: WrapAlignment.end,
                                              children: [
                                                Text('Brought By Trader',
                                                    style:
                                                    Theme
                                                        .of(context)
                                                        .textTheme
                                                        .titleMedium?.copyWith(fontSize: 11)),
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
                                                        horizontal:
                                                        2),
                                                    child: Text(
                                                        '${trade.sellPrice}',
                                                        style: Theme
                                                            .of(
                                                            context)
                                                            .textTheme
                                                            .titleMedium!.copyWith(fontSize: 11)
                                                            .copyWith(
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
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .titleMedium?.copyWith(fontSize: 11)),
                                                const SizedBox(width: 5),
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
                                                        horizontal:
                                                        2),
                                                    child: Text(
                                                        trade.closeOrderType!
                                                            .contains(
                                                            "1")
                                                            ? Strings
                                                            .market
                                                            : trade
                                                            .closeOrderType!
                                                            .contains(
                                                            "2")
                                                            ? Strings
                                                            .order
                                                            : trade
                                                            .closeOrderType!
                                                            .contains(
                                                            "3")
                                                            ? Strings
                                                            .sl
                                                            : trade
                                                            .closeOrderType!
                                                            .contains("4")
                                                            ? Strings.admin
                                                            : trade
                                                            .closeOrderType!
                                                            .contains("5")
                                                            ? Strings
                                                            .carriedForward
                                                            : trade
                                                            .closeOrderType!
                                                            .contains("6")
                                                            ? Strings.iFund
                                                            : trade
                                                            .closeOrderType!
                                                            .contains("7")
                                                            ? Strings
                                                            .monthSettlement
                                                            : "",
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .titleMedium!
                                                            .copyWith(fontSize: 11,
                                                            color: trade
                                                                .closeOrderType!
                                                                .contains("1")
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
                                const Divider(
                                  thickness: 0.4,
                                  color: Colors.blueGrey,
                                )
                              ],
                            );
                          },
                        )
                            : Center(
                            child: Text(
                              Strings.dataNotAvailable,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .titleLarge,
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
