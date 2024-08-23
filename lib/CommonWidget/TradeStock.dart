import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetMCXModel.dart';
import '../Resources/Styles.dart';

class Tradestock extends StatefulWidget {
  Datum data;
  bool showCheckUncheck;

  Tradestock({super.key, required this.data, this.showCheckUncheck = false});

  @override
  State<Tradestock> createState() => _TradestockState();
}

class _TradestockState extends State<Tradestock> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Wrap(direction: Axis.vertical, children: [
                  Text(widget.data.title.toString(),
                      style: Styles.normalText(context: context,fontSize: 16, isBold: true)),
                  Text(
                    widget.data.expireDate.toString(),
                    style: Styles.normalText(context: context,isBold: true, fontSize: 12),
                  ),
                  5.height,
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            widget.showCheckUncheck
                                ? "Lot Size: ${widget.data.quotationLot}"
                                : "Chg:${widget.data.priceChange}",
                            style: Styles.normalText(context: context,
                                fontSize: 10,
                                isBold: true,
                                color: widget.showCheckUncheck
                                    ? Colors.black
                                    : widget.data.priceChangeColor!),
                          ),
                          Visibility(
                            visible: !widget.showCheckUncheck,
                            child: Text(
                              "(${widget.data.priceChangePercentage}%)",
                              style: Styles.normalText(context: context,
                                  fontSize: 10,
                                  isBold: true,
                                  color: widget.data.priceChangeColor!),
                            ),
                          ),
                        ],
                      ),
                      5.width,
                      Text(
                        "High:${widget.data.high}",
                        style: Styles.normalText(context: context,
                          fontSize: 10,
                          isBold: true,
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      20.height,
                      Container(
                        decoration: BoxDecoration(
                            color: widget.data.buyPriceColor,
                            borderRadius: BorderRadius.circular(5)),
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          "${widget.data.buyPrice}",
                          style: Styles.normalText(context: context,isBold: true, fontSize: 16),
                        ),
                      ),
                      Text(
                        "Low: ${widget.data.low}",
                        style: Styles.normalText(context: context,isBold: true, fontSize: 10),
                      ),
                    ]),
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      20.height,
                      Container(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        decoration: BoxDecoration(
                            color: widget.data.salePriceColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          "${widget.data.salePrice}",
                          style: Styles.normalText(context: context,isBold: true, fontSize: 16),
                        ),
                      ),
                      20.width,
                      Text(
                        "LTP: ${widget.data.lastTradePrice}",
                        style: Styles.normalText(context: context,isBold: true, fontSize: 10),
                      ),
                    ]),
              ),
              Visibility(
                visible: widget.showCheckUncheck,
                child: Image.asset(widget.data.isChecked == 1
                    ? 'assets/checked.png'
                    : 'assets/unchecked.png'),
              )
            ],
          ),
          Divider(
            color: Colors.green.shade900,
          )
        ],
      ),
    );
  }
}
