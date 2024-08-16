import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(const DeviceIDApp());
}

class DeviceIDApp extends StatelessWidget {
  const DeviceIDApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const DeviceIDScreen(),
    );
  }
}

class DeviceIDScreen extends StatefulWidget {
  const DeviceIDScreen({Key? key}) : super(key: key);

  @override
  _DeviceIDScreenState createState() => _DeviceIDScreenState();
}

class _DeviceIDScreenState extends State<DeviceIDScreen> {
  String _deviceID = 'Loading...';

  @override
  void initState() {
    super.initState();
    _getDeviceID();
  }

  Future<void> _getDeviceID() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      _deviceID = androidInfo.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device ID App'),
      ),
      body: Center(
        child: Text(
          _deviceID,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
    );
  }
}
