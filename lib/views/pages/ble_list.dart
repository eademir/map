//
// Eray
// 11:31 - 19.11.2022

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:map/views/components/custom_button.dart';
import 'package:map/views/pages/nfc_reader.dart';

class BleList extends StatefulWidget {
  const BleList({Key? key}) : super(key: key);

  static String route = '/ble_list';

  @override
  State<BleList> createState() => _BleListState();
}

class _BleListState extends State<BleList> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<BluetoothDevice> devices = [];
  List<BluetoothDevice> connectedDevices = [];
  int timeout = 4;
  double iconSize = 40;

  bool isScanStarted = false;

  // add the devices to different lists in accordence with whether is connected or not.
  // connected devices could not be tested because of lack of hardware.
  // if a device is connected or not it goes to devices list as detected device to compare to connected devices list
  // later.
  void addToDevicesList(BluetoothDevice device, bool isConnected) {
    if (isConnected) {
      if (!connectedDevices.contains(device)) {
        // somehow, the lib detects same devices more than ones. if it
        // contains in the list.
        // do not add to the list again.
        setState(() {
          connectedDevices.add(device);
        });
      }
    }
    if (!devices.contains(device)) {
      // somehow, the lib detects same devices more than ones. if it
      // contains in the list.
      // do not add to the list again.
      setState(() {
        devices.add(device);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final spinkit = SpinKitRipple(
      // animated spin lib for flutter
      color: Colors.deepOrange,
      size: iconSize,
    );

    //scanning starter
    void startScanning() {
      setState(() {
        isScanStarted = true;
      });
      Future.delayed(Duration(seconds: timeout), () {
        //equals to timeout of scanning process
        setState(() {
          isScanStarted = false;
        });
      });

      flutterBlue.startScan(
        timeout: Duration(seconds: timeout),
      );

      flutterBlue.connectedDevices.asStream().listen((List<BluetoothDevice> devices) {
        for (BluetoothDevice device in devices) {
          addToDevicesList(device, true);
        }
      });

      flutterBlue.scanResults.listen((List<ScanResult> results) {
        for (ScanResult r in results) {
          addToDevicesList(r.device, false);
        }
      });

      flutterBlue.stopScan();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth List'), actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(NFCReader.route);
          },
          icon: const Icon(Icons.nfc),
        ),
      ]),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: devices.isEmpty
                  ? const Center(
                      child: Text('Empty.'),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(8),
                      itemCount: devices.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            '${index + 1}: ${devices[index].name.isEmpty ? 'Unknown Device' : devices[index].name}',
                          ),
                          subtitle: Text('Device ID: ${devices[index].id}'),
                          trailing: connectedDevices.contains(devices[index])
                              ? const Icon(Icons.bluetooth_connected)
                              : const Icon(Icons.bluetooth),
                          onTap: () {
                            setState(() async {
                              // could not be tested because of lack of hardware.
                              // here is only theoretical.
                              if (isScanStarted) flutterBlue.stopScan();
                              try {
                                await devices[index].connect();
                              } catch (e) {
                                rethrow;
                              } finally {
                                var services = await devices[index].discoverServices();
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
            CustomButton(
              active: false,
              child: isScanStarted
                  ? spinkit
                  : Icon(
                      Icons.search,
                      size: iconSize,
                      color: Colors.deepOrange,
                    ),
              func: () {
                if (!isScanStarted) {
                  // throws error starting a scan process while it is scanning.
                  startScanning();
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
