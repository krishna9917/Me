import 'package:flutter/material.dart';
import 'package:me_app/Utils/HelperFunction.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Dialogs/AlertBox.dart';
import '../Model/GetMCXModel.dart';
import '../Model/TradeData.dart';
import '../Resources/Strings.dart';
import '../Resources/Styles.dart';
import '../Screen/StockDetailScreen.dart';

class Tradehistory extends StatefulWidget {
  int tradeStatus = 1;
  List<Data>? trades;
  Function(String orderID, String type) onCancelCall;

  Tradehistory(
      {super.key,
      required this.trades,
      required this.tradeStatus,
      required this.onCancelCall});

  @override
  State<Tradehistory> createState() => _TradehistoryState();
}

class _TradehistoryState extends State<Tradehistory> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: widget.trades != null && widget.trades!.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: Card(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        widget.tradeStatus == 1
                            ? Strings.cancelAllPendingMcxOrder
                            : Strings.closeMcxOrder,
                        textAlign: TextAlign.center,
                        style: Styles.normalText(isBold: true, fontSize: 10)),
                  ),
                ).onTap(() {
                  AlertBox.showAlert(
                      context,
                      Text(
                        "Are you sure you want to ${widget.tradeStatus == 1 ? Strings.cancelAllPendingMcxOrder : Strings.closeMcxOrder}?",
                        style: Styles.normalText(isBold: true),
                      ), () {
                    widget.onCancelCall(widget.tradeStatus.toString(),
                        widget.tradeStatus == 1 ? "5" : "4");
                  });
                }),
              ),
              Expanded(
                child: Card(
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        widget.tradeStatus == 1
                            ? Strings.cancelAllPendingNseOrder
                            : Strings.closeNseOrder,
                        textAlign: TextAlign.center,
                        style: Styles.normalText(isBold: true, fontSize: 10)),
                  ),
                ).onTap(
                  () {
                    AlertBox.showAlert(
                        context,
                        Text(
                          "Are you sure you want to ${widget.tradeStatus == 1 ? Strings.cancelAllPendingNseOrder : Strings.closeNseOrder}?",
                          style: Styles.normalText(isBold: true),
                        ), () {
                      widget.onCancelCall(widget.tradeStatus.toString(),
                          widget.tradeStatus == 1 ? "5" : "4");
                    });
                  },
                ),
              ),
            ]),
          ),
        ),
        widget.trades != null && widget.trades!.isNotEmpty
            ? Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: widget.trades!.length ?? 0,
                    itemBuilder: (context, index) {
                      final trade = widget.trades![index];
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
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color:
                                                  trade.bidType!.contains("1")
                                                      ? Colors.green
                                                      : Colors.red,
                                              width: 2, // Border width
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 6),
                                            child: Text(
                                              trade.bidType!.contains("1")
                                                  ? "BuyX${trade.lot}"
                                                  : "SellX${trade.lot}",
                                              style: Styles.normalText(
                                                  fontSize: 11,
                                                  isBold: true,
                                                  color: trade.bidType!
                                                          .contains("1")
                                                      ? Colors.green
                                                      : Colors.red),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                              color:
                                                  trade.orderType!.contains("1")
                                                      ? Colors.green
                                                      : Colors.red,
                                              width: 2, // Border width
                                            ),
                                          ),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 3,
                                                      horizontal: 6),
                                              child: Text(
                                                  trade.orderType!.contains("1")
                                                      ? Strings.market
                                                      : trade.orderType!
                                                              .contains("2")
                                                          ? Strings.order
                                                          : trade.orderType!
                                                                  .contains("3")
                                                              ? Strings.sl
                                                              : trade.orderType!
                                                                      .contains(
                                                                          "4")
                                                                  ? Strings
                                                                      .admin
                                                                  : trade.orderType!
                                                                          .contains(
                                                                              "5")
                                                                      ? Strings
                                                                          .carriedForward
                                                                      : trade.orderType!.contains(
                                                                              "6")
                                                                          ? Strings
                                                                              .iFund
                                                                          : trade.orderType!.contains("7")
                                                                              ? Strings.monthSettlement
                                                                              : "",
                                                  style: Styles.normalText(
                                                    fontSize: 11,
                                                    isBold: true,
                                                    color: trade.orderType!
                                                            .contains("1")
                                                        ? Colors.green
                                                        : Colors.red,
                                                  ))),
                                        ),
                                      ],
                                    ),
                                    5.height,
                                    Text(
                                      '${trade.categoryName}_${trade.expireDate}',
                                      style: Styles.normalText(isBold: true),
                                    ),
                                    5.height,
                                    Text(
                                      trade.bidType!.contains("1")
                                          ? "Bought By nul"
                                          : "Sold by null",
                                      style: Styles.normalText(
                                          fontSize: 11, isBold: true),
                                    ),
                                    Text(
                                      '${trade.orderDateTime}',
                                      style: Styles.normalText(
                                          fontSize: 10, isBold: true),
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
                                          color: trade.bidType!.contains("1")
                                              ? Colors.green
                                              : Colors.red,
                                          width: 2, // Border width
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 3, horizontal: 6),
                                        child: Text('${trade.bidPrice}',
                                            style: Styles.normalText(
                                                fontSize: 12,
                                                isBold: true,
                                                color:
                                                    trade.bidType!.contains("1")
                                                        ? Colors.green
                                                        : Colors.red)),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Card(
                                      color: Colors.red,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 10),
                                        child: Text(
                                            widget.tradeStatus == 1
                                                ? trade.status!.contains("4")
                                                    ? Strings.cancelled
                                                    : Strings.cancelOrder
                                                : Strings.closeOrder,
                                            style: Styles.normalText(
                                                fontSize: 10, isBold: true)),
                                      ),
                                    ).onTap(() {
                                      if (widget.tradeStatus == 1 &&
                                          trade.status!.contains("4")) {
                                        HelperFunction.showMessage(
                                            context, Strings.orderCancelled);
                                      } else if (widget.tradeStatus == 1 &&
                                          !trade.status!.contains("4")) {
                                        widget.onCancelCall(
                                            trade.orderID.toString(), "1");
                                      } else {
                                        widget.onCancelCall(
                                            trade.orderID.toString(), "2");
                                      }
                                    }),
                                    Text('Margin used:${trade.intradayMargin}',
                                        style: Styles.normalText(
                                            fontSize: 10, isBold: true)),
                                    Text(
                                        'Holding Mar.Req.:${trade.holdingMargin}',
                                        style: Styles.normalText(
                                            fontSize: 10, isBold: true)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      ).onTap(() async {
                        StockDetailScreen(
                          stockData: StockData(
                              categoryId: trade.categoryId,
                              title: trade.token,
                              expireDate: trade.expireDate,
                              salePrice: trade.bidPrice.toDouble(),
                              buyPrice: trade.bidPrice.toDouble()),
                        ).launch(context);

                      });
                    },
                  ),
                ),
              )
            : Center(
                child: Text(
                Strings.dataNotAvailable,
                style: Styles.normalText(),
              )),
        //  Divider(),
      ],
    );
  }
}
