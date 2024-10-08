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
        title: const Text('Personel Konum'),
      ),
      floatingActionButton: _fab(),
      body: FlutterMap(
        mapController: mapController,
        options: getMapOptions(),
        children: [
          // Harita katmanı
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'dev.fleaflet.flutter_map.example',
            retinaMode: true,

            // Opsiyonel: Her bir harita karo widget'ını özelleştirmek için kullanılabilir
            tileBuilder: (context, tileWidget, tile) {
              return tileWidget; // Varsayılan karo render'ı
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
      ),
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
