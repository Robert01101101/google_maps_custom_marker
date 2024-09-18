import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Custom Marker Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Google Maps Custom Marker Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Set<Marker> _markers = {};
  static const LatLng _center = LatLng(49.281986774819636, -123.1254609406434);
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  Future<void>? _addMarkersFuture;

  static const CameraPosition _position = CameraPosition(
    target: _center,
    zoom: 13,
  );

  @override
  void initState() {
    super.initState();
    _addMarkersFuture = _addMarkers();
  }

  Future<void> _addMarkers() async {
    // pin markers
    for (int i = 0; i < 6; i++) {
      Marker pinMarker = await GoogleMapsCustomMarker.createCustomMarker(
        marker: Marker(
          markerId: MarkerId('pin_$i'),
          position: LatLng(_center.latitude + 0.03, _center.longitude - 0.025 + i * 0.01),
        ),
        shape: MarkerShape.pin,
        pinOptions: PinMarkerOptions(diameter: 14 + i*8),
      );
      _markers.add(pinMarker);
    }

    // numbered pin markers
    for (int i = 0; i < 6; i++) {
      Marker pinMarker = await GoogleMapsCustomMarker.createCustomMarker(
        marker: Marker(
          markerId: MarkerId('pin_labeled_$i'),
          position: LatLng(_center.latitude + 0.02, _center.longitude - 0.025 + i * 0.01),
        ),
        shape: MarkerShape.pin,
        backgroundColor: GoogleMapsCustomMarkerColor.markerColors[i % GoogleMapsCustomMarkerColor.markerColors.length],
        title: (i + 1).toString(),
      );
      _markers.add(pinMarker);
    }

    // circle markers
    for (int i = 0; i < 6; i++) {
      Marker pinMarker = await GoogleMapsCustomMarker.createCustomMarker(
        marker: Marker(
          markerId: MarkerId('pin_labeled_$i'),
          position: LatLng(_center.latitude + 0.015, _center.longitude - 0.025 + i * 0.01),
        ),
        shape: MarkerShape.circle,
        backgroundColor: GoogleMapsCustomMarkerColor.markerColors[i % GoogleMapsCustomMarkerColor.markerColors.length],
        title: (i + 1).toString(),
      );
      _markers.add(pinMarker);
    }

    // demonstrating centered alignment of all marker shapes
    _markers.add( await GoogleMapsCustomMarker.createCustomMarker(
      marker: const Marker(
        markerId: MarkerId('centered_bubble_no_anchor'),
        position: _center,
        zIndex: 1,
      ),
      shape: MarkerShape.bubble,
      backgroundColor: GoogleMapsCustomMarkerColor.markerGrey,
      title: 'Centered Bubble without Anchor Triangle',
      bubbleOptions: BubbleMarkerOptions(
          enableAnchorTriangle: false),
    ));
    _markers.add( await GoogleMapsCustomMarker.createCustomMarker(
      marker: const Marker(
        markerId: MarkerId('centered_circle'),
        position: _center,
        zIndex: 2,
      ),
      shape: MarkerShape.circle,
      backgroundColor: GoogleMapsCustomMarkerColor.markerBlue,
      circleOptions: CircleMarkerOptions(
        diameter: 18,
      ),
    ));
    _markers.add( await GoogleMapsCustomMarker.createCustomMarker(
      marker: const Marker(
        markerId: MarkerId('centered_bubble'),
        position: _center,
        zIndex: 3,
      ),
      shape: MarkerShape.bubble,
      title: 'Centered Bubble',
      bubbleOptions: BubbleMarkerOptions(
        anchorTriangleWidth: 82,
        anchorTriangleHeight: 48),
    ));
    _markers.add( await GoogleMapsCustomMarker.createCustomMarker(
      marker: const Marker(
        markerId: MarkerId('centered_pin'),
        position: _center,
        zIndex: 4,
      ),
      shape: MarkerShape.pin,
      backgroundColor: GoogleMapsCustomMarkerColor.markerGreen,
    ));

    // bubble marker
    _markers.add( await GoogleMapsCustomMarker.createCustomMarker(
      marker: Marker(
        markerId: const MarkerId('bubble'),
        position: LatLng(_center.latitude - 0.02, _center.longitude),
      ),
      shape: MarkerShape.bubble,
      title: 'Hello World!',
    ));

    // customized bubble marker
    _markers.add( await GoogleMapsCustomMarker.createCustomMarker(
      marker: Marker(
        markerId: const MarkerId('bubble'),
        position: LatLng(_center.latitude - 0.04, _center.longitude),
      ),
      shape: MarkerShape.bubble,
      title: 'Customize Me!',
      backgroundColor: GoogleMapsCustomMarkerColor.markerYellow.withOpacity(.8),
      foregroundColor: Colors.black,
      textSize: 38,
      enableShadow: false,
      padding: 150,
      textStyle: const TextStyle(decoration: TextDecoration.underline),
      imagePixelRatio: 1.5,
      bubbleOptions: BubbleMarkerOptions(
        anchorTriangleWidth: 32,
        anchorTriangleHeight: 48,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: _addMarkersFuture, //wait for markers to load before building the map
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());  // Show loading spinner while markers load
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));  // Display error if marker loading fails
          } else {
            return GoogleMap(
              initialCameraPosition: _position,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            );
          }
        }
      ),
    );
  }
}
