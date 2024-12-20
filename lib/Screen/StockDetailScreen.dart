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
  StockData stockData;
  Livedata? data;

  StockDetailScreen({super.key, required this.stockData, this.data});

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
                ? widget.data!.sellPrice.toString()
                : widget.data!.buyPrice.toString(),
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
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
        appBar: CustomAppBar(
          ref: ref,
          showBackButton: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
              child: Column(children: [
            Card(
              color: appColors.color1,
              elevation: 6,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Text(
                          "${widget.stockData.title}_${widget.stockData.expireDate}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        25.height,
                        Padding(
                          padding: const EdgeInsets.only(right: 35),
                          child: SizedBox(
                            height: 35,
                            child: TabBar(
                                dividerColor: Colors.transparent,
                                isScrollable: true,
                                indicatorSize: TabBarIndicatorSize.tab,
                                labelPadding: EdgeInsets.zero,
                                unselectedLabelColor: appColors.color3,
                                controller: _tabController,
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
                                      borderRadius: BorderRadius.horizontal(
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
                          child:
                              TabBarView(controller: _tabController, children: [
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
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                    _textEditingController.text.isEmpty
                                        ? "${widget.data != null ? widget.data?.buyPrice : widget.stockData.buyPrice}"
                                        : _textEditingController.text,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 17)),
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
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                Text(
                                  _textEditingController.text.isEmpty
                                      ? "${widget.data != null ? widget.data?.sellPrice : widget.stockData.salePrice}"
                                      : _textEditingController.text,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(fontSize: 17),
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
              color: appColors.color1,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1),
                    1: FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(children: [
                      _buildTableCell(
                          Strings.bid,
                          widget.data?.buyPrice != null
                              ? widget.data!.buyPrice.toString()
                              : widget.stockData.buyPrice.toString()),
                      _buildTableCell(
                          Strings.ask,
                          widget.data?.sellPrice != null
                              ? widget.data!.sellPrice.toString()
                              : widget.stockData.salePrice.toString()),
                      _buildTableCell(
                          Strings.lastP,
                          widget.data?.lastTradePrice != null
                              ? widget.data!.lastTradePrice.toString()
                              : widget.stockData.lastTradePrice.toString())
                    ]),
                    TableRow(children: [
                      _buildTableCell(
                          Strings.open,
                          widget.data?.open != null
                              ? widget.data!.open.toString()
                              : Strings.na),
                      _buildTableCell(
                          Strings.close,
                          widget.data?.close != null
                              ? widget.data!.close.toString()
                              : Strings.na),
                      _buildTableCell(
                          Strings.volume,
                          widget.data?.totalQtyTraded != null
                              ? widget.data!.totalQtyTraded.toString()
                              : Strings.na)
                    ]),
                    TableRow(children: [
                      _buildTableCell(
                          Strings.high,
                          widget.data?.high != null
                              ? widget.data!.high.toString()
                              : widget.stockData.high.toString()),
                      _buildTableCell(
                          Strings.low,
                          widget.data?.low != null
                              ? widget.data!.low.toString()
                              : widget.stockData.low.toString()),
                      _buildTableCell(
                          Strings.change,
                          widget.data?.priceChange != null
                              ? widget.data!.priceChange.toString()
                              : widget.stockData.priceChange.toString())
                    ]),
                    TableRow(children: [
                      _buildTableCell(
                          Strings.buyers,
                          widget.data?.buyQty != null
                              ? widget.data!.buyQty.toString()
                              : Strings.na),
                      _buildTableCell(
                          Strings.sellers,
                          widget.data?.sellQty != null
                              ? widget.data!.sellQty.toString()
                              : Strings.na),
                      _buildTableCell(
                          Strings.openInterest,
                          widget.data?.openInterest != null
                              ? widget.data!.openInterest.toString()
                              : Strings.na)
                    ]),
                    TableRow(children: [
                      _buildTableCell(
                          Strings.upperCkt,
                          widget.data?.upperCircuit != null
                              ? widget.data!.upperCircuit.toString()
                              : Strings.na),
                      _buildTableCell(
                          Strings.lowerCkt,
                          widget.data?.lowerCircuit != null
                              ? widget.data!.lowerCircuit.toString()
                              : Strings.na),
                      _buildTableCell(
                          Strings.atp,
                          widget.data?.averageTradedPrice != null
                              ? widget.data!.averageTradedPrice.toString()
                              : Strings.na)
                    ]),
                    TableRow(children: [
                      _buildTableCell(
                          Strings.lastBuy,
                          widget.data?.buyQty != null
                              ? widget.data!.buyQty.toString()
                              : Strings.na),
                      _buildTableCell(
                          Strings.lastSell,
                          widget.data?.sellQty != null
                              ? widget.data!.sellQty.toString()
                              : Strings.na),
                      _buildTableCell(
                          Strings.lotSize,
                          widget.data?.quotationLot != null
                              ? widget.data!.quotationLot.toString()
                              : widget.stockData.quotationLot.toString())
                    ])
                  ],
                ),
              ),
            )
          ])),
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
              Text(Strings.enterLotSize,
                  style: Theme.of(context).textTheme.titleLarge),
              5.height,
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
                  style: Theme.of(context).textTheme.titleLarge,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                ),
              ),
              if (showBidPrice) ...[
                10.height,
                Text(Strings.enterPrice,
                    style: Theme.of(context).textTheme.titleLarge),
                5.height,
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
                    style: Theme.of(context).textTheme.titleLarge,
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

  TableCell _buildTableCell(String title, String value) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 35,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Text(title,
                      style: Theme.of(context).textTheme.titleMedium)),
              Expanded(
                  child: Text(
                value,
                textAlign: TextAlign.end,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: 15),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    final response = await ApiInterface.getLiveRate(context,
        token: widget.stockData.instrumentToken.toString(), showLoading: false);
    widget.data = response!.livedata!.first;
    setState(() {});
  }
}
