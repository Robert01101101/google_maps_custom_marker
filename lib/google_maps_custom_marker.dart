library google_maps_custom_marker;

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

enum MarkerShape { circle, pin, bubble }

class CircleMarkerOptions {
  final double? diameter;

  /// Configures additional options for a circle marker.
  /// The [diameter] parameter specifies the diameter of the circle.
  /// Setting the diameter will require you to ensure an appropriate text size to fit the optional title.
  /// If not specified, the diameter will be calculated based on the text size and padding.
  CircleMarkerOptions({this.diameter});
}

class PinMarkerOptions {
  final Color pinDotColor;
  final double? diameter;

  /// Configures additional options for a pin marker.
  /// The [diameter] parameter specifies the diameter of the circle making up the top of the pin.
  /// Setting the diameter will require you to ensure an appropriate text size to fit the optional title.
  /// If not specified, the diameter will be calculated based on the text size and padding.
  /// If no title is provided, a small dot will be drawn at the top of the pin, colored by [pinDotColor].
  PinMarkerOptions({
    this.pinDotColor = Colors.white,
    this.diameter,
  });
}

class BubbleMarkerOptions {
  final bool enableAnchorTriangle;
  final double anchorTriangleWidth;
  final double anchorTriangleHeight;
  final double cornerRadius;

  /// Configures additional options for a bubble marker.
  /// The [enableAnchorTriangle] parameter enables a triangle at the bottom of the bubble.
  /// The [anchorTriangleWidth] and [anchorTriangleHeight] parameters specify the dimensions of the triangle.
  /// If no triangle is shown, the bubble is anchored to its center, otherwise it's anchored by the triangle.
  BubbleMarkerOptions({
    this.enableAnchorTriangle = true,
    this.anchorTriangleWidth = 16,
    this.anchorTriangleHeight = 16,
    this.cornerRadius = 64,
  });
}

/// A collection of preset colors for custom markers.
class GoogleMapsCustomMarkerColor {
  static const Color markerRed = Color(0xFFCF2B2B);
  static const Color markerBlue = Color(0xFF61CFBE);
  static const Color markerPink = Color(0xFFCF27CF);
  static const Color markerGreen = Color(0xFF2BCF5A);
  static const Color markerBrown = Color(0xFF7A4242);
  static const Color markerYellow = Color(0xFFD1B634);
  static const Color markerGrey = Color(0xFF566F7A);
  static const Color markerShadow = Color(0x77000000);

  static const List<Color> markerColors = [
    GoogleMapsCustomMarkerColor.markerGrey,
    GoogleMapsCustomMarkerColor.markerBlue,
    GoogleMapsCustomMarkerColor.markerPink,
    GoogleMapsCustomMarkerColor.markerGreen,
    GoogleMapsCustomMarkerColor.markerBrown,
    GoogleMapsCustomMarkerColor.markerYellow,
    GoogleMapsCustomMarkerColor.markerRed,
  ];
}

/// A utility class to create custom markers for Google Maps.
class GoogleMapsCustomMarker {
  static TextStyle _createTextStyle(
      {required double textSize,
      required Color textColor,
      TextStyle? textStyle}) {
    if (textStyle == null) {
      textStyle = TextStyle(
        fontSize: textSize,
        color: textColor,
        fontWeight: FontWeight.bold,
      );
    } else {
      textStyle = textStyle.copyWith(
        fontSize: textSize,
        color: textColor,
      );
    }
    return textStyle;
  }

