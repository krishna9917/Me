import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:me_app/ApiService/ApiInterface.dart';
import 'package:me_app/Resources/ImagePaths.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetProfileData.dart';
import '../Resources/Strings.dart';
import '../Resources/Styles.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  GetProfiledata? Profiledata;
  bool isLoading = true;

  Future<void> fetchProfile() async {
    setState(() {
      isLoading = true;
    });
    Profiledata = await ApiInterface.getProfile(context);
    setState(() {
      isLoading = false;
    });
  }

  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(Strings.profile,
              style: Styles.normalText(context: context,
                  color: Colors.white, fontSize: 17, isBold: true)),
        ),
        body: Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          child: isLoading
              ? Center(
                  child: Image.asset(ImagePaths.loader),
                )
              : Profiledata != null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            Strings.nse,
                                            style: Styles.normalText(context: context,
                                                color: Colors.amber,
                                                isBold: true),
                                          ),
                                          7.width,
                                          Text(
                                            Strings.tradingEnabled,
                                            style: Styles.normalText(context: context,),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        Strings.brokerage,
                                        style: Styles.normalText(context: context,
                                            color: Colors.amber, isBold: true),
                                      ),
                                      Text(
                                        "${Profiledata?.nseBrokerage}",
                                        style: Styles.normalText(context: context,),
                                      ),
                                      const Divider(),
                                      Text(
                                        Strings.marginIntraday,
                                        style: Styles.normalText(context: context,
                                            color: Colors.amber),
                                      ),
                                      Text(
                                          "${Strings.turnOver} ${Profiledata?.nseIntradayMargin}"),
                                      const Divider(),
                                      Text(
                                        Strings.marginHolding,
                                        style: Styles.normalText(context: context,
                                            color: Colors.amber),
                                      ),
                                      Text(
                                          "${Strings.turnOver} ${Profiledata?.nseHoldingMargin}"),
                                    ],
                                  ),
                                )),
                            Card(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          Strings.mcx,
                                          style: Styles.normalText(context: context,
                                              color: Colors.amber,
                                              isBold: true),
                                        ),
                                        const SizedBox(width: 7),
                                        Text(
                                          Strings.tradingEnabled,
                                          style: Styles.normalText(context: context,),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      Strings.brokerage,
                                      style: Styles.normalText(context: context,
                                          color: Colors.amber),
                                    ),
                                    // Displaying mcxBrokerage as a ListView
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                                Text('$title: '),
                                                Text('$margin'),
                                              ],
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                    const Divider(),
                                    Text(
                                      Strings.marginIntraday,
                                      style: Styles.normalText(context: context,
                                          color: Colors.amber, isBold: true),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                                "${mcxIntraday?.title} : / ${mcxIntraday?.margin}"),
                                          ],
                                        );
                                      },
                                    ),
                                    const Divider(),
                                    Text(
                                      Strings.marginHolding,
                                      style: Styles.normalText(context: context,
                                          color: Colors.amber, isBold: true),
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount:
                                          Profiledata!.mcxHolding?.length ?? 0,
                                      itemBuilder: (context, index) {
                                        var mcxHolding =
                                            Profiledata!.mcxHolding?[index];
                                        return Text(
                                            "${mcxHolding?.title}: / ${mcxHolding?.margin}");
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
                      style: Styles.normalText(context: context,),
                    )),
        ));
  }
}
