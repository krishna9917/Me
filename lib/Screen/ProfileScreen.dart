import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetProfileData.dart';
import '../Resources/Strings.dart';
import '../Resources/Styles.dart';
import '../Utils/AppTheme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  GetProfiledata? Profiledata;

  Future<void> fetchProfile() async {
    Profiledata = await ApiInterface.getProfile(context, showLoading: true);
    setState(() {});
  }

  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
        appBar: AppBar(
          title: const Text(Strings.profile),
        ),
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Profiledata != null
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Card(
                            color: appColors.color1,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(Strings.nse,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge),
                                      7.width,
                                      Text(Strings.tradingEnabled,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                                  color: appColors.color5))
                                    ],
                                  ),
                                  Text(Strings.brokerage,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(color: appColors.color5)),
                                  Text(
                                    "${Profiledata?.nseBrokerage}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(color: appColors.color2),
                                  ),
                                  const Divider(),
                                  Text(
                                    Strings.marginIntraday,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: appColors.color5,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 19),
                                  ),
                                  Text(
                                    "${Strings.turnOver} ${Profiledata?.nseIntradayMargin}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(color: appColors.color2),
                                  ),
                                  const Divider(),
                                  Text(
                                    Strings.marginHolding,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                            color: appColors.color5,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 19),
                                  ),
                                  Text(
                                    "${Strings.turnOver} ${Profiledata?.nseHoldingMargin}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineLarge!
                                        .copyWith(color: appColors.color2),
                                  ),
                                ],
                              ),
                            )),
                        Card(
                          color: appColors.color1,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      Strings.mcx,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(color: appColors.color5),
                                    ),
                                    const SizedBox(width: 7),
                                    Text(
                                      Strings.tradingEnabled,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(color: appColors.color5),
                                    ),
                                  ],
                                ),
                                Text(Strings.brokerage,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: appColors.color5)),
                                // Displaying mcxBrokerage as a ListView
                                10.height,
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: Profiledata?.mcxBrokeragePerLot
                                          ?.toJson()
                                          .length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    final items = Profiledata
                                        ?.mcxBrokeragePerLot!
                                        .toJson()
                                        .entries
                                        .toList();
                                    final entry = items?[index];
                                    final title = entry?.key;
                                    final margin = entry?.value;
                                    return Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '$title: ',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge!,
                                            ),
                                            Text(
                                              '$margin',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineLarge,
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const Divider(),
                                Text(
                                  Strings.marginIntraday,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: appColors.color5),
                                ),
                                10.height,
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      Profiledata!.mcxIntraday?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    var mcxIntraday =
                                        Profiledata!.mcxIntraday?[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${mcxIntraday?.title} : / ${mcxIntraday?.margin}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineLarge!
                                              .copyWith(
                                                  color: appColors.color5),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                                const Divider(),
                                Text(Strings.marginHolding,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(color: appColors.color5)),
                                10.height,
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      Profiledata!.mcxHolding?.length ?? 0,
                                  itemBuilder: (context, index) {
                                    var mcxHolding =
                                        Profiledata!.mcxHolding?[index];
                                    return Text(
                                      "${mcxHolding?.title}: / ${mcxHolding?.margin}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .copyWith(color: appColors.color5),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Text(
                  Strings.dataNotAvailable,
                  style: Styles.normalText(
                    context: context,
                  ),
                )),
        ));
  }
}
