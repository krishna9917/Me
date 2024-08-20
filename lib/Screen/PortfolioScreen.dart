import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetPortfolioList.dart';
import '../Model/PortfolioCloseList.dart';
import '../Providerr/PortfolioProvider.dart';
import '../Resources/Strings.dart';
import '../Resources/Styles.dart';
import '../Utils/AppBar.dart';
import '../Utils/AppTheme.dart';
import '../Utils/HelperFunction.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  Timer? _refreshTimer;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    getData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(portfolioProvider);
    return Scaffold(
      appBar: CustomAppBar(ref: ref),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                      child: Center(
                          child: Text(Strings.active,
                              style: Styles.normalText(
                                  isBold: true, color: Colors.green)))),
                  Tab(
                      child: Center(
                          child: Text(Strings.close,
                              style: Styles.normalText(
                                  isBold: true, color: Colors.amber)))),
                ],
                labelStyle: Styles.normalText(isBold: true),
                unselectedLabelStyle: Styles.normalText(),
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.amber.shade700,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Container(
                    child: provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : getUi(provider.portfolioList),
                  ),
                  Container(
                    child: provider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : getCloseUi(provider.portfolioCloseList),
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
                style: Styles.normalText(
                    isBold: true,
                    color: Theme.of(context).extension<AppColors>()!.color1 ==
                            Colors.amber
                        ? Colors.amber
                        : Colors.black),
              )),
              Expanded(
                  child: Text(
                value,
                textAlign: TextAlign.end,
                style: Styles.normalText(
                    isBold: true,
                    color: Theme.of(context).extension<AppColors>()!.color1 ==
                            Colors.amber
                        ? Colors.amber
                        : valueColor),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget getUi(GetPortfolioList portfolioList) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
                        style: Styles.normalText(
                          isBold: true,
                        ),
                      )),
                      Text(
                        portfolioList.totalPlBalance.toString(),
                        style: Styles.normalText(isBold: true),
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
                                style: Styles.normalText(isBold: true)),
                            5.height,
                            Text("Margin:${data.intradayMargin.toString()}",
                                style: Styles.normalText(
                                    isBold: true, fontSize: 11)),
                            Text(
                                "Holdin Margin:${data.holdingMargin.toString()}",
                                style: Styles.normalText(
                                    isBold: true, fontSize: 11)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text('Bought : ',
                                    style: Styles.normalText(isBold: true)),
                                Text('1@${data.avrageBidPrice.toString()}',
                                    style: Styles.normalText(isBold: true)),
                              ],
                            ),
                            5.height,
                            Text(data.plBalance.toString(),
                                style: Styles.normalText(
                                    isBold: true, fontSize: 14)),
                            5.height,
                            Text('CMP:${data.cmprate.toString()}',
                                style: Styles.normalText(
                                    isBold: true, fontSize: 11)),
                            5.height,
                            Card(
                              color: Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 7),
                                child: Text(
                                  Strings.closeOrder,
                                  style: Styles.normalText(
                                      fontSize: 10,
                                      isBold: true,
                                      color: Colors.white),
                                ),
                              ),
                            ).onTap(() {}),
                          ],
                        ),
                      ],
                    ),
                    const Divider()
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget getCloseUi(PortfolioCloseList portfolioCloseList) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
                                  style: Styles.normalText(isBold: true)),
                              5.height,
                              Text("Avg sell: ${data.avgSellPrice.toString()}",
                                  style: Styles.normalText(
                                      isBold: true, fontSize: 11)),
                              Row(
                                children: [
                                  Text('Net Profit Loss : ',
                                      style: Styles.normalText(
                                          isBold: true, fontSize: 11)),
                                  Text(data.plBalance!,
                                      style: Styles.normalText(
                                          isBold: true,
                                          fontSize: 11,
                                          color: data.plBalance.toDouble() >= 0
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
                                      style: Styles.normalText(isBold: true)),
                                  Text(data.lot.toString(),
                                      style: Styles.normalText(isBold: true)),
                                ],
                              ),
                              5.height,
                              Text("Avg Buy : ${data.avgSellPrice.toString()}",
                                  style: Styles.normalText(
                                      isBold: true, fontSize: 11)),
                              Row(
                                children: [
                                  Text('Brokerage : ',
                                      style: Styles.normalText(
                                          isBold: true, fontSize: 11)),
                                  Text(data.brokerage.toString(),
                                      style: Styles.normalText(
                                          isBold: true, fontSize: 11)),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.green,
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
    });
  }
}
