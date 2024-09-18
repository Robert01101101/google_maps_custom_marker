import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//To run test: flutter test test/google_maps_custom_marker_test.dart

void main() {
  group('Test createCustomIconForMarker()', () {
    test('calls createCustomIconForMarker() with only required parameters', () async {
      Marker testMarker = await GoogleMapsCustomMarker.createCustomIconForMarker(
        type: GoogleMapsCustomMarkerType.circular,
        marker: const Marker(
          markerId: MarkerId('marker_test'),
          position: LatLng(49.291986774819636, -123.1254609406434),
        ),
      );
      expect(testMarker, isNotNull);
    });

    test('calls createCustomIconForMarker() with all available parameters', () async {
      Marker testMarker = await GoogleMapsCustomMarker.createCustomIconForMarker(
        type: GoogleMapsCustomMarkerType.circularNumbered,
        marker: const Marker(
          markerId: MarkerId('marker_test'),
          position: LatLng(49.291986774819636, -123.1254609406434),
        ),
        number: 1,
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.red,
        size: 32,
        textSize: 32,
        enableShadow: true,
        shadowColor: const Color(0xA0000000),
        shadowBlur: 12,
        textStyle: const TextStyle(fontWeight: FontWeight.normal, decoration: TextDecoration.underline),
        imagePixelRatio: 2.0,
      );
      expect(testMarker, isNotNull);
    });
  });
}
