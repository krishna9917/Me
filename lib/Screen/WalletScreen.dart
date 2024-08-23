import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import 'package:me_app/Resources/ImagePaths.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetWalletModel.dart';
import '../Resources/Strings.dart';
import '../Resources/Styles.dart';

class WalletScreen extends ConsumerStatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  void initState() {
    super.initState();
    fetchWallet();
  }

  GetWallet? wallet;
  bool isLoading = true;

  Future<void> fetchWallet() async {
    setState(() {
      isLoading = true;
    });
    wallet = await ApiInterface.getWalletHistory(context);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: black,
        appBar: AppBar(
            backgroundColor: black,
            title: Row(
              children: [
                Text(Strings.walletHistory,
                    style: Styles.normalText(context: context,
                        isBold: true, color: Colors.white, fontSize: 17)),
              ],
            )),
        body: Column(
          children: [
            isLoading
                ? Center(
                    child: Image.asset(ImagePaths.loader),
                  )
                : wallet != null
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: wallet?.data?.length,
                            itemBuilder: (context, index) {
                              final data = wallet!.data?[index];
                              return Card(
                                color: Colors.blueGrey[900],
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${data?.description}",
                                              style: Styles.normalText(context: context,
                                                  color: Colors.white,
                                                  isBold: true),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.currency_rupee,
                                                  size: 15,
                                                  color: Colors.white),
                                              Text(
                                                "${data?.affectPoint}",
                                                style: Styles.normalText(context: context,
                                                    color: Colors.green,
                                                    isBold: true),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      10.height,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              Strings.settlement,
                                              style: Styles.normalText(context: context,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Text(
                                            "${data?.created}",
                                            style: Styles.normalText(context: context,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "${Strings.beforePoint} ${data?.beforePoint}",
                                        style: Styles.normalText(context: context,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "${Strings.afterPoint} ${data?.afterPoint}",
                                        style: Styles.normalText(context: context,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    : const Center(child: Text(Strings.dataNotAvailable)),
          ],
        ));
  }
}
