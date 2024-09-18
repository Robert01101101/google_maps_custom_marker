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
    // Circular markers in the center of the map, for anchor and positioning testing
    Marker circularAlignmentMarkerLarge = await GoogleMapsCustomMarker.createCustomIconForMarker(
      type: GoogleMapsCustomMarkerType.circular,
      marker: const Marker(
        markerId: MarkerId('marker_1'),
        position: LatLng(49.281986774819636, -123.1254609406434),
      ),
      backgroundColor: Colors.red,
      size: 32,
    );
    Marker circularAlignmentMarker = await GoogleMapsCustomMarker.createCustomIconForMarker(
      type: GoogleMapsCustomMarkerType.circular,
      marker: const Marker(
        markerId: MarkerId('marker_2'),
        position: LatLng(49.281986774819636, -123.1254609406434),
      ),
    );
    Marker circularAlignmentMarkerSmall = await GoogleMapsCustomMarker.createCustomIconForMarker(
      type: GoogleMapsCustomMarkerType.circular,
      marker: const Marker(
        markerId: MarkerId('marker_3'),
        position: LatLng(49.281986774819636, -123.1254609406434),
      ),
      backgroundColor: Colors.yellow,
      size: 4,
    );
    List<Marker> alignmentCircles = [circularAlignmentMarkerSmall];//[circularAlignmentMarkerLarge, circularAlignmentMarker, circularAlignmentMarkerSmall];

    // A variety of marker configurations
    Marker circularMarker = await GoogleMapsCustomMarker.createCustomIconForMarker(
      type: GoogleMapsCustomMarkerType.circular,
      marker: const Marker(
        markerId: MarkerId('marker_4'),
        position: LatLng(49.301986774819636, -123.1454609406434),
      ),
    );
    Marker circularNumberedMarker = await GoogleMapsCustomMarker.createCustomIconForMarker(
      type: GoogleMapsCustomMarkerType.circularNumbered,
      marker: const Marker(
        markerId: MarkerId('marker_5'),
        position: LatLng(49.301986774819636, -123.1254609406434),
      ),
      number: 99,
    );
    Marker circularNumberedMarkerCustomized = await GoogleMapsCustomMarker.createCustomIconForMarker(
      type: GoogleMapsCustomMarkerType.circularNumbered,
      marker: const Marker(
        markerId: MarkerId('marker_6'),
        position: LatLng(49.301986774819636, -123.1054609406434),
      ),
      number: 0,
      textSize: 82,
      backgroundColor: Colors.green,
      foregroundColor: Colors.black,
      size: 64,
      enableShadow: false,
      textStyle: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.normal),
      imagePixelRatio: 1.5,
    );
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
      circleDiameter: 28,
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
      circleDiameter: 8,
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
    List<Marker> variousMarkers = [circularMarker, circularNumberedMarker, circularNumberedMarkerCustomized,
      textBubbleMarkerUnlabeledPin, textBubbleMarkerPin, textBubbleMarkerPinScaled, textBubbleMarkerCircle, textBubbleMarkerUnlabeledCircle, textBubbleMarker];

    setState(() {
      //_markers.addAll(alignmentCircles);
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
