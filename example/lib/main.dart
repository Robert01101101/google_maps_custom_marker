import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _position = CameraPosition(
    target: LatLng(49.281986774819636, -123.1254609406434),
    zoom: 13,
  );


  @override
  void initState() {
    super.initState();
    _addMarkers();
  }

  Future<void> _addMarkers() async {
    Marker textBubbleMarkerUnlabeledPin = await GoogleMapsCustomMarker.createCustomMarker(
      marker: const Marker(
        markerId: MarkerId('marker_7'),
        position: LatLng(49.281986774819636, -123.1254609406434),
      ),
      backgroundColor: const Color(0xffc32929),
      shape: MarkerShape.pin,
    );
    Marker textBubbleMarkerPin = await GoogleMapsCustomMarker.createCustomMarker(
      marker: const Marker(
        markerId: MarkerId('marker_8'),
        position: LatLng(49.281986774819636, -123.1154609406434),
      ),
      title: '23',
      shape: MarkerShape.pin,
    );
    Marker textBubbleMarkerPinScaled = await GoogleMapsCustomMarker.createCustomMarker(
      marker: const Marker(
        markerId: MarkerId('marker_9'),
        position: LatLng(49.281986774819636, -123.1054609406434),
      ),
      title: '23',
      pinOptions: PinMarkerOptions(diameter: 28),
      textSize: 14,
      shape: MarkerShape.pin,
    );
    Marker textBubbleMarkerCircle = await GoogleMapsCustomMarker.createCustomMarker(
      marker: const Marker(
        markerId: MarkerId('marker_10'),
        position: LatLng(49.281986774819636, -123.1354609406434),
      ),
      title: '23',
      shape: MarkerShape.circle,
    );
    Marker textBubbleMarkerUnlabeledCircle = await GoogleMapsCustomMarker.createCustomMarker(
      marker: const Marker(
        markerId: MarkerId('marker_11'),
        position: LatLng(49.281986774819636, -123.1454609406434),
      ),
      circleOptions: CircleMarkerOptions(diameter: 8),
      shape: MarkerShape.circle,
      backgroundColor: Colors.yellowAccent,
    );
    Marker textBubbleMarker = await GoogleMapsCustomMarker.createCustomMarker(
      marker: const Marker(
        markerId: MarkerId('marker_12'),
        position: LatLng(49.281986774819636, -123.1454609406434),
      ),
      shape: MarkerShape.bubble,
      title: 'Hello World!',
    );
    List<Marker> variousMarkers = [textBubbleMarkerUnlabeledPin, textBubbleMarkerPin, textBubbleMarkerPinScaled,
      textBubbleMarkerCircle, textBubbleMarkerUnlabeledCircle, textBubbleMarker];

    setState(() {
      _markers.addAll(variousMarkers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GoogleMap(
        initialCameraPosition: _position,
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
