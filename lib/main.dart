import 'package:flutter/material.dart';
import 'package:map/views/pages/ble_list.dart';
import 'package:map/views/pages/map_page.dart';
import 'package:map/views/pages/nfc_reader.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapPage(),
      routes: {
        MapPage.route: (context) => const MapPage(),
        BleList.route: (context) => const BleList(),
        NFCReader.route: (context) => const NFCReader()
      },
    );
  }
}
