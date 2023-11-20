import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NativeViewPage extends StatefulWidget {
  const NativeViewPage({Key? key}) : super(key: key);

  @override
  State<NativeViewPage> createState() => _NativeViewPageState();
}

class _NativeViewPageState extends State<NativeViewPage> {
  @override
  Widget build(BuildContext context) {
    const String viewType = 'NativeViewType';
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    return Scaffold(
        appBar: AppBar(
          title: const Text("Native View"),
        ),
        body: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.red,
                child: const Text("Text Flutter", style: TextStyle(fontSize: 32), textAlign: TextAlign.center,)),
            Expanded(
              child: AndroidView(
                viewType: viewType,
                layoutDirection: TextDirection.ltr,
                creationParams: creationParams,
                creationParamsCodec: const StandardMessageCodec(),
              ),
            )
          ],
        ));
  }
}
