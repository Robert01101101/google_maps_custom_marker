import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//To run test: flutter test test/google_maps_custom_marker_test.dart

void main() {
  group('Test createCustomIconForMarker()', () {
    test(
        'calls createCustomIconForMarker() for a bubble shape with only required parameters',
        () async {
      Marker testMarker = await GoogleMapsCustomMarker.createCustomMarker(
        marker: const Marker(
          markerId: MarkerId('bubble'),
          position: LatLng(49.281986774819636, -123.1254609406434),
        ),
        shape: MarkerShape.bubble,
        title: 'Hello World!',
      );
      expect(testMarker, isNotNull);
    });

    test(
        'calls createCustomIconForMarker() for a bubble shape with all available parameters',
        () async {
      Marker testMarker = await GoogleMapsCustomMarker.createCustomMarker(
        marker: const Marker(
          markerId: MarkerId('bubble'),
          position: LatLng(49.281986774819636, -123.1254609406434),
        ),
        shape: MarkerShape.bubble,
        title: 'Hello World!',
        backgroundColor:
            GoogleMapsCustomMarkerColor.markerYellow.withOpacity(.8),
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
      );
      expect(testMarker, isNotNull);
    });

    test(
        'calls createCustomIconForMarker() for a pin shape with only required parameters',
        () async {
      Marker testMarker = await GoogleMapsCustomMarker.createCustomMarker(
        marker: const Marker(
          markerId: MarkerId('pin'),
          position: LatLng(49.281986774819636, -123.1254609406434),
        ),
        shape: MarkerShape.pin,
      );
      expect(testMarker, isNotNull);
    });

    test(
        'calls createCustomIconForMarker() for a pin shape with all available parameters',
        () async {
      Marker testMarker = await GoogleMapsCustomMarker.createCustomMarker(
        marker: const Marker(
          markerId: MarkerId('pin'),
          position: LatLng(49.281986774819636, -123.1254609406434),
        ),
        shape: MarkerShape.pin,
        title: '99',
        backgroundColor:
            GoogleMapsCustomMarkerColor.markerYellow.withOpacity(.8),
        foregroundColor: Colors.black,
        textSize: 38,
        enableShadow: false,
        padding: 150,
        textStyle: const TextStyle(decoration: TextDecoration.underline),
        imagePixelRatio: 1.5,
        pinOptions: PinMarkerOptions(
          diameter: 18,
          pinDotColor: Colors.red,
        ),
      );
      expect(testMarker, isNotNull);
    });

    test(
        'calls createCustomIconForMarker() for a circle shape with only required parameters',
        () async {
      Marker testMarker = await GoogleMapsCustomMarker.createCustomMarker(
        marker: const Marker(
          markerId: MarkerId('circle'),
          position: LatLng(49.281986774819636, -123.1254609406434),
        ),
        shape: MarkerShape.circle,
      );
      expect(testMarker, isNotNull);
    });

    test(
        'calls createCustomIconForMarker() for a circle shape with all available parameters',
        () async {
      Marker testMarker = await GoogleMapsCustomMarker.createCustomMarker(
        marker: const Marker(
          markerId: MarkerId('circle'),
          position: LatLng(49.281986774819636, -123.1254609406434),
        ),
        shape: MarkerShape.circle,
        title: '99',
        backgroundColor:
            GoogleMapsCustomMarkerColor.markerYellow.withOpacity(.8),
        foregroundColor: Colors.black,
        textSize: 38,
        enableShadow: false,
        padding: 150,
        textStyle: const TextStyle(decoration: TextDecoration.underline),
        imagePixelRatio: 1.5,
        circleOptions: CircleMarkerOptions(
          diameter: 18,
        ),
      );
      expect(testMarker, isNotNull);
    });
  });
}
