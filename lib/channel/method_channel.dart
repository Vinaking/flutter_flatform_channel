import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DemoMethodChannel extends StatefulWidget {
  const DemoMethodChannel({super.key});

  @override
  State<DemoMethodChannel> createState() => _DemoMethodChannelState();
}

class _DemoMethodChannelState extends State<DemoMethodChannel> {
  static const defaultPlatform = MethodChannel('com.flutter/method1');
  static const platform = MethodChannel('com.flutter/method2', JSONMethodCodec());

  String _deviceInfo1 = '???';
  String _deviceInfo2 = '???';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo MethodChannel"),
      ),
      body: Center(
        child: Column(
          children: [
            Text(_deviceInfo1),
            ElevatedButton.icon(
              onPressed: () {
                _standardMethodCodec('MODEL');
              },
              icon: const Icon(Icons.add),
              label: const Text("StandardMethodCodec"),
            ),
            Text(_deviceInfo2),
            ElevatedButton.icon(
              onPressed: () {
                _jsonMethodCodec('MODEL');
              },
              icon: const Icon(Icons.add),
              label: const Text("JSONMethodCodec"),
            )
          ],
        ),
      ),
    );
  }

  _standardMethodCodec(String model) async {
    try {
      String result =
          await defaultPlatform.invokeMethod('getDeviceInfoString', {
        'type': model,
      });

      _deviceInfo1 = result;
    } on PlatformException catch (e) {
      _deviceInfo1 = e.message!;
    }

    setState(() {});
  }

  _jsonMethodCodec(String model) async {
    try {
      Map<String, dynamic> result =
          await platform.invokeMethod('getDeviceInfo', {
        'type': model,
      });

      _deviceInfo2 = result.toString(); //result['model']
    } on PlatformException catch (e) {
      _deviceInfo2 = e.message!;
    }

    setState(() {});
  }
}
