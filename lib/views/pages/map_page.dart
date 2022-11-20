//
// Eray
// 03:46 - 19.11.2022

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:map/views/components/custom_button.dart';
import 'package:map/views/pages/ble_list.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  static String route = "/map_page";

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Marker> markers = [];
  List<LatLng> marks = [];
  List<Icon> icons = [
    const Icon(
      Icons.circle,
      color: Colors.teal,
    ),
    const Icon(
      Icons.circle,
      color: Colors.deepOrange,
    )
  ];

  double iconSize = 40.0;

  //popup
  Future<void> showMyDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('No point is selected'),
          content: const Text('Please select at least one location.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  bool showLines = false;
  bool lastLocation = false;

  void saveMarkers(LatLng latLng) {
    //first and last pins are in different icons from middle ones and first one is in different colour.
    if (marks.length >= 2) {
      icons.insert(
          1,
          const Icon(
            Icons.pin_drop_rounded,
            color: Colors.deepOrange,
          ));
    }

    setState(() {
      markers = [];

      marks.add(
        latLng,
      );

      for (LatLng m in marks) {
        markers.add(Marker(
          point: m,
          width: 30,
          height: 30,
          builder: (context) => icons[marks.indexOf(m)],
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: MapController(),
            options: MapOptions(
              center: LatLng(39.9334, 32.8597),
              maxBounds: LatLngBounds(
                LatLng(-90, -180.0),
                LatLng(90.0, 180.0),
              ),
              keepAlive: true,
              onTap: (pos, LatLng latLng) => {saveMarkers(latLng)},
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              PolylineLayer(
                polylineCulling: false,
                polylines: [
                  Polyline(
                    points: showLines ? marks : [],
                    color: Colors.orange,
                    strokeWidth: 5.0,
                  ),
                ],
              ),
              MarkerLayer(
                markers: lastLocation ? [markers.last] : markers,
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomButton(
                  active: showLines,
                  child: Icon(
                    Icons.line_axis,
                    size: iconSize,
                    color: showLines ? Colors.white : Colors.blueAccent,
                  ),
                  func: () {
                    // if any mark hasn't been selected by user, show popup. otherwise, update the variable and the
                    // state.
                    if (markers.isNotEmpty) {
                      setState(() {
                        showLines = !showLines;
                      });
                    } else {
                      showMyDialog();
                    }
                  },
                ),
                CustomButton(
                  active: lastLocation,
                  child: Icon(
                    Icons.last_page,
                    size: iconSize,
                    color: lastLocation ? Colors.white : Colors.blueAccent,
                  ),
                  func: () {
                    // if any mark hasn't been selected by user, show popup. otherwise, update the variable and the
                    // state.
                    if (markers.isNotEmpty) {
                      setState(() {
                        lastLocation = !lastLocation;
                      });
                    } else {
                      showMyDialog();
                    }
                  },
                ),
                CustomButton(
                  active: true,
                  child: Icon(
                    Icons.bluetooth,
                    size: iconSize,
                    color: Colors.white,
                  ),
                  func: () {
                    Navigator.of(context).pushNamed(BleList.route);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
