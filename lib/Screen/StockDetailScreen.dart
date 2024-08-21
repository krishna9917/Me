import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/Resources/Styles.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetMCXModel.dart';
import '../Resources/Strings.dart';
import '../Utils/AppBar.dart';

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

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          ref: ref,
          showBackButton: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
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
                        SizedBox(
                          height: 35,
                          child: TabBar(
                              isScrollable: true,
                              indicatorSize: TabBarIndicatorSize.tab,
                              dividerColor: Colors.transparent,
                              labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                              controller: _tabController,
                              labelStyle: Styles.normalText(isBold: true),
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
                                bool isSelected = _tabController.index == index;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: isSelected ? Colors.transparent : Colors.grey.shade300, // Change the color as needed
                                    borderRadius: BorderRadius.horizontal(
                                      left: index == 0 ? const Radius.circular(10) : Radius.zero,
                                      right: index == 2 ? const Radius.circular(10) : Radius.zero,
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
                          onPressed: () {},
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
                                        ? "${widget.stockData.salePrice}"
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
                          onPressed: () {},
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
                                      ? "${widget.stockData.buyPrice}"
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
            )
          ]),
        ));
  }

  Widget buildTabContent({required bool showBidPrice}) {
    return Column(
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
    );
  }
}
