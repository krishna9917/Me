import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetWalletModel.dart';
import '../Resources/Strings.dart';
import '../Services/Service_Api.dart';


class WalletScreen extends ConsumerStatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  @override
  void initState() {
    super.initState();
    fetchWallet();
    print("fetchWallet:$fetchWallet");
  }

  GetWallet? wallet;
  bool isLoading = true;

  Future<void> fetchWallet() async {
    setState(() {
      isLoading = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

        var bodyFields = {
          'userID': sharedPreferences.getString(Strings.USER_ID).toString(),
         // 'type': '2'
        };
        var result = await ServicesApi().postApiWithData(
            'https://www.onlinetradelearn.com/mcx/authController/getWalletHistory',bodyFields,ref
        );

        wallet = getWalletFromJson(result);

        setState(() {
          isLoading = false;
        });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        title:const Row(
          children: [
          //  VerticalDivider(color: Colors.white,),
            Text("Wallet History", style:TextStyle(color:Colors.white)),
          ],
        )
      ),
      body:
      Column(
        children: [
          isLoading
              ? Center(
            child: Image.asset('assets/loader.png'),
          )
              : wallet != null
              ?SizedBox(
            height:MediaQuery.of(context).size.height * 0.7,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child:ListView.builder(
                itemCount: wallet?.data?.length,
                itemBuilder: (context, index) {
                  final data = wallet!.data?[index];
                  return Card(
                     color:Colors.blueGrey[900],
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${data?.description}",
                                style: TextStyle(fontSize: 11,color: Colors.white),
                              ),
                              Spacer(),
                              Row(
                                children: [
                                  Icon(Icons.currency_rupee, size:15, color: Colors.white),
                                  Text(
                                    "${data?.affectPoint}",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Settlement",
                                style: TextStyle(fontSize: 11,color: Colors.white),
                              ),
                              Spacer(),
                              Text(
                                "${data?.created}",
                                style: TextStyle(fontSize: 11,color: Colors.white),
                              ),
                            ],
                          ),
                          Text(
                            "Before Point: ${data?.beforePoint}",
                            style: TextStyle(fontSize: 11,color: Colors.white),
                          ),
                          Text(
                            "After Point: ${data?.afterPoint}",
                            style: TextStyle(fontSize: 11,color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              // child: Card(
              // //  color:Colors.black12,
              //     child:Padding(
              //       padding: const EdgeInsets.all(5.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Row(
              //             children: [
              //               Row(
              //                 children: [
              //                   Text("${wallet?.data?.first.description}",style:TextStyle(fontSize: 11)),
              //                 ],
              //               ),
              //               Spacer(),
              //               Row(
              //                 children: [
              //                   Text("${wallet?.data?.first.affectPoint}",style:TextStyle(color:Colors.green)),
              //                 ],
              //               ),
              //             ],
              //           ),
              //           Row(
              //             children: [
              //               Row(
              //                 children: [
              //                   Text("Settlement",style:TextStyle(fontSize: 11)),
              //                 ],
              //               ),
              //               Spacer(),
              //               Row(
              //                 children: [
              //                   Text("${wallet?.data?.first.created}",style:TextStyle(fontSize: 11)),
              //                 ],
              //               ),
              //             ],
              //           ),
              //           Text("Before Point: ${wallet?.data?.first.beforePoint}",style:TextStyle(fontSize: 11)),
              //           Text("After Point: ${wallet?.data?.first.afterPoint}",style:TextStyle(fontSize: 11)),
              //         ],
              //       ),
              //     )
              // ),
            ),
          )
              : Center(child: Text('No data available')),

        ],
      )

    );
  }
}
