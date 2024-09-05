import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetWalletModel.dart';
import '../Resources/Strings.dart';
import '../Utils/AppTheme.dart';

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

  Future<void> fetchWallet() async {
    wallet = await ApiInterface.getWalletHistory(context, showLoading: true);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          Strings.walletHistory,
        )),
        body: wallet != null
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${data?.description}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: appColors.color4),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(Icons.currency_rupee,
                                          size: 15, color: Colors.white),
                                      Text(
                                        "${data?.affectPoint}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(
                                                color: data!.affectPoint
                                                            .toString()
                                                            .toDouble() >
                                                        0
                                                    ? Colors.green
                                                    : Colors.red),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: appColors.color4),
                                    ),
                                  ),
                                  Text(
                                    "${data.created}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: appColors.color4),
                                  ),
                                ],
                              ),
                              Text(
                                "${Strings.beforePoint} ${data.beforePoint}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: appColors.color4),
                              ),
                              Text(
                                "${Strings.afterPoint} ${data.afterPoint}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: appColors.color4),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            : Center(
                child: Text(
                Strings.dataNotAvailable,
                style: Theme.of(context).textTheme.titleLarge,
              )));
  }
}
