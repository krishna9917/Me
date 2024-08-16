import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetPortfolioList.dart';
import '../Model/PortfolioCloseList.dart';
import '../Providerr/providers.dart';
import '../Services/Service_Api.dart';
import '../Utils/AppBar.dart';
import '../Utils/AppTheme.dart';


class PortfolioScreen extends ConsumerStatefulWidget {
  @override
  _PortfolioScreenState createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {

  @override
  void initState() {
    super.initState();
    //portfolioProvider;
  // print("fetchPortfolio():$fetchPortfolio()");
    _startPeriodicRefresh();
  }


  Timer? _refreshTimer;
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
  bool isLoading = true;
  bool _isFirstLoad = true;
  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(Duration(seconds:1), (timer) {
      final portfolioAsyncValue = ref.watch(portfolioProvider);
      final portfolioCloseAsyncValue = ref.watch(portfolioCloseProvider);
    });
  }
  GetPortfolioList? portfolioList;

  // Future<void> fetchPortfolio() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final stdata = prefs.getString('apiToken');
  //     print("stdata: $stdata");
  //     print("222");
  //
  //     if (stdata != null && stdata.isNotEmpty) {
  //       var bodyFields = {'userID': '145', 'type': '1'};
  //       var result = await ServicesApi().postApiWithData(
  //         'bXdSSmNIOHFOS2RoQTNES0hJYndwNmxjS1ZzbkVzZzVNSWdOVHZqRmh0MUFLNTJhSXZFYUdiQzV'
  //             'WS2Z3Z0V5TTNTejI1WWFoRm5MTWFJcTNlczJPajRlMk9qQ2dtZ3dYcExWVU1Laml4SlE9',
  //         'https://www.onlinetradelearn.com/mcx/authController/getPortfolioList',
  //         bodyFields,
  //       );
  //       print("result");
  //       final jsonData = jsonDecode(result);
  //       portfolioList= getPortfolioListFromJson(jsonData);
  //     print("portfolio:$portfolioList");
  //       setState(() {
  //         portfolioList= getPortfolioListFromJson(jsonData);
  //         isLoading = false;
  //       });
  //     } else {
  //       print('API token is not available or is empty');
  //       setState(() {
  //         isLoading = false;
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     print('Error occurred: $e');
  //   }
  // }