  /// Creates a custom marker for use with Google Maps.
  ///
  /// Create a marker, and pass it to the [marker] parameter.
  /// It will be returned with the new icon and appropriate anchor.
  /// The shape and applicable options are determined by the [shape] parameter.
  /// The optional [title] will be displayed inside the marker.
  /// The marker will use the [backgroundColor], and the title will use the [foregroundColor] and [textSize].
  /// You can also provide a custom [textStyle] for further text style customization.
  /// The [enableShadow] parameter enables a shadow behind the marker, using [shadowColor], blurred by [shadowBlur] radius.
  /// The [padding] parameter is the padding around the text inside the marker.
  /// For circles and pins, padding is ignored if they have a diameter specified through their options.
  /// The [imagePixelRatio] parameter is the pixel ratio of the generated image.
  /// It defaults to the natural resolution if not specified.
  /// Try changing the imagePixelRatio, if you encounter unexpected scaling on certain displays.
  /// Depending on the shape, there are additional options available for customization:
  /// [circleOptions], [pinOptions] and [bubbleOptions].
  static Future<Marker> createCustomMarker({
    required Marker marker,
    required MarkerShape shape,
    String? title,
    Color backgroundColor = GoogleMapsCustomMarkerColor.markerRed,
    Color foregroundColor = Colors.white,
    double textSize = 20,
    bool enableShadow = true,
    Color shadowColor = GoogleMapsCustomMarkerColor.markerShadow,
    double shadowBlur = 8,
    double padding = 32,
    TextStyle? textStyle,
    double? imagePixelRatio,
    CircleMarkerOptions? circleOptions,
    PinMarkerOptions? pinOptions,
    BubbleMarkerOptions? bubbleOptions,
  }) async {
    textStyle = _createTextStyle(
      textSize: textSize,
      textColor: foregroundColor,
      textStyle: textStyle,
    );

    if (shape == MarkerShape.circle &&
        (pinOptions != null || bubbleOptions != null)) {
      if (kDebugMode) {
        print(
            'GOOGLE_MAPS_CUSTOM_MARKER - WARNING: pin or bubble options supplied to a circle marker');
      }
    }
    if (shape == MarkerShape.pin &&
        (circleOptions != null || bubbleOptions != null)) {
      if (kDebugMode) {
        print(
            'GOOGLE_MAPS_CUSTOM_MARKER - WARNING: circle or bubble options supplied to a pin marker');
      }
    }
    if (shape == MarkerShape.bubble &&
        (circleOptions != null || pinOptions != null)) {
      if (kDebugMode) {
        print(
            'GOOGLE_MAPS_CUSTOM_MARKER - WARNING: circle or pin options supplied to a bubble marker');
      }
    }
    if (shape == MarkerShape.bubble && title == null) {
      if (kDebugMode) {
        print(
            'GOOGLE_MAPS_CUSTOM_MARKER - WARNING: bubble marker created without a title. Consider using pin instead.');
      }
    }

    final double shadowNeededSpace = enableShadow ? shadowBlur : 0;

    // Draw the text
    TextSpan span = TextSpan(
      style: textStyle,
      text: title,
    );
    TextPainter painter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: ui.TextDirection.ltr,
    );
    painter.layout();

    ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    Canvas canvas = Canvas(pictureRecorder);

