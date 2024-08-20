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

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  @override
  void initState() {
    super.initState();
    // Call your provider methods in initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(portfolioProvider.notifier);
      notifier.getPortfolioData(context);
      notifier.getClosePortfolioData(context);
    });
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

  TableCell _buildTableCell(String title, String value) {
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
                        : Colors.black),
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
                  border: TableBorder.symmetric(inside: BorderSide(width: 1)),
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
                              Strings.na),
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
                        "Require Holding Margin : ",
                        style: Styles.normalText(
                          isBold: true,
                        ),
                      )),
                      Text(
                        "160000",
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
                                  'Close order',
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
                    Divider()
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(children: [
                      _buildTableCell('Ledger Balance',
                          portfolioCloseList.totalLedgerBalance ?? 'N/A'),
                      _buildTableCell(
                          'Profit Loss',
                          portfolioCloseList.totalPlBalance?.toString() ??
                              'N/A'),
                    ]),
                    TableRow(children: [
                      _buildTableCell(
                          'Total Brokrage',
                          portfolioCloseList.totalBrokerage?.toString() ??
                              'N/A'),
                      _buildTableCell(
                        'Net Profit/Loss',
                        portfolioCloseList.netProfitLoss?.toString() ?? 'N/A',
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 500,
            child: ListView.builder(
              itemCount: portfolioCloseList.data?.length,
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
                              Text("Avg:${data.avgSellPrice.toString()}",
                                  style: Styles.normalText(isBold: true)),
                              Row(
                                children: [
                                  Text('Net Profit Loss:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                  Text("${data!.plBalance.toString()}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ],
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Text('Qty:',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold)),
                                  Text('${data!.lot.toString()}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ],
                              ),
                              Text("Avg Buy:${data!.avgSellPrice.toString()}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12)),
                              Row(
                                children: [
                                  Text('Brokerage:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                  Text("${data!.brokerage.toString()}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
