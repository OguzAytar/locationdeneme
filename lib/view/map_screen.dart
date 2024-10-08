import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with SingleTickerProviderStateMixin {
  final appbatTitle = 'Personel Konum';
  final urlTemplate = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  final userAgentPackageName = 'dev.fleaflet.flutter_map.example';
  MapOptions getMapOptions() {
    return MapOptions(
      interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
      // onTap: (tapPosition, point) {
      //   mapController.move(point, 15);
      // },
      // onMapEvent: (event) {
      //   log(event.source.name);
      // },
      backgroundColor: Colors.deepOrange[100]!,
      initialCenter: LatLng(widget.latitude, widget.longitude),
      initialZoom: 15.0,
    );
  }

  final mapController = MapController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appbatTitle),
      ),
      floatingActionButton: _fab(),
      body: _scaffoldBody(),
    );
  }

  FlutterMap _scaffoldBody() {
    return FlutterMap(
      mapController: mapController,
      options: getMapOptions(),
      children: [
        // Harita katmanı
        TileLayer(
          urlTemplate: urlTemplate,
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: userAgentPackageName,
          retinaMode: true,
          tileBuilder: (context, tileWidget, tile) {
            return tileWidget;
          },
        ),
        CircleLayer(circles: [
          CircleMarker(
              borderColor: Colors.black,
              color: Colors.black26,
              borderStrokeWidth: 2,
              useRadiusInMeter: true,
              point: LatLng(widget.latitude, widget.longitude),
              radius: 50)
        ]),
        // Kullanıcı konumunu işaretleyen marker
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(widget.latitude, widget.longitude),
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  FloatingActionButton _fab() {
    return FloatingActionButton(
      onPressed: () {
        mapController.move(LatLng(widget.latitude, widget.longitude), 14);
        log(mapController.camera.center.toString());
      },
      child: const Icon(Icons.location_on_outlined),
    );
  }
}
