# google_maps_custom_marker

<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

A flexible package for creating various shapes of highly customizable markers with optional labels.

<p align = "center">
    <img src="https://github.com/Robert01101101/google_maps_custom_marker/blob/main/example/assets/Screenshot.jpg?raw=true" width="40%" alt="screenshot from example" />
</p>

## Features

Use this package in your Flutter app to:

* Dynamically create markers to use with `google_maps_flutter`
* Add text labels to markers
* Create circle, pin, and text bubble marker shapes
* Customize the appearance, including options for colors, padding, shadow, and more

## Getting started

1. Follow the instructions for getting started with `google_maps_flutter`
2. Create a marker with your desired position and other properties
3. Import this package, pass your marker to `GoogleMapsCustomMarker.createCustomMarker()`
4. Configure the shape, style, and shape-specific options
5. The returned marker has the updated icon and anchor, and is ready for use with your map

## Usage

```dart
Marker pinMarker = await GoogleMapsCustomMarker.createCustomMarker(
    marker: const Marker(
        markerId: MarkerId('pin'),
        position: LatLng(49,-123),
    ),
    shape: MarkerShape.pin,
    title: '99',
);

Marker circleMarker = await GoogleMapsCustomMarker.createCustomMarker(
    marker: const Marker(
        markerId: MarkerId('circle'),
        position: LatLng(49.01,-123),
    ),
    shape: MarkerShape.circle,
    title: '99',
);

Marker bubbleMarkerCustomized = await GoogleMapsCustomMarker.createCustomMarker(
    marker: const Marker(
        markerId: MarkerId('bubble'),
        position: LatLng(49.02,-123),
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
        cornerRadius: 12,
    ),
);

_markers.addAll([pinMarker, circleMarker, bubbleMarkerCustomized]);
```

## Additional information

This package was developed to help more easily create beautiful, semantic maps. 

If you have suggestions for changes, additions, or would like to contribute, that is more than welcome.