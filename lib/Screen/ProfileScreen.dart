import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';

import '../Model/GetProfileData.dart';
import '../Services/Service_Api.dart';


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

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final stdata = prefs.getString('apiToken');
      print("stdata: $stdata");
      print("222");

      if (stdata != null && stdata.isNotEmpty) {
        // final loginModel = loginModelFromJson(stdata);
        // final token = loginModel.token;
        //
        // if (token != null && token.isNotEmpty) {
        var bodyFields = {
          'userID': '145',
          // 'type': '2'
        };
        var result = await ServicesApi().postApiWithData(
          //token,
            'bXdSSmNIOHFOS2RoQTNES0hJYndwNmxjS1ZzbkVzZzVNSWdOVHZqRm'
                'h0MUFLNTJhSXZFYUdiQzVWS2Z3Z0V5TTNTejI1WWFoRm5MTWFJcTNlczJPajRlMk9qQ2dtZ3dYcExWVU1Laml4SlE9' ,
            'https://www.onlinetradelearn.com/mcx/authController/getProfileData',bodyFields,ref
        );

        print("Result: $result");

        // Parse the result into GetPortfolioList
        Profiledata = getProfiledataFromJson(result);

        setState(() {
          isLoading = false;
        });
      } else {
        print('API token is not available or is empty');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error occurred: $e');
    }
  }

  void initState() {
    super.initState();
    fetchProfile();
    print("fetchProfile:$fetchProfile");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Profile', style:TextStyle(color:Colors.white)),
      ),
      body:SingleChildScrollView(
        child: Container(
          color:Colors.black,
          height: MediaQuery.of(context).size.height,
          child: isLoading
            ? Center(
            child: Image.asset('assets/loader.png'),
          )
          : Profiledata != null
           ? SingleChildScrollView(
             child: Column(
              children: [
                Card(
                  color:Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("NSE",style: TextStyle(color:Colors.amber),),
                            7.width,
                            Text("Trading Enabled"),
                          ],
                        ),
                        Text("Brokerage",style: TextStyle(color:Colors.amber),),
                        Text("${Profiledata?.nseBrokerage}"),
                        Divider(),
                        Text("Margin Intraday",style: TextStyle(color:Colors.amber),),
                        Text("Turnover / ${Profiledata?.nseIntradayMargin}"),
                        Divider(),
                        Text("Margin Holding",style: TextStyle(color:Colors.amber),),
                        Text("Turnover /${Profiledata?.nseHoldingMargin}"),
                      ],
                    ),
                  )
                ),
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "MCX",
                              style: TextStyle(color: Colors.amber),
                            ),
                            SizedBox(width: 7),
                            Text("Trading Enabled"),
                          ],
                        ),
                        Text(
                          "Brokerage",
                          style: TextStyle(color: Colors.amber),
                        ),
                        // Displaying mcxBrokerage as a ListView
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: Profiledata?.mcxBrokeragePerLot?.toJson().length ?? 0,
                          itemBuilder: (context, index) {
                            final items = Profiledata?.mcxBrokeragePerLot!.toJson().entries.toList();
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
                        Divider(),
                        Text(
                          "Margin Intraday",
                          style: TextStyle(color: Colors.amber),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: Profiledata!.mcxIntraday?.length ?? 0,
                          itemBuilder: (context, index) {
                            var mcxIntraday = Profiledata!.mcxIntraday?[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${mcxIntraday?.title} : / ${mcxIntraday?.margin}"),
                              ],
                            );
                          },
                        ),
                        Divider(),
                        Text(
                          "Margin Holding",
                          style: TextStyle(color: Colors.amber),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: Profiledata!.mcxHolding?.length ?? 0,
                          itemBuilder: (context, index) {
                            var mcxHolding = Profiledata!.mcxHolding?[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${mcxHolding?.title}: / ${mcxHolding?.margin}"),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )

              ],
                       ),
           )
              : Center(child: Text('No data available')),
        ),
      )
    );
  }
}
