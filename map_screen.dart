// Cross-platform stateful map screen for mobile (Google Maps) and web (OpenStreetMap)
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmap;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final gmap.LatLng _googleCenter = const gmap.LatLng(57.7068, 11.9386);
  final LatLng _webCenter = LatLng(57.7068, 11.9386);
  double _currentZoom = 15;

  final List<Map<String, dynamic>> _parkingSpots = [
    {
      'name': 'Lindholmen Science Park',
      'provider': 'Göteborgs Parkering',
      'availability': 4,
      'location': gmap.LatLng(57.7062, 11.9369),
      'latLngWeb': LatLng(57.7062, 11.9369),
      'showInfo': true,
    },
    {
      'name': 'Regnbågsgatan Garage',
      'provider': 'EasyPark',
      'availability': 0,
      'location': gmap.LatLng(57.7076, 11.9385),
      'latLngWeb': LatLng(57.7076, 11.9385),
      'showInfo': false,
    },
    {
      'name': 'Lindholmspiren Lot',
      'provider': 'Parkster',
      'availability': 5,
      'location': gmap.LatLng(57.7070, 11.9402),
      'latLngWeb': LatLng(57.7070, 11.9402),
      'showInfo': false,
    },
  ];

  void toggleInfo(int index) {
    setState(() {
      _parkingSpots[index]['showInfo'] = !_parkingSpots[index]['showInfo'];
    });
  }

  void _zoomMap(bool zoomIn) {
    final newZoom = zoomIn ? _currentZoom + 1 : _currentZoom - 1;
    final clampedZoom = newZoom.clamp(5.0, 20.0);
    setState(() {
      _currentZoom = clampedZoom;
      if (kIsWeb) {
        _mapController.move(_webCenter, clampedZoom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          kIsWeb ? _buildWebMap(context) : _buildMobileMap(),
          if (kIsWeb)
            Positioned(
              top: 20,
              right: 20,
              child: Column(
                children: [
                  FloatingActionButton(
                    mini: true,
                    onPressed: () => setState(() {}),
                    child: const Icon(Icons.refresh),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    mini: true,
                    onPressed: () => _zoomMap(true),
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    mini: true,
                    onPressed: () => _zoomMap(false),
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMobileMap() {
    return gmap.GoogleMap(
      initialCameraPosition: gmap.CameraPosition(
        target: _googleCenter,
        zoom: _currentZoom,
      ),
      mapType: gmap.MapType.normal,
      myLocationEnabled: true,
      markers: _parkingSpots.asMap().entries.map((entry) {
        final index = entry.key;
        final spot = entry.value;
        final isAvailable = spot['availability'] > 0;
        return gmap.Marker(
          markerId: gmap.MarkerId(spot['name']),
          position: spot['location'],
          infoWindow: spot['showInfo'] && _currentZoom >= 14
              ? gmap.InfoWindow(
                  title: spot['name'],
                  snippet:
                      '${spot['provider']} - ${spot['availability']} spots',
                )
              : gmap.InfoWindow(title: ''),
          icon: gmap.BitmapDescriptor.defaultMarkerWithHue(
            isAvailable
                ? gmap.BitmapDescriptor.hueGreen
                : gmap.BitmapDescriptor.hueRed,
          ),
          onTap: () => toggleInfo(index),
        );
      }).toSet(),
    );
  }

  Widget _buildWebMap(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: _webCenter,
        zoom: _currentZoom,
        onPositionChanged: (pos, _) {
          setState(() => _currentZoom = pos.zoom ?? _currentZoom);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'com.example.onepark',
        ),
        MarkerLayer(
          markers: _parkingSpots.asMap().entries.map((entry) {
            final index = entry.key;
            final spot = entry.value;
            final isAvailable = spot['availability'] > 0;
            return Marker(
              width: 200,
              height: (_currentZoom >= 14 && spot['showInfo']) ? 120 : 50,
              point: spot['latLngWeb'],
              rotate: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_currentZoom >= 14 && spot['showInfo'])
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      padding: const EdgeInsets.all(6),
                      constraints: const BoxConstraints(maxWidth: 180),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(blurRadius: 4, color: Colors.black26)
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(spot['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                                Text(
                                    '${spot['provider']} - ${spot['availability']} spots',
                                    style: const TextStyle(fontSize: 11)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                spot['showInfo'] = false;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 6.0),
                              child: Icon(Icons.close, size: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  GestureDetector(
                    onTap: () => toggleInfo(index),
                    child: Icon(
                      Icons.location_on,
                      size: 40,
                      color: isAvailable ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
