import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marqueer/marqueer.dart';
import 'package:nb_utils/nb_utils.dart';
import '../ApiService/ApiInterface.dart';
import '../Dialogs/AlertBox.dart';
import '../Model/GetPortfolioList.dart';
import '../Model/PortfolioCloseList.dart';
import '../Providerr/NotificationProvider.dart';
import '../Providerr/PortfolioProvider.dart';
import '../Providerr/WatchlistNotifier.dart';
import '../Resources/Strings.dart';
import '../Resources/Styles.dart';
import '../Utils/AppBar.dart';
import '../Utils/AppTheme.dart';
import '../Utils/Colors.dart';
import '../Utils/HelperFunction.dart';
import 'StockDetailScreen.dart';
import '../Model/GetMCXModel.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  Timer? _refreshTimer;
  late TabController _tabController;
  final marqueController = MarqueerController();

  @override
  void initState() {
    super.initState();
    ref.read(notificationProvider.notifier).fetchNotifications(context);
    _tabController = TabController(length: 3, vsync: this);
    getData();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _refreshTimer?.cancel();
    marqueController.stop();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(portfolioProvider);
    final notificationState = ref.watch(notificationProvider);

    return Scaffold(
      appBar: CustomAppBar(ref: ref),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              indicatorColor: goldencolor,
              tabs: [
                Tab(
                    child: Center(
                        child: Text(Strings.active,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.green)))),
                Tab(
                    child: Center(
                        child: Text(Strings.close,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: goldencolor)))),
              ],
            ),
            notificationState.notifications?.data != null
                ? Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    height: 40,
                    color: Colors.black,
                    child: Marqueer.builder(
                      controller: marqueController,
                      itemCount: notificationState.notifications?.data!.length,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              notificationState
                                  .notifications!.data![index].message!,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(color: Colors.red),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : const SizedBox(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    child: provider.portfolioList.data != null
                        ? getUi(provider.portfolioList)
                        : Center(
                            child: Text(
                              Strings.dataNotAvailable,
                              style: Theme.of(context).textTheme.titleLarge!,
                            ),
                          ),
                  ),
                  Container(
                    child: provider.portfolioCloseList.data != null
                        ? getCloseUi(provider.portfolioCloseList)
                        : Center(
                            child: Text(
                              Strings.dataNotAvailable,
                              style: Theme.of(context).textTheme.titleLarge!,
                            ),
                          ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableCell _buildTableCell(String title, String value,
      {Color valueColor = Colors.black}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(
                title,
                style: Theme.of(context).textTheme.headlineLarge,
              )),
              Expanded(
                  child: Text(
                value,
                textAlign: TextAlign.end,
                style: valueColor != Colors.black
                    ? Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: valueColor)
                    : Theme.of(context).textTheme.titleLarge,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget getUi(GetPortfolioList portfolioList) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: appColors.color1,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black),
            ),
            child: Column(
              children: [
                Table(
                  border:
                      const TableBorder.symmetric(inside: BorderSide(width: 1)),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(children: [
                      _buildTableCell(
                          Strings.ledgerBal,
                          portfolioList.totalLedgerBalance?.toString() ??
                              Strings.na),
                      _buildTableCell(
                          Strings.marginAvail,
                          portfolioList.totalMarginBalance?.toString() ??
                              Strings.na),
                    ]),
                    TableRow(children: [
                      _buildTableCell(
                          Strings.activePl,
                          portfolioList.totalPlBalance?.toString() ??
                              Strings.na,
                          valueColor:
                              (portfolioList.totalPlBalance?.toDouble() ??
                                          0.0) >=
                                      0
                                  ? Colors.green
                                  : Colors.red),
                      _buildTableCell(
                          Strings.m2m,
                          portfolioList.totalM2MBalance?.toString() ??
                              Strings.na),
                    ]),
                  ],
                ),
                const Divider(
                  color: Colors.black,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        Strings.requireHoldingMargin,
                        style: Theme.of(context).textTheme.titleLarge,
                      )),
                      Text(
                        portfolioList.data!
                            .map((item) => item.holdingMargin)
                            .fold(0.0, (sum, value) => sum + value!)
                            .toString(),
                        style: Theme.of(context).textTheme.titleLarge!,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          20.height,
          Expanded(
            child: ListView.builder(
              itemCount: portfolioList.data?.length,
              itemBuilder: (context, index) {
                final data = portfolioList.data![index];
                return Column(
                  children: [
                    10.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${data.categoryName.toString()}_${data.expireDate.toString()}',
                                style: Theme.of(context).textTheme.titleLarge!),
                            5.height,
                            Text("Margin:${data.intradayMargin.toString()}",
                                style: Theme.of(context).textTheme.titleMedium),
                            Text(
                                "Holdin Margin:${data.holdingMargin.toString()}",
                                style: Theme.of(context).textTheme.titleMedium),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                    data.bidType!.contains("1")
                                        ? 'Bought : '
                                        : "Sold : ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: data.bidType!.contains("1")
                                                ? Colors.green
                                                : Colors.red)),
                                Text(
                                    '${data.lot}@${data.avrageBidPrice.toString()}',
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                              ],
                            ),
                            5.height,
                            Text(data.plBalance.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                        color: data.plBalance! < 0
                                            ? Colors.red
                                            : Colors.green)),
                            5.height,
                            Text('CMP:${data.cmprate.toString()}',
                                style: Theme.of(context).textTheme.titleMedium),
                            5.height,
                            Card(
                              color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 7),
                                child: Text(
                                  Strings.closeOrder,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ).onTap(() {
                              AlertBox.showAlert(
                                  context,
                                 Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                   Text(
                                     Strings.confirmCloseTrade,
                                     style: Styles.normalText(
                                         context: context, isBold: true,fontSize: 18),
                                   ),
                                   SizedBox(height: 10,),
                                   Text(
                                     Strings.confirmCloseTradeMsg,
                                     style: Styles.normalText(context: context),
                                   )
                                 ],), () {
                                ref
                                    .read(portfolioProvider.notifier)
                                    .updateTradeStatus(context,
                                        data.categoryId.toString(), "3");
                              });
                            }),
                          ],
                        ),
                      ],
                    ),
                    const Divider()
                  ],
                ).onTap(() {
                  gotoDetailPage( StockData(
                      instrumentToken: data.instrumentToken,
                      categoryId: data.categoryId,
                      title: data.instrumentToken,
                      expireDate: data.expireDate,
                      salePrice: data.bidPrice,
                      buyPrice: data.bidPrice,
                      quotationLot: data.lot));
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> gotoDetailPage(StockData data) async {
    final response = await ApiInterface.getLiveRate(context,
        token: data.instrumentToken.toString(), showLoading: true);
    StockDetailScreen(stockData: data,data: response!.livedata!.first,)
        .launch(context)
        .then((b) {
      Future.microtask(() => ref
          .read(watchlistProvider.notifier)
          .fetchCategoryList(context));
    });
  }


  Widget getCloseUi(PortfolioCloseList portfolioCloseList) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: appColors.color1,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black),
            ),
            child: Table(
              border: const TableBorder.symmetric(inside: BorderSide(width: 1)),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
              },
              children: [
                TableRow(children: [
                  _buildTableCell(Strings.ledgerBal,
                      portfolioCloseList.totalLedgerBalance ?? Strings.na),
                  _buildTableCell(
                      Strings.profitLoss,
                      portfolioCloseList.totalPlBalance?.toString() ??
                          Strings.na),
                ]),
                TableRow(children: [
                  _buildTableCell(
                      Strings.totalBrokerage,
                      portfolioCloseList.totalBrokerage?.toString() ??
                          Strings.na),
                  _buildTableCell(
                    Strings.netProfitLoss,
                    portfolioCloseList.netProfitLoss?.toString() ?? Strings.na,
                  ),
                ]),
              ],
            ),
          ),
          15.height,
          Expanded(
            child: ListView.builder(
              itemCount: portfolioCloseList.data?.length ?? 0,
              itemBuilder: (context, index) {
                final data = portfolioCloseList.data![index];
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${data.categoryName.toString()}_${data.expireDate.toString()}',
                                  style:
                                      Theme.of(context).textTheme.titleLarge!),
                              5.height,
                              Text("Avg sell: ${data.avgSellPrice.toString()}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Row(
                                children: [
                                  Text('Net Profit Loss : ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  Text(
                                      "${data.plBalance.toDouble() >= 0 ? "+" : ""}${data.plBalance!}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color:
                                                  data.plBalance.toDouble() >= 0
                                                      ? Colors.green
                                                      : Colors.red)),
                                ],
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text('Qty : ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(
                                              color: data.bidType!.contains("1")
                                                  ? Colors.green
                                                  : Colors.red)),
                                  Text(data.lot.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!),
                                ],
                              ),
                              5.height,
                              Text("Avg Buy : ${data.avgSellPrice.toString()}",
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              Row(
                                children: [
                                  Text('Brokerage : ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  Text(data.brokerage.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: Colors.red)),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.4,
                      color: Colors.blueGrey,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void getData() {
    // Call your provider methods in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (mounted) {
          if (await HelperFunction.isInternetConnected(context)) {
            final notifier = ref.read(portfolioProvider.notifier);
            if (_tabController.index == 0) {
              notifier.getPortfolioData(context);
            } else {
              notifier.getClosePortfolioData(context);
            }
          }
        } else {
          _refreshTimer?.cancel();
        }
      });
      marqueController.start();
    });

  }
}
