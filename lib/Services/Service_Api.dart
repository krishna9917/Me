import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../Model/GetPortfolioList.dart';

/// State provider to store the device ID
final deviceIDProvider = StateProvider<String?>((ref) => null);

/// Function to fetch the device ID and store it in the deviceIDProvider
Future<void> fetchDeviceID(WidgetRef ref) async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  ref.read(deviceIDProvider.notifier).state = androidInfo.id;
}

class ServicesApi {
  Future<String> sendPostRequest({
    String? url,
    String? token,
    Map<String, String>? data,
    WidgetRef? ref,
  }) async {
    // Retrieve the device ID from the provider
    String? deviceID = ref?.read(deviceIDProvider);

    // Define headers
    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Token': token ?? "",
      'Deviceid': deviceID ?? "12345678",
      'Cookie': 'PHPSESSID=40139577239b6f0b01085aba0f1490c2a8a630f2',
    };

    // Create request
    var request = http.Request('POST', Uri.parse(url ?? ""));
    request.bodyFields = data ?? {};
    request.headers.addAll(headers);

    // Send request and get response
    try {
      http.StreamedResponse response = await request.send();
      // Check response status and handle accordingly
      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        return 'Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Exception: $e';
    }
  }

  /// Method to send a POST request using Multipart for login
  Future<String?> post_Api_Login(
      String url,
      Map<String, dynamic> data,
      WidgetRef ref,
      ) async {
    try {
      // Retrieve the device ID from the provider
      String? deviceID = ref.read(deviceIDProvider);

      var request = http.MultipartRequest('POST', Uri.parse(url));

      data.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add device ID to headers
      request.headers['Deviceid'] = deviceID ?? "12345678";

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        return null; // Return null to indicate an error
      }
    } catch (e) {
      return null; // Return null to indicate an error
    }
  }

  /// Method to send a GET request with headers
  Future<dynamic> get_ApiwithHeader(
      dynamic url,
      dynamic token,
      WidgetRef ref,
      ) async {
    try {
      var client = http.Client();
      var uri = Uri.parse(url);

      // Retrieve the device ID from the provider
      String? deviceID = ref.read(deviceIDProvider);

      var headers = {
        'Token': '$token',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Deviceid': deviceID ?? "12345678",
      };

      var response = await client.get(uri, headers: headers);

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Method to send a POST request with additional data fields
  Future<String> postApiWithData(
      dynamic token,
      String url,
      Map<String, dynamic> bodyFields,
      WidgetRef ref,
      ) async {
    // Retrieve the device ID from the provider
    String? deviceID = ref.read(deviceIDProvider);

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Token': "$token",
      'Deviceid': deviceID ?? "12345678",
      'Cookie': 'PHPSESSID=2a5580a0916ea9b288295a1abbea3c6b6f23faca',
    };

    Map<String, String> bodyFieldsString = bodyFields.map(
          (key, value) => MapEntry(key, value.toString()),
    );

    var request = http.Request('POST', Uri.parse(url));
    request.bodyFields = bodyFieldsString;
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        return responseBody;
      } else {
        return response.reasonPhrase ?? 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }

  /// Method to get portfolio data with headers
  Future<GetPortfolioList?> getPortfolio(
      String url,
      String token,
      WidgetRef ref,
      ) async {
    // Retrieve the device ID from the provider
    String? deviceID = ref.read(deviceIDProvider);

    var headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Token': token,
      'Deviceid': deviceID ?? "12345678",
      'Cookie': 'PHPSESSID=47993ff59577112ca1effa1d04681b27e638152c',
    };

    var body = {
      'userID': '145',
      'type': '2',
    };

    var request = http.Request('POST', Uri.parse(url));
    request.bodyFields = body.cast<String, String>();
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        return GetPortfolioList.fromJson(json.decode(responseBody));
      } else {
        throw Exception('Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      return null;
    }
  }
}
