import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/Dialogs/AlertBox.dart';
import 'package:me_app/Model/LiveRate.dart';
import 'package:me_app/Model/StatusMessage.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:nb_utils/nb_utils.dart';
import '../ApiService/ApiInterface.dart';
import '../Model/GetMCXModel.dart';
import '../Resources/ImagePaths.dart';
import '../Resources/Strings.dart';
import '../Utils/AppBar.dart';
import '../Utils/AppTheme.dart';
import '../Utils/HelperFunction.dart';

class StockDetailScreen extends ConsumerStatefulWidget {
  Datum stockData;

  StockDetailScreen({super.key, required this.stockData});

  @override
  _StockDetailScreenState createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends ConsumerState<StockDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _textEditingController = TextEditingController();
  String lotSize = '1';
  bool _isTextFieldValid = true;
  Timer? _refreshTimer;
  Livedata? data;

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (mounted) {
        if (await HelperFunction.isInternetConnected(context)) {
          fetchData();
        }
      } else {
        _refreshTimer?.cancel();
      }
    });
  }

  Future<void> placeAnOrder(bool isSellType) async {
    StatusMessage? response = await ApiInterface.placeOrder(
        context,
        widget.stockData.categoryId.toString(),
        widget.stockData.expireDate.toString(),
        (_tabController.index + 1).toString(),
        (isSellType ? 2 : 1).toString(),
        _tabController.index > 0
            ? _textEditingController.text.toString()
            : isSellType && _tabController.index == 0
                ? data!.sellPrice.toString()
                : data!.buyPrice.toString(),
        lotSize);
    AlertBox.showStatus(context, response!.message!, response.status == 0);
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _startPeriodicRefresh();
    super.initState();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: CustomAppBar(
          ref: ref,
          showBackButton: true,
        ),
        body: data != null
            ? Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                    child: Column(children: [
                  Card(
                    color: Colors.white,
                    elevation: 6,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            children: [
                              Text(
                                "${widget.stockData.title}_${widget.stockData.expireDate}",
                                style: Styles.normalText(isBold: true),
                              ),
                              25.height,
                              Padding(
                                padding: const EdgeInsets.only(right: 35),
                                child: SizedBox(
                                  height: 35,
                                  child: TabBar(
                                      isScrollable: true,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      dividerColor: Colors.transparent,
                                      labelPadding: EdgeInsets.zero,
                                      controller: _tabController,
                                      labelStyle:
                                          Styles.normalText(isBold: true),
                                      labelColor: Colors.white,
                                      unselectedLabelStyle: Styles.normalText(),
                                      indicator: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.horizontal(
                                          left: _tabController.index == 0
                                              ? const Radius.circular(10)
                                              : Radius.zero,
                                          right: _tabController.index == 2
                                              ? const Radius.circular(10)
                                              : Radius.zero,
                                        ),
                                      ),
                                      tabs: List.generate(3, (index) {
                                        bool isSelected =
                                            _tabController.index == index;
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Colors.transparent
                                                : Colors.grey.shade300,
                                            // Change the color as needed
                                            borderRadius:
                                                BorderRadius.horizontal(
                                              left: index == 0
                                                  ? const Radius.circular(10)
                                                  : Radius.zero,
                                              right: index == 2
                                                  ? const Radius.circular(10)
                                                  : Radius.zero,
                                            ),
                                          ),
                                          child: Tab(
                                            text: index == 0
                                                ? Strings.market
                                                : index == 1
                                                    ? Strings.limit
                                                    : Strings.sl,
                                          ),
                                        );
                                      }),
                                      onTap: (index) {
                                        setState(() {});
                                      }),
                                ),
                              ),
                              15.height,
                              SizedBox(
                                height: _tabController.index == 0 ? 100 : 170,
                                child: TabBarView(
                                    controller: _tabController,
                                    children: [
                                      buildTabContent(showBidPrice: false),
                                      buildTabContent(showBidPrice: true),
                                      buildTabContent(showBidPrice: true)
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  placeAnOrder(true);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.red,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(
                                          15), // Match the card's border radius
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Sell@",
                                        style: Styles.normalText(isBold: true),
                                      ),
                                      Text(
                                          _textEditingController.text.isEmpty
                                              ? "${data != null ? data?.sellPrice : widget.stockData.salePrice}"
                                              : _textEditingController.text,
                                          style: Styles.normalText(
                                              isBold: true, fontSize: 17)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  placeAnOrder(false);
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  backgroundColor: Colors.green[700],
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(
                                          15), // Match the card's border radius
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        "Buy@",
                                        style: Styles.normalText(isBold: true),
                                      ),
                                      Text(
                                        _textEditingController.text.isEmpty
                                            ? "${data != null ? data?.buyPrice : widget.stockData.buyPrice}"
                                            : _textEditingController.text,
                                        style: Styles.normalText(
                                            isBold: true, fontSize: 17),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  30.height,
                  Card(
                    elevation: 6,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            _buildTableCell(
                                Strings.bid,
                                !data!.buyPrice.toString().isEmptyOrNull
                                    ? data!.buyPrice.toString()
                                    : Strings.na),
                            _buildTableCell(
                                Strings.ask,
                                !data!.sellPrice.toString().isEmptyOrNull
                                    ? data!.sellPrice.toString()
                                    : Strings.na),
                            _buildTableCell(
                                Strings.lastP,
                                !data!.lastTradePrice.toString().isEmptyOrNull
                                    ? data!.lastTradePrice.toString()
                                    : Strings.na)
                          ]),
                          TableRow(children: [
                            _buildTableCell(
                                Strings.open,
                                !data!.open.toString().isEmptyOrNull
                                    ? data!.open.toString()
                                    : Strings.na),
                            _buildTableCell(
                                Strings.close,
                                !data!.close.toString().isEmptyOrNull
                                    ? data!.close.toString()
                                    : Strings.na),
                            _buildTableCell(
                                Strings.volume,
                                !data!.totalQtyTraded.toString().isEmptyOrNull
                                    ? data!.totalQtyTraded.toString()
                                    : Strings.na)
                          ]),
                          TableRow(children: [
                            _buildTableCell(
                                Strings.high,
                                !data!.high.toString().isEmptyOrNull
                                    ? data!.high.toString()
                                    : Strings.na),
                            _buildTableCell(
                                Strings.low,
                                !data!.low.toString().isEmptyOrNull
                                    ? data!.low.toString()
                                    : Strings.na),
                            _buildTableCell(
                                Strings.change,
                                !data!.priceChange.toString().isEmptyOrNull
                                    ? data!.priceChange.toString()
                                    : Strings.na)
                          ]),
                          TableRow(children: [
                            _buildTableCell(
                                Strings.buyers,
                                !data!.buyQty.toString().isEmptyOrNull
                                    ? data!.buyQty.toString()
                                    : Strings.na),
                            _buildTableCell(
                                Strings.sellers,
                                !data!.sellQty.toString().isEmptyOrNull
                                    ? data!.sellQty.toString()
                                    : Strings.na),
                            _buildTableCell(
                                Strings.openInterest,
                                !data!.openInterest.toString().isEmptyOrNull
                                    ? data!.openInterest.toString()
                                    : Strings.na)
                          ]),
                          TableRow(children: [
                            _buildTableCell(
                                Strings.upperCkt,
                                !data!.upperCircuit.toString().isEmptyOrNull
                                    ? data!.upperCircuit.toString()
                                    : Strings.na),
                            _buildTableCell(
                                Strings.lowerCkt,
                                !data!.lowerCircuit.toString().isEmptyOrNull
                                    ? data!.lowerCircuit.toString()
                                    : Strings.na),
                            _buildTableCell(
                                Strings.atp,
                                !data!.averageTradedPrice
                                        .toString()
                                        .isEmptyOrNull
                                    ? data!.averageTradedPrice.toString()
                                    : Strings.na)
                          ]),
                          TableRow(children: [
                            _buildTableCell(
                                Strings.lastBuy,
                                !data!.buyQty.toString().isEmptyOrNull
                                    ? data!.buyQty.toString()
                                    : Strings.na),
                            _buildTableCell(
                                Strings.lastSell,
                                !data!.sellQty.toString().isEmptyOrNull
                                    ? data!.sellQty.toString()
                                    : Strings.na),
                            _buildTableCell(
                                Strings.lotSize,
                                !data!.quotationLot.toString().isEmptyOrNull
                                    ? data!.quotationLot.toString()
                                    : Strings.na)
                          ])
                        ],
                      ),
                    ),
                  )
                ])),
              )
            : Center(
                child: Text(
                  Strings.dataNotAvailable,
                  style: Styles.normalText(),
                ),
              ));
  }

  Widget buildTabContent({required bool showBidPrice}) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              10.height,
              Text(Strings.enterLotSize, style: Styles.normalText()),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  textAlign: TextAlign.center,
                  initialValue: lotSize,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      lotSize = value;
                    });
                  },
                  style: Styles.normalText(),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                ),
              ),
              if (showBidPrice) ...[
                10.height,
                Text(Strings.enterPrice, style: Styles.normalText()),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: Styles.normalText(isBold: true),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      error: _isTextFieldValid
                          ? null
                          : const Icon(Icons.error, color: Colors.red),
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
          10.height,
        ],
      ),
    );
  }

  TableCell _buildTableCell(String title, String value,
      {Color valueColor = Colors.black}) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 30,
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

  Future<void> fetchData() async {
    final response = await ApiInterface.getLiveRate(context,
        token: widget.stockData.instrumentToken.toString(),
        showLoading: data == null);
    data = response!.livedata!.first;
    setState(() {});
  }
}
