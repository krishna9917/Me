import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Model/LiveRateTokenModel.dart';
import '../Model/SellOrder.dart';
import '../Services/Service_Api.dart';
import '../Utils/Themepopup.dart';

final exampleProvider = Provider<int>((ref) => 42);
class BuyScreen extends ConsumerStatefulWidget  {
  final double buyprice;
  final double sellprice;
  final String categoryId;
  final String identifier;
  final String title;
  final String expiryDate;

  BuyScreen({
    required this.categoryId,
    required this.title,
    required this.expiryDate,
    required this.buyprice,
    required this.sellprice,
    required this.identifier,
  });

  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends ConsumerState<BuyScreen> with SingleTickerProviderStateMixin {
 // late AnimationController _controller;

  double containerHeight = 260.0;
  String lotsize = '1';
  String? ordertype, bidprice;
  PlaceOrder? placeOrder;
  List<LiveRateToken> liveRateTokens = [];
  bool hasError = false;
  Timer? _refreshTimer;
  Future<void> orderPlace() async {
    setState(() {
   //   isLoading = true;
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
          'catID': widget.categoryId,
          'exipreDate': widget.expiryDate,
          'orderType': ordertype ?? '',
          'bidType': Bidtype ?? '',
          'bidPrice': bidprice ?? (Bidtype == '1' ? widget.buyprice.toString() : widget.sellprice.toString()),
          'lotSize': lotsize,
        };
        print("body data:$bodyFields");

        var result = await ServicesApi().postApiWithData(
          'bXdSSmNIOHFOS2RoQTNES0hJYndwNmxjS1ZzbkVzZzVNSWdOVHZqRm'
              'h0MUFLNTJhSXZFYUdiQzVWS2Z3Z0V5TTNTejI1WWFoRm5MTWFJcTNlczJPajRlMk9qQ2dtZ3dYcExWVU1Laml4SlE9',
          'https://www.onlinetradelearn.com/mcx/authController/orderAuth',
          bodyFields, ref
        );

        print("Resulttt: $result");

        if (result != null) {
          print("Status Code: ${result}");
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
              builder: (BuildContext context) => SizedBox(
                height: 100,
                child: AlertDialog(
                  title: Center(
                    child: Column(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green, size: 40),
                        Text('Success'),
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
          }

        setState(() {
        //  isLoading = false;
        });
      } else {
        print('API token is not available or is empty');
        setState(() {
         // isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
       // isLoading = false;
      });
      print('Error occurred: $e');
    }
  }
  fetchLiveData() async {
    try {
      // final loginModel = loginModelFromJson(stdata);
      // final token = loginModel.token;
      //
      // if (token != null && token.isNotEmpty) {
      var responseString = await ServicesApi().get_ApiwithHeader(
        "https://www.onlinetradelearn.com/mcx/authController/getLiveRate?userID=145&token=${widget.identifier}",
        "bXdSSmNIOHFOS2RoQTNES0hJYndwNmxjS1ZzbkVzZzVNSWdOVHZqRmh0MUFLNTJhSXZFYUdiQzVWS2Z3Z0V5TTNTejI1WWFoRm5MTWF"
            "JcTNlczJPajRlMk9qQ2dtZ3dYcExWVU1Laml4SlE9", ref
      );

      final jsonResponse = jsonDecode(responseString);
      final List<dynamic> dataList = jsonResponse['livedata'];

      final fetchedLiveRateTokens = dataList.map((json) {
        return LiveRateToken.fromJson({
          'Exchange': json['Exchange'] ?? '',
          'InstrumentIdentifier': json['InstrumentIdentifier'] ?? '',
          'AverageTradedPrice': _parseDouble(json['AverageTradedPrice']),
          'BuyPrice': _parseDouble(json['BuyPrice']),
          'Close': _parseDouble(json['Close']),
          'High': _parseInt(json['High']),  // Convert to int if expected as int
          'Low': _parseDouble(json['Low']),
          'LastTradePrice': _parseDouble(json['LastTradePrice']),
          'Open': _parseDouble(json['Open']),
          'OpenInterest': _parseInt(json['OpenInterest']),  // Safely parse as int
          'QuotationLot': _parseInt(json['QuotationLot']),  // Safely parse as int
          'SellPrice': _parseDouble(json['SellPrice']),
          'PriceChange': _parseDouble(json['PriceChange']),
          'PriceChangePercentage': _parseDouble(json['PriceChangePercentage']),
          'LowerCircuit': _parseDouble(json['LowerCircuit']),
          'UpperCircuit': _parseDouble(json['UpperCircuit']),
          'LastTradeTime': _parseInt(json['LastTradeTime']),  // Safely parse as int
          'ServerTime': _parseInt(json['ServerTime']),  // Safely parse as int
          'BuyQty': _parseInt(json['BuyQty']),  // Safely parse as int
          'LastTradeQty': _parseInt(json['LastTradeQty']),  // Safely parse as int
          'SellQty': _parseInt(json['SellQty']),  // Safely parse as int
          'TotalQtyTraded': _parseInt(json['TotalQtyTraded']),  // Safely parse as int
          'Value': _parseInt(json['Value']),  // Safely parse as int
          'PreOpen': json['PreOpen'] == null ? null : (json['PreOpen'] as bool),
          'MessageType': json['MessageType'] ?? '',
          'OpenInterestChange': _parseInt(json['OpenInterestChange']),  // Safely parse as int
        });
      }).toList();

      if (mounted) {
        setState(() {
          liveRateTokens = fetchedLiveRateTokens;
          hasError = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          hasError = true;
        });
      }
    }
  }

  double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }



  late TabController _tabController;
  String Bidtype = '1';
  String _textFieldValue = '1';
  String _textFieldValue2 = '';

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchLiveData();
    _startPeriodicRefresh();
    _tabController = TabController(length: 3, vsync: this);
    Bidtype = '1';
    // _tabController.addListener(() {
    //
    // });
    _textEditingController.text = _textFieldValue2;
    _tabController.addListener(() {
      setState(() {
        if (_tabController.index == 0) {
          Bidtype = '1';
        } else if (_tabController.index == 1) {
          Bidtype = '2';
        } else if (_tabController.index == 2) {
          Bidtype = '3';
        }
      });
      setState(() {
        if (_tabController.index == 0) {
          containerHeight = 250.0;
        } else {
          containerHeight = 319.0;
        }
      });
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    _refreshTimer?.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      fetchLiveData();
    });
  }

  bool _isTextFieldValid = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        actions: [
          IconButton(
            icon: Image.asset('assets/theme.png'),
            onPressed: () {
           //   showThemeSelectionDialog(context, ref);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
         // height: MediaQuery.of(context).size.height*0.8,
          child: Column(
            children: [
              Container(
                height:containerHeight,

                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${widget.title}_${widget.expiryDate}",
                          style: TextStyle(fontSize: 15,color: Colors.black ),
                        ),
                        10.height,
                        Container(
                          width: 230,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black12,
                          ),
                          child: TabBar(
                            controller: _tabController,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(
                                left: _tabController.index == 0 ? Radius.circular(10) : Radius.zero,
                                right: _tabController.index == 2 ? Radius.circular(10) : Radius.zero,
                              ),
                              color: Colors.black,
                            ),
                            isScrollable: false,
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black,
                            labelStyle: TextStyle(fontSize: 11),
                            unselectedLabelStyle: TextStyle(fontSize: 11),
                            tabs: [
                              Tab(text: 'Market'),
                              Tab(text: 'Limit'),
                              Tab(text: 'SL'),
                            ],
                            onTap: (index) {
                              setState(() {
                                if (index == 0) {
                                  Bidtype = '1';
                                } else if (index == 1) {
                                  Bidtype = '2';
                                } else if (index == 2) {
                                  Bidtype = '3';
                                }
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                              controller: _tabController,
                              children: [
                            buildTabContent(showBidPrice: false),
                            buildTabContent(showBidPrice: true),
                            buildTabContent(showBidPrice: true),
                          ]),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
              50.height,
              SizedBox(
                height: MediaQuery.of(context).size.height*0.7,
                child: ListView.builder(
                  itemCount: liveRateTokens.length,
                  itemBuilder: (context, index) {
                    final data = liveRateTokens[index];
                    return  Card(
                      color:Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(left:8.0, right:35,top:10,bottom:10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Bid", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.buyPrice.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Open", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.open.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("High", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.high.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Buyers", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.quotationLot.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Upper CKT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.upperCircuit.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Last Buy", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.quotationLot.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Ask", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.sellPrice.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Close", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.close.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Low", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.low.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Sellers", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.sellQty.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Lower CKT", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.lowerCircuit.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Last Sell", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.sellQty.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Last P.", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.lastTradePrice.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Volume", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.totalQtyTraded.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Change", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.priceChange.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Open Interest", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.openInterest.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("ATP", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.averageTradedPrice.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text("Lot Size", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                        Text(data.sellQty.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 10)),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );

                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildTabContent({required bool showBidPrice}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            children: [
              SizedBox(height: 10),
              Text("Enter the Lots you want to buy:", style: TextStyle(fontSize: 10,color: Colors.black)),
              Container(
                width: 300,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  initialValue: lotsize,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      lotsize = value;
                    });
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                ),
              ),
              if (showBidPrice) ...[
                SizedBox(height: 10),
                Text("Enter the price you want to buy", style: TextStyle(color: Colors.black, fontSize: 10.0)),
                Container(
                  width: 300,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _textFieldValue2 = value;
                        _isTextFieldValid = true; // Reset the error state when user types
                      });
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      error: _isTextFieldValid
                          ? null
                          : Icon(Icons.error, color: Colors.red),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        setState(() {
                          _isTextFieldValid = false;
                        });
                        return '';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 20), // Space between content and buttons
        Row(
          children: [
            SizedBox(
              width: 176.3,
              child: ElevatedButton(
                onPressed: () {
                  ordertype = '2';
                  bidprice = _textEditingController.text.isEmpty
                      ? "${widget.sellprice}"
                      : _textEditingController.text;
                  orderPlace();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15), // Match the card's border radius
                    ),
                  ),
                  fixedSize: Size(170, 50),
                ),
                child: Column(
                  children: [
                    Text("Sell@"),
                    Text("${_textEditingController.text.isEmpty
                        ? "${widget.sellprice}"
                        : _textEditingController.text}"),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 176.3,
              child: ElevatedButton(
                onPressed: () {
                  ordertype = '1';
                  bidprice = _textEditingController.text.isEmpty
                      ? "${widget.buyprice}"
                      : _textEditingController.text;
                  orderPlace();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.green[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15), // Match the card's border radius
                    ),
                  ),
                  fixedSize: Size(170, 50),
                ),
                child: Column(
                  children: [
                    Text("Buy@"),
                    Text("${_textEditingController.text.isEmpty
                        ? "${widget.buyprice}"
                        : _textEditingController.text}"),
                  ],
                ),
              ),
            ),
          ],
        ),

      ],
    );
  }
}


