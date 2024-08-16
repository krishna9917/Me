import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Model/ActiveTrading.dart';
import '../Model/SellOrder.dart';
import '../Model/TradePending.dart';
import '../Services/Service_Api.dart';
import '../Utils/AppBar.dart';
import 'BuyScreen.dart';
import 'PopupBox.dart';

class TradesScreen extends ConsumerStatefulWidget {
  @override
  _TradesScreenState createState() => _TradesScreenState();
}

class _TradesScreenState extends ConsumerState<TradesScreen> {
  TradeList? Tradelist;
  TradeList? TradeActive;
  TradeList? TradeClose;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    PendingTrade();
    print("PendingTrade:$PendingTrade");
    print("Activeeeee");
    activeTrade();
    print("activeTrade:$activeTrade");
    print("Closeeeeeeeee");
    CloseTrade();
    print("CloseTrade:$CloseTrade");
   // _startPeriodicRefresh();
  }
  Timer? _refreshTimer;
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(Duration(seconds:1), (timer) {
      PendingTrade();
      activeTrade();
      CloseTrade();
    });
  }

  Future<void> PendingTrade() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final stdata = prefs.getString('apiToken');

      if (stdata != null && stdata.isNotEmpty) {
        // final loginModel = loginModelFromJson(stdata);
        // final token = loginModel.token;
        //
        // if (token != null && token.isNotEmpty) {
        var bodyFields = {
          'userID': '145',
          'status': '1'
        };
        var result = await ServicesApi().postApiWithData(
            'bXdSSmNIOHFOS2RoQTNES0hJYndwNmxjS1ZzbkVzZzVNSWdOVHZqRm'
                'h0MUFLNTJhSXZFYUdiQzVWS2Z3Z0V5TTNTejI1WWFoRm5MTWFJcTNlczJPajRlMk9qQ2dtZ3dYcExWVU1Laml4SlE9',
            'https://www.onlinetradelearn.com/mcx/authController/getTradeList', bodyFields,ref
        );

        Tradelist = tradeListFromJson(result);

        if (Tradelist?.data != null) {
          Tradelist!.data!.forEach((datum) {
            if (datum.bidType == "1") {
              datum.bidType = "buyX1";
            } else if (datum.bidType == "2") {
              datum.bidType = "sellX1";
            }

            if (datum.orderType == "1") {
              datum.orderType = "market";
            } else if (datum.orderType == "2") {
              datum.orderType = "order";
            } else if (datum.orderType == "3") {
              datum.orderType = "SL";
            }
          });
        }

        setState(() {
          isLoading = false;
        });
      } else {
        print('API token is not available or is empty');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error occurred: $e');
    }
  }

  Future<void> activeTrade() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final stdata = prefs.getString('apiToken');
      print("stdata: $stdata");
      print("222");

      if (stdata != null && stdata.isNotEmpty) {
        // final loginModel = loginModelFromJson(stdata);
        // final token = loginModel.token;
        //
        // if (token != null && token.isNotEmpty) {
        var bodyFields = {
          'userID': '145',
          'status': '2'
        };
        var result = await ServicesApi().postApiWithData(
            'bXdSSmNIOHFOS2RoQTNES0hJYndwNmxjS1ZzbkVzZzVNSWdOVHZqRm'
                'h0MUFLNTJhSXZFYUdiQzVWS2Z3Z0V5TTNTejI1WWFoRm5MTWFJcTNlczJPajRlMk9qQ2dtZ3dYcExWVU1Laml4SlE9',
            'https://www.onlinetradelearn.com/mcx/authController/getTradeList', bodyFields,ref
        );

        print("Resulttt: $result");

        TradeActive = tradeListFromJson(result);
        if (TradeActive?.data != null) {
          TradeActive!.data!.forEach((datum) {
            if (datum.bidType == "1") {
              datum.bidType = "buyX1";
            } else if (datum.bidType == "2") {
              datum.bidType = "sellX1";
            }

            if (datum.orderType == "1") {
              datum.orderType = "market";
            } else if (datum.orderType == "2") {
              datum.orderType = "order";
            } else if (datum.orderType == "3") {
              datum.orderType = "SL";
            }
          });
        }

        setState(() {
          isLoading = false;
        });
      } else {
        print('API token is not available or is empty');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error occurred: $e');
    }
  }

  Future<void> CloseTrade() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final stdata = prefs.getString('apiToken');
      print("stdata: $stdata");
      print("222");

      if (stdata != null && stdata.isNotEmpty) {
        // final loginModel = loginModelFromJson(stdata);
        // final token = loginModel.token;
        //
        // if (token != null && token.isNotEmpty) {
        var bodyFields = {
          'userID': '145',
          'status': '3'
        };
        var result = await ServicesApi().postApiWithData(
            'bXdSSmNIOHFOS2RoQTNES0hJYndwNmxjS1ZzbkVzZzVNSWdOVHZqRm'
                'h0MUFLNTJhSXZFYUdiQzVWS2Z3Z0V5TTNTejI1WWFoRm5MTWFJcTNlczJPajRlMk9qQ2dtZ3dYcExWVU1Laml4SlE9',
            'https://www.onlinetradelearn.com/mcx/authController/getTradeList', bodyFields,ref
        );

        print("Resulttt: $result");

        TradeClose = tradeListFromJson(result);
        if (TradeClose?.data != null) {
          TradeClose!.data!.forEach((datum) {
            if (datum.bidType == "1") {
              datum.bidType = "buyX1";
            } else if (datum.bidType == "2") {
              datum.bidType = "sellX1";
            }

            if (datum.orderType == "1") {
              datum.orderType = "market";
            } else if (datum.orderType == "2") {
              datum.orderType = "order";
            } else if (datum.orderType == "3") {
              datum.orderType = "SL";
            }

            // Set colors based on values

            double? totalProfit = double.tryParse(datum.totalProfit ?? '0');
            double? brokerage = double.tryParse(datum.brokerage ?? '0');

          final  totalProfitColor = totalProfit != null && totalProfit < 0 ? Colors.red : Colors.green;
            final brokerageColor = brokerage != null && brokerage < 0 ? Colors.red : Colors.green;
          });
        }

        setState(() {
          isLoading = false;
        });
      } else {
        print('API token is not available or is empty');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error occurred: $e');
    }
  }


  Future<void> TradeCancel(BuildContext context, String? orderID, String type) async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final stdata = prefs.getString('apiToken');
      print("stdata: $stdata");

      if (stdata != null && stdata.isNotEmpty) {
        var bodyFields = {
          'userID': '145',
          'orderID': orderID ?? '',
          'type': type
        };

        var result = await ServicesApi().postApiWithData(
            "bXdSSmNIOHFOS2RoQTNES0hJYndwNmxjS1ZzbkVzZzVNSWdOVHZqRmh0MUFLNTJhSXZFYUdiQzVWS2Z3Z0V5TTNTejI1WWFoRm5M"
                "TWFJcTNlczJPajRlMk9qQ2dtZ3dYcExWVU1Laml4SlE9",
            'https://www.onlinetradelearn.com/mcx/authController/closeCancelTrade',
            bodyFields,ref
        );

        print("Result: $result");

        if (result == null || result.isEmpty) {
          print("Result is null or empty");
          return;
        }

        Map<String, dynamic> jsonResponse;
        try {
          jsonResponse = json.decode(result);
        } catch (e) {
          print("Error parsing JSON: $e");
          return;
        }

        print("Parsed JSON Response: $jsonResponse");

        final status = jsonResponse['status']?.toString() ?? '';
        final message = jsonResponse['message'] ?? '';

        if (mounted) {
          if (status == '0') {
            print("Status is 0, showing popup.");
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => SizedBox(
                height: 100,
                child: AlertDialog(
                  title: Center(
                    child: Column(
                      children: [
                        Icon(Icons.cancel_outlined, color: Colors.red, size: 40),
                        Text('Failed'),
                      ],
                    ),
                  ),
                  content: Text(message),
                  actions: <Widget>[
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          shadowColor: Colors.black,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Close'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (status == '1') {
            print("Status is 1, showing popup.");
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: Colors.black12,
                ),
                child: SizedBox(
                  height: 100,
                  child: AlertDialog(
                    title: Center(
                      child: Column(
                        children: [
                          Icon(Icons.check_circle_outline, color: Colors.green, size: 40),
                          Text('Success',style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    content: Container(
                        child: Text(message,style: TextStyle(color: Colors.black),)),
                    actions: <Widget>[
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.black,
                            shadowColor: Colors.black,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                              side: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }

        if (type == '1') {
          await activeTrade();
        } else {
          await PendingTrade();
        }

        setState(() {
          isLoading = false;
        });
      } else {
        print('API token is not available or is empty');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error occurred: $e');
    }
  }

  void showPopup1(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //  title: Text('Notification'),
          content: Text("Are you sure you want to delete all MCX orders"),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.white,
                shadowColor: Colors.white, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Border radius
                ),
              ),
              child: Text('Decline'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.black,
                shadowColor: Colors.black, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Border radius
                ),
              ),
              child: Text('Confirm'),
              onPressed: () {
                TradeCancel(context,"1","5");
              },
            ),
          ],
        );
      },
    );
  }
  void showPopup2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to delete all NSE orders?"),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.white,
                shadowColor: Colors.white, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Border radius
                ),
              ),
              child: Text('Decline'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.black,
                shadowColor: Colors.black, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Border radius
                ),
              ),
              child: Text('Confirm'),
              onPressed: () {
                TradeCancel(context,"2","5");
              },
            ),
          ],
        );
      },
    );
  }
  void showPopup3(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Close All MCX Orders?"),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.white,
                shadowColor: Colors.white, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Border radius
                ),
              ),
              child: Text('Decline'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.black,
                shadowColor: Colors.black, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Border radius
                ),
              ),
              child: Text('Confirm'),
              onPressed: () {
                TradeCancel(context,"1","4");
              },
            ),
          ],
        );
      },
    );
  }
  void showPopup4(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Close All NSE Orders?"),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.white,
                shadowColor: Colors.white, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Border radius
                ),
              ),
              child: Text('Decline'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.black,
                shadowColor: Colors.black, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Border radius
                ),
              ),
              child: Text('Confirm'),
              onPressed: () {
                TradeCancel(context,"2","4");
              },
            ),
          ],
        );
      },
    );
  }
  void showPopup5(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Cancel order"),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.white,
                shadowColor: Colors.white, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Border radius
                ),
              ),
              child: Text('Decline'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.black,
                shadowColor: Colors.black, // Shadow color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // Border radius
                ),
              ),
              child: Text('Confirm'),
              onPressed: () {
                TradeCancel(context,"1","1");
              },
            ),
          ],
        );
      },
    );
  }

  Color _bidTypeColor(String? bidType,) {
    if (bidType == "sellX1") return Colors.red;
    if (bidType == "buyX1") return Colors.green;
    return Colors.black; // Default color
  }
  Color orderTypecolor( String? orderType) {
    if (orderType == "market") return Colors.green;
    if (orderType == "SL") return Colors.red;
    if (orderType == "order" ) return Colors.red;
    return Colors.black; // Default color
  }
  Color _getbidBorderColor(String? bidType, ) {
    if (bidType == "sellX1") return Colors.red;
    if (bidType == "buyX1") return Colors.green;
    return Colors.black; // Default border color
  }
  Color _getorderBorderColor( String? orderType) {
    if (orderType == "market") return Colors.green;
    if (orderType == "SL") return Colors.red;
    if (orderType == "order" ) return Colors.red;
    return Colors.black; // Default border color
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(ref: ref),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
             // color: Colors.black,
              child: TabBar(
                tabs: [
                  Tab(child: Center(child: Text('Pending',
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.amber))),),
                  Tab(child: Center(child: Text('Active',
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green))),),
                  Tab(child: Center(child: Text('Close',
                      style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red))),),
                ],
                labelStyle: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 12.0,
                ),

                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.amber.shade700,
              ),
            ),

            Expanded(
              child: TabBarView(
                children: [
                 Column(
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children:[
                         Card(
                           color:Colors.red,
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text('Cancel All the pednding MCX orders',
                                 style:TextStyle(fontWeight: FontWeight.bold,fontSize:8,)),
                           ),
                         ).onTap((){showPopup1(context);

                         }),
                         Card(
                           color:Colors.red,
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Text('Cancel All the pednding NSE orders',
                                 style:TextStyle(fontWeight: FontWeight.bold,fontSize:8,)),
                           ),
                         ).onTap((){showPopup2(context);},),
                       ]
                     ),
                     isLoading
                         ? Center(
                       child: Image.asset('assets/loader.png'),
                     )
                         : Tradelist != null
                         ?SizedBox(
                       height: MediaQuery.of(context).size.height * 0.7,
                       child: Tradelist != null && Tradelist?.data!= null
                           ? ListView.builder(
                         padding: const EdgeInsets.all(8.0),
                         itemCount: Tradelist?.data?.length ?? 0,
                         itemBuilder: (context, index) {
                           final trade = Tradelist?.data?[index];
                           return Column(
                             children: [
                               Row(
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         Row(
                                           children: [
                                             Container(
                                               decoration: BoxDecoration(
                                                 borderRadius: BorderRadius.circular(6),
                                                 border: Border.all(
                                                   color: _getbidBorderColor(trade?.bidType),
                                                   width: 2, // Border width
                                                 ),
                                               ),
                                               child: Padding(
                                                 padding: const EdgeInsets.all(3.0),
                                                 child: Text(
                                                   '${trade?.bidType}',
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 8,
                                                     color: _bidTypeColor(trade?.bidType),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                             SizedBox(width: 8),
                                             Container(
                                               decoration: BoxDecoration(
                                                 borderRadius: BorderRadius.circular(6),
                                                 border: Border.all(
                                                   color: _getorderBorderColor(trade?.orderType),
                                                   width: 2, // Border width
                                                 ),
                                               ),
                                               child: Padding(
                                                 padding: const EdgeInsets.all(3.0),
                                                 child: Text(
                                                   '${trade?.orderType}',
                                                   style: TextStyle(
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 8,
                                                     color: orderTypecolor(trade?.orderType),
                                                   ),
                                                 ),
                                               ),
                                             ),
                                           ],
                                         ),
                                         Text(
                                           '${trade?.categoryName}_${trade?.expireDate}',
                                           style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                             fontSize: 11,
                                           ),
                                         ),
                                         Text(
                                           'Sold by null',
                                           style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                             fontSize: 9,
                                           ),
                                         ),
                                         Text(
                                           '${trade?.orderDateTime}',
                                           style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                             fontSize: 9,
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                   Spacer(),
                                   Padding(
                                     padding: const EdgeInsets.all(8.0),
                                     child: Column(
                                       crossAxisAlignment: CrossAxisAlignment.end,
                                       children: [
                                         Container(
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(6),
                                             border: Border.all(
                                               color: _getbidBorderColor(trade?.bidType),
                                               width: 2, // Border width
                                             ),
                                           ),
                                           child: Padding(
                                             padding: const EdgeInsets.all(3.0),
                                             child: Text(
                                               '${trade?.bidPrice}',
                                               style: TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 9,
                                                 color: _bidTypeColor(trade?.bidType),
                                               ),
                                             ),
                                           ),
                                         ),
                                         SizedBox(height: 4),
                                         Card(
                                           color: Colors.red,
                                           child: Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Text(
                                               'Cancel order',
                                               style: TextStyle(
                                                 fontWeight: FontWeight.bold,
                                                 fontSize: 8,

                                               ),
                                             ),
                                           ),
                                         ).onTap(() {
                                           TradeCancel(context, "2", "4");
                                         }),
                                         Text(
                                           'Margin used:${trade?.intradayMargin}',
                                           style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                             fontSize: 9,
                                           ),
                                         ),
                                         Text(
                                           'Holding Mar.Req.:${trade?.holdingMargin}',
                                           style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                             fontSize: 9,
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ],
                               ),
                               Divider(),
                             ],
                           ).onTap(()async {
                             print("Tapped!");
                             final double? bidPrice = double.tryParse(trade?.bidPrice ?? '0');
                             final double? sellPrice = double.tryParse(trade?.sellPrice ?? '0');
                             await Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context) => BuyScreen(
                                   categoryId: '${trade?.categoryName}',
                                   identifier: "${trade?.token}",
                                   title: "${trade?.categoryName}",
                                   expiryDate: "${trade?.expireDate}",
                                   buyprice: bidPrice ?? 0.0, // Provide default value if parsing fails
                                   sellprice: sellPrice ?? 0.0, // Provide default value if parsing fails
                                 ),
                               ),
                             );
                             print("qqqqqqqqqqqqqqqqqqqqqqqqq!");
                           }
                           );
                         },
                       )
                           : Center(child: Text('No data available')),
                     )
                         : Center(child: Text('No data available')),
                   //  Divider(),
                   ],
                 ),
                  Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            Card(
                              color:Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Cancel All MCX orders',
                                    style:TextStyle(fontWeight: FontWeight.bold,fontSize:10,color:Colors.black)),
                              ).onTap((){showPopup3(context);}),
                            ),
                            Card(
                              color:Colors.red,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Cancel All NSE orders',
                                    style:TextStyle(fontWeight: FontWeight.bold,fontSize:10,color:Colors.black)),
                              ).onTap((){showPopup4(context);}),
                            ),
                          ]
                      ),
                      isLoading
                          ? Center(
                        child: Image.asset('assets/loader.png'),
                      )
                          : TradeActive != null
                          ?SizedBox(
                        height: MediaQuery.of(context).size.height * 0.71,
                        child: TradeActive != null && TradeActive?.data != null
                            ? ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: TradeActive?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final trade = TradeActive?.data?[index];
                            return Column(
                              children: [

                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: _getbidBorderColor(trade?.bidType),
                                                    width: 2, // Border width
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    '${trade?.bidType}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 8,
                                                      color: _bidTypeColor(trade?.bidType),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: _getorderBorderColor(trade?.orderType),
                                                    width: 2, // Border width
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    '${trade?.orderType}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 8,
                                                      color: orderTypecolor(trade?.orderType),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${trade?.categoryName}_${trade?.expireDate}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                          Text(
                                            'Sold by null',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 9,
                                            ),
                                          ),
                                          Text(
                                            '${trade?.orderDateTime}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(
                                                color: _getbidBorderColor(trade?.bidType),
                                                width: 2, // Border width
                                              ),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(3.0),
                                              child: Text(
                                                '${trade?.bidPrice}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 9,
                                                  color: _bidTypeColor(trade?.bidType),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          SizedBox(
                                            height:35,
                                            child: Card(
                                              color: Colors.red,
                                              child: Padding(
                                                padding: const EdgeInsets.all(6.0),
                                                child: Text(
                                                  'Close order',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 10,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ).onTap(() {TradeCancel(context,"1","3");
                                                                                     //  showPopup5(context);
                                            }),
                                          ),
                                          Text(
                                            'Margin used: ${trade?.intradayMargin}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 9,
                                            ),
                                          ),
                                          Text(
                                            'Holding Mar.Req.: ${trade?.holdingMargin}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 9,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                              ],
                            );
                          },
                        )
                            : Center(child: Text('No data available')),
                      )
                          : Center(child: Text('No data available')),

                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.748,
                        child: isLoading
                            ? Center( child: Image.asset('assets/loader.png'),)
                            : (TradeClose?.data?.isNotEmpty ?? false)
                            ? ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: TradeClose?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final trade = TradeClose!.data?[index];
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${trade!.categoryName}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            '${trade.expireDate}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                'Sold by Trader',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: Colors.red,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    '${trade.bidPrice}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 8,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${trade.orderDateTime}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: Colors.green,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    '${trade.totalProfit}/${trade.brokerage}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 8,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: Colors.green,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    'QTY:${trade.lot}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 8,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                'Brought By Trader',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: Colors.green,
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    '${trade.sellPrice}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 8,
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Text(
                                                '${trade.orderUpdateDateTime}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  border: Border.all(
                                                    color: _getorderBorderColor(trade.orderType),
                                                    width: 2,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    '${trade.orderType}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 8,
                                                      color: orderTypecolor(trade.orderType),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(),
                              ],
                            );
                          },
                        )
                            : Center(child: Text('No data available')),
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