  int safeIntConversion(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt(); // Convert double to int
    } else if (value is String) {
      return int.tryParse(value) ?? 0; // Try parsing string to int, fallback to 0
    } else {
      return 0; // Fallback for unexpected types
    }
  }

  double safeDoubleConversion(dynamic value) {
    if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble(); // Convert int to double
    } else if (value is String) {
      return double.tryParse(value) ?? 0.0; // Try parsing string to double, fallback to 0.0
    } else {
      return 0.0; // Fallback for unexpected types
    }
  }


  @override
  Widget build(BuildContext context) {
    final portfolioAsyncValue = ref.watch(portfolioProvider);
    final portfolioCloseAsyncValue = ref.watch(portfolioCloseProvider);

    return Scaffold(
      appBar: CustomAppBar(ref: ref,),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              child: TabBar(
                tabs: [
                  Tab(child: Center(child: Text('Active', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)))),
                  Tab(child: Center(child: Text('Close', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)))),
                ],
                labelStyle: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontSize: 12.0),
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.amber.shade700,
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  portfolioAsyncValue.when(
                    data: (portfolioList) => Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Table(
                                border: TableBorder.all(),
                                columnWidths: {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(children: [
                                    _buildTableCell('Ledger Balance', portfolioList.totalLedgerBalance?.toString() ?? 'N/A'),
                                    _buildTableCell('Margin Available', portfolioList.totalMarginBalance?.toString() ?? 'N/A'),
                                  ]),
                                  TableRow(children: [
                                    _buildTableCell('Active P/L', portfolioList.totalPlBalance?.toString() ?? 'N/A'),
                                    _buildTableCell('M2M', portfolioList.totalM2MBalance?.toString() ?? 'N/A'),
                                  ]),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 500,
                          child: ListView.builder(
                            itemCount: portfolioList.data?.length,
                            itemBuilder: (context, index) {
                              final data = portfolioList.data![index];
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

                                            Text('${data!.categoryName.toString()}_${data!.expireDate.toString()}',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                                            Text("Margin:${data!.intradayMargin.toString()}",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                            Text("Holdin Margin:${data!.holdingMargin.toString()}",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            10.height,
                                            Row(
                                              children: [
                                                Text('Bought:', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                                Text('1@${data!.avrageBidPrice.toString()}',
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                                              ],
                                            ),
                                            Text("${data!.plBalance.toString()}",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                            Text('CMP:${data!.cmprate.toString()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                            SizedBox(
                                              height:40,
                                              width:110,
                                              child: Card(
                                                color: Colors.red,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left:18.0, right:10,top:7),
                                                  child: Text(
                                                    'Close order',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 10,
                                                      //color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ).onTap(() {}),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider()
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Center(child: Text('Error occurred: $error')),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: getportfolio == null
                  //       ? Center(child: CircularProgressIndicator()) // Show loading indicator
                  //       : ClipRRect(
                  //     borderRadius: BorderRadius.circular(12.0),
                  //     child: Table(
                  //       border: TableBorder.all(),
                  //       columnWidths: {
                  //         0: FlexColumnWidth(1),
                  //         1: FlexColumnWidth(1),
                  //       },
                  //       children: [
                  //         TableRow(children: [
                  //           _buildTableCell('Ledger Balance', getportfolio!.totalLedgerBalance?.toString() ?? 'N/A'),
                  //           _buildTableCell('Margin Available', getportfolio!.totalPlBalance?.toString() ?? 'N/A'),
                  //         ]),
                  //         TableRow(children: [
                  //           _buildTableCell('Active P/L', getportfolio!.totalMarginBalance?.toString() ?? 'N/A'),
                  //           _buildTableCell('M2M', getportfolio!.totalM2MBalance?.toString() ?? 'N/A'),
                  //         ]),
                  //       ],
                  //     ),
                  //   ),
                  // ),

                  portfolioCloseAsyncValue.when(
                    data: (portfolioCloseList) => Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Table(
                                border: TableBorder.all(),
                                columnWidths: {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(children: [
                                    _buildTableCell('Ledger Balance', portfolioCloseList.totalLedgerBalance ?? 'N/A'),
                                    _buildTableCell('Profit Loss', portfolioCloseList.totalPlBalance?.toString() ?? 'N/A'),
                                  ]),
                                  TableRow(children: [
                                    _buildTableCell('Total Brokrage', portfolioCloseList.totalBrokerage?.toString() ?? 'N/A'),
                                    _buildTableCell('Net Profit/Loss', portfolioCloseList.netProfitLoss?.toString() ?? 'N/A',),
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
                                            Text('${data!.categoryName.toString()}_${data!.expireDate.toString()}',
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                            Text("Avg:${data!.avgSellPrice.toString()}",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                            Row(
                                              children: [
                                                Text('Net Profit Loss:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                Text("${data!.plBalance.toString()}",
                                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                                              ],
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Text('Qty:', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                                Text('${data!.lot.toString()}',
                                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                              ],
                                            ),
                                            Text("Avg Buy:${data!.avgSellPrice.toString()}",
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                            Row(
                                              children: [
                                                Text('Brokerage:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                Text("${data!.brokerage.toString()}",
                                                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
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
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Center(child: Text('Error occurred: $error')),
                  ),
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
    child: Container(
          child: SizedBox(
            height:50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text(title, style: TextStyle(fontWeight: FontWeight.bold,color:Theme.of(context).extension<AppColors>()!.color1 == Colors.amber
                    ? Colors.amber // Golden theme
                    : Theme.of(context).brightness == Brightness.dark
                    ? Colors.blueGrey[900] // Dark theme
                    : Colors.black,),)),
                Expanded(child: Container(
                    child: Text(value, textAlign: TextAlign.end, style: TextStyle(fontWeight: FontWeight.bold,
                      color:Theme.of(context).extension<AppColors>()!.color1 == Colors.amber
                        ? Colors.amber // Golden theme
                        : Theme.of(context).brightness == Brightness.dark
                        ? Colors.blueGrey[900] // Dark theme
                        : Colors.black,)))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
