import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import '../Model/GetPortfolioList.dart';
import '../Model/PortfolioCloseList.dart';
import '../Services/Service_Api.dart';

final deviceIDProvider = StateProvider<String?>((ref) => null);

Future<void> fetchDeviceID(WidgetRef ref) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  ref.read(deviceIDProvider.notifier).state = androidInfo.id;
}

final portfolioProvider = FutureProvider<GetPortfolioList>((ref) async {
  final stdata = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString('apiToken'));

  if (stdata != null && stdata.isNotEmpty) {
    var bodyFields = {'userID': '145', 'type': '1'};

    // Pass the ref parameter correctly
    var result = await ServicesApi().postApiWithData(
        stdata, // API Token
        'https://www.onlinetradelearn.com/mcx/authController/getPortfolioList',
        bodyFields,
        ref as WidgetRef);
    print("result");
    return getPortfolioListFromJson(result);
  } else {
    throw Exception('API token is not available or is empty');
  }
});

final portfolioCloseProvider = FutureProvider<PortfolioCloseList>((ref) async {
  final stdata = await SharedPreferences.getInstance()
      .then((prefs) => prefs.getString('apiToken'));

  if (stdata != null && stdata.isNotEmpty) {
    var bodyFields = {'userID': '145', 'type': '1'};

    // Pass the ref parameter correctly
    var result = await ServicesApi().postApiWithData(
        stdata, // API Token
        'https://www.onlinetradelearn.com/mcx/authController/getClosePortfolioList',
        bodyFields,
        ref as WidgetRef);

    print("result");
    return portfolioCloseListFromJson(result);
  } else {
    throw Exception('API token is not available or is empty');
  }
});
