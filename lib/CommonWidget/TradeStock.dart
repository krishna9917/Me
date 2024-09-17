import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetMCXModel.dart';
import '../Resources/ImagePaths.dart';
import '../Resources/Styles.dart';
import '../Utils/AppTheme.dart';

class Tradestock extends StatefulWidget {
  StockData data;
  bool showCheckUncheck;

  Tradestock({super.key, required this.data, this.showCheckUncheck = false});

  @override
  State<Tradestock> createState() => _TradestockState();
}

class _TradestockState extends State<Tradestock> {
  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5,top: 3),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.data.title.toString(),
                          style: Theme.of(context).textTheme.titleLarge),
                      Text(
                        widget.data.expireDate.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      8.height,
                      Wrap(
                        children: [
                          Text(
                            widget.showCheckUncheck
                                ? "Lot Size:${widget.data.quotationLot.toDouble()}"
                                : "Chg: ${widget.data.priceChange}",
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color: widget.showCheckUncheck
                                        ? widget.showCheckUncheck
                                            ? appColors.color2
                                            : Colors.black
                                        : widget.data.priceChangeColor!),
                          ),
                          Visibility(
                            visible: !widget.showCheckUncheck,
                            child: Text(
                              "(${widget.data.priceChangePercentage}%)",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: widget.data.priceChangeColor!),
                            ),
                          ),
                          10.width,
                          Text(
                            "High: ${widget.data.high}",
                            style: Theme.of(context).textTheme.titleMedium!,
                          ),
                        ],
                      ),
                    ]),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: widget.data.buyPriceColor,
                            borderRadius: BorderRadius.circular(3)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          "${widget.data.buyPrice}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      15.height,
                      Text(
                        "Low: ${widget.data.low}",
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                    ]),
              ),
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            color: widget.data.salePriceColor,
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(
                          "${widget.data.salePrice}",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      20.width,
                      15.height,
                      Text(
                        "Ltp: ${widget.data.lastTradePrice}",
                        style: Theme.of(context).textTheme.titleMedium!,
                      ),
                    ]),
              ),
              Visibility(
                visible: widget.showCheckUncheck,
                child: Image.asset(widget.data.isChecked == 1
                    ? ImagePaths.checkedBox
                    : ImagePaths.unCheckedBox),
              )
            ],
          ),
          const Divider(
            height: 1,
            thickness: 0.4,
            color: Colors.blueGrey,
          )

        ],
      ),
    );
  }
}