    switch (shape) {
      case MarkerShape.circle:
        {
          circleOptions ??= CircleMarkerOptions();

          // Draw circle with text inside
          final double diameter =
              circleOptions.diameter ?? painter.width + padding;
          final double radius = diameter / 2;

          // Full bitmap dimensions including shadow
          final double bitmapWidth = diameter + shadowNeededSpace * 2;
          final double bitmapHeight = diameter + shadowNeededSpace * 2;

          // Draw shadow
          if (enableShadow) {
            final Paint shadowPaint = Paint()
              ..color = shadowColor
              ..maskFilter =
                  ui.MaskFilter.blur(ui.BlurStyle.normal, shadowBlur / 2);
            canvas.drawCircle(
              Offset(bitmapWidth / 2, bitmapHeight / 2),
              radius,
              shadowPaint,
            );
          }

          // Draw the circle
          canvas.drawCircle(
            Offset(bitmapWidth / 2, bitmapHeight / 2),
            radius,
            Paint()..color = backgroundColor,
          );

          // Draw the text in the center
          painter.paint(
            canvas,
            Offset(
              (bitmapWidth - painter.width) / 2,
              (bitmapHeight - painter.height) / 2,
            ),
          );

          // Convert canvas to image
          final ui.Image img = await pictureRecorder.endRecording().toImage(
                bitmapWidth.toInt(),
                bitmapHeight.toInt(),
              );
          final ByteData? byteData =
              await img.toByteData(format: ui.ImageByteFormat.png);
          if (byteData == null) {
            throw Exception('Failed to convert image to ByteData');
          }

          BitmapDescriptor bitmap = BitmapDescriptor.bytes(
            byteData.buffer.asUint8List(),
            imagePixelRatio: imagePixelRatio,
          );

          return marker.copyWith(
            iconParam: bitmap,
            anchorParam: const Offset(0.5, 0.5), // Center of the circle
          );
        }

      case MarkerShape.pin:
        {
          pinOptions ??= PinMarkerOptions();

          // Pin shape: circle with a triangle (like a pin icon)

          final double diameter =
              pinOptions.diameter ?? painter.width + padding;
          final double radius = diameter / 2;
          final double pinHeight = radius; //anchorTriangleHeight;

          // Full bitmap dimensions including shadow and anchor
          final double bitmapWidth = diameter + shadowNeededSpace * 2;
          final double bitmapHeight =
              diameter + shadowNeededSpace * 2 + pinHeight;

          // Draw shadow
          if (enableShadow) {
            final Paint shadowPaint = Paint()
              ..color = shadowColor
              ..maskFilter =
                  ui.MaskFilter.blur(ui.BlurStyle.normal, shadowBlur / 2);

            //Pin shadow
            var arrowPath = Path();
            arrowPath.moveTo(
              shadowNeededSpace,
              shadowNeededSpace + diameter / 2,
            );
            arrowPath.arcTo(
              Rect.fromCircle(
                  center:
                      Offset(bitmapWidth / 2, shadowNeededSpace + diameter / 2),
                  radius: diameter / 2), // Semicircle bounds
              -pi, // Start angle (π for semicircle starting on the left)
              pi, // Sweep angle (draw a full semicircle)
              false, // Do not force the start to be a new sub-path
            );
            arrowPath.quadraticBezierTo(
              bitmapWidth - shadowNeededSpace, //control point
              shadowNeededSpace + diameter / 5 * 4,
              bitmapWidth / 2, //end point
              shadowNeededSpace + diameter + pinHeight,
            );
            arrowPath.quadraticBezierTo(
              shadowNeededSpace, //control point
              shadowNeededSpace + diameter / 5 * 4,
              shadowNeededSpace, //end point
              shadowNeededSpace + diameter / 2,
            );
            arrowPath.close();
            canvas.drawPath(arrowPath, shadowPaint);
          }

          // Draw the pin
          var arrowPath = Path();
          arrowPath.moveTo(
            shadowNeededSpace,
            shadowNeededSpace + diameter / 2,
          );
          arrowPath.arcTo(
            Rect.fromCircle(
                center:
                    Offset(bitmapWidth / 2, shadowNeededSpace + diameter / 2),
                radius: diameter / 2), // Semicircle bounds
            -pi, // Start angle (π for semicircle starting on the left)
            pi, // Sweep angle (draw a full semicircle)
            false, // Do not force the start to be a new sub-path
          );
          arrowPath.quadraticBezierTo(
            bitmapWidth - shadowNeededSpace, //control point
            shadowNeededSpace + diameter / 5 * 4,
            bitmapWidth / 2, //end point
            shadowNeededSpace + diameter + pinHeight,
          );
          arrowPath.quadraticBezierTo(
            shadowNeededSpace, //control point
            shadowNeededSpace + diameter / 5 * 4,
            shadowNeededSpace, //end point
            shadowNeededSpace + diameter / 2,
          );
          arrowPath.close();
          canvas.drawPath(arrowPath, Paint()..color = backgroundColor);

          // Draw the pin dot circle
          if (title == null) {
            double pinDotCircleRadius = radius * 0.4;
            canvas.drawCircle(
              Offset(bitmapWidth / 2, shadowNeededSpace + radius),
              pinDotCircleRadius,
              Paint()..color = pinOptions.pinDotColor,
            );
          }

          // Draw the text in the center of the circle
          painter.paint(
            canvas,
            Offset(
              (bitmapWidth - painter.width) / 2,
              shadowNeededSpace + (diameter - painter.height) / 2,
            ),
          );

          // Convert canvas to image
          final ui.Image img = await pictureRecorder.endRecording().toImage(
                bitmapWidth.toInt(),
                bitmapHeight.toInt(),
              );
          final ByteData? byteData =
              await img.toByteData(format: ui.ImageByteFormat.png);
          if (byteData == null) {
            throw Exception('Failed to convert image to ByteData');
          }

          BitmapDescriptor bitmap = BitmapDescriptor.bytes(
            byteData.buffer.asUint8List(),
            imagePixelRatio: imagePixelRatio,
          );

          double anchorY = 1 - shadowNeededSpace / bitmapHeight;
          return marker.copyWith(
            iconParam: bitmap,
            anchorParam: Offset(0.5, anchorY), // Bottom of the pin
          );
        }

      case MarkerShape.bubble:
        {
          bubbleOptions ??= BubbleMarkerOptions();

          final double paddingHorizontal = padding;
          final double paddingVertical = padding / 2;
          int textWidth = painter.width.toInt();
          int textHeight = painter.height.toInt();
          double bubbleWidth = textWidth + paddingHorizontal;
          double bubbleHeight = textHeight + paddingVertical;

          // Full bitmap dimensions including shadow space and anchor
          final double extraPadding = enableShadow ? shadowNeededSpace : 8;
          final double bitmapWidth = bubbleWidth + extraPadding * 2;
          final double bitmapHeight = bubbleHeight +
              extraPadding * 2 +
              (bubbleOptions.enableAnchorTriangle
                  ? bubbleOptions.anchorTriangleHeight
                  : 0);

          ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
          Canvas canvas = Canvas(pictureRecorder);

          // Draw shadow
          if (enableShadow) {
            final Paint shadowPaint = Paint()
              ..color = shadowColor
              ..maskFilter =
                  ui.MaskFilter.blur(ui.BlurStyle.normal, shadowBlur / 2);

            canvas.drawRRect(
              RRect.fromLTRBAndCorners(
                shadowBlur, // Shift shadow
                shadowBlur,
                bubbleWidth + shadowBlur,
                bubbleHeight + shadowBlur,
                bottomLeft: Radius.circular(bubbleOptions.cornerRadius),
                bottomRight: Radius.circular(bubbleOptions.cornerRadius),
                topLeft: Radius.circular(bubbleOptions.cornerRadius),
                topRight: Radius.circular(bubbleOptions.cornerRadius),
              ),
              shadowPaint,
            );
          }

          // Draw the bubble
          canvas.drawRRect(
            RRect.fromLTRBAndCorners(
              shadowBlur, // Shift the bubble
              shadowBlur,
              bubbleWidth + shadowBlur,
              bubbleHeight + shadowBlur,
              bottomLeft: Radius.circular(bubbleOptions.cornerRadius),
              bottomRight: Radius.circular(bubbleOptions.cornerRadius),
              topLeft: Radius.circular(bubbleOptions.cornerRadius),
              topRight: Radius.circular(bubbleOptions.cornerRadius),
            ),
            Paint()..color = backgroundColor,
          );

          // Draw the anchor triangle
          if (bubbleOptions.enableAnchorTriangle) {
            var arrowPath = Path();
            arrowPath.moveTo(
              shadowBlur +
                  bubbleWidth / 2 -
                  bubbleOptions.anchorTriangleWidth / 2,
              shadowBlur + bubbleHeight,
            );
            arrowPath.lineTo(
              shadowBlur + bubbleWidth / 2,
              shadowBlur + bubbleHeight + bubbleOptions.anchorTriangleHeight,
            );
            arrowPath.lineTo(
              shadowBlur +
                  bubbleWidth / 2 +
                  bubbleOptions.anchorTriangleWidth / 2,
              shadowBlur + bubbleHeight,
            );
            arrowPath.close();
            canvas.drawPath(arrowPath, Paint()..color = backgroundColor);
          }

          // Draw the text, shifted for shadow
          painter.paint(
            canvas,
            Offset(shadowBlur + paddingHorizontal / 2,
                shadowBlur + paddingVertical / 2),
          );

          // Convert the canvas to an image
          final ui.Image img = await pictureRecorder.endRecording().toImage(
                bitmapWidth.toInt(),
                bitmapHeight.toInt(),
              );

          final ByteData? byteData =
              await img.toByteData(format: ui.ImageByteFormat.png);
          if (byteData == null) {
            throw Exception('Failed to convert image to ByteData');
          }

          BitmapDescriptor bitmap = BitmapDescriptor.bytes(
              byteData.buffer.asUint8List(),
              imagePixelRatio: imagePixelRatio);

          double anchorY = bubbleOptions.enableAnchorTriangle
              ? 1 - extraPadding / bitmapHeight
              : 0.5;
          return marker.copyWith(
            iconParam: bitmap,
            anchorParam: Offset(0.5, anchorY),
          );
        }
    }
  }
}
