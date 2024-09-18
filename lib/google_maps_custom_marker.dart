library google_maps_custom_marker;

import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:ui' as ui;

enum GoogleMapsCustomMarkerType { circular, circularNumbered }
enum MarkerShape { circle, pin, bubble }

/// A utility class to create custom BitmapDescriptors to use with markers for Google Maps.
class GoogleMapsCustomMarker {

  /// Creates a custom BitmapDescriptor for a marker, assigns it as the icon, and sets the correct anchor.
  ///
  /// [type] is the type of custom marker to create.
  /// [marker] is the marker to assign the custom icon to, it will be returned with the new icon and anchor assigned to it.
  /// [number] is the number to display in the center of the marker, and is required for circularNumbered marker types.
  /// [title] is the text to display in the center of the marker, and is required for textBubble marker types.
  /// [backgroundColor] is the color of the circle.
  /// [foregroundColor] is the color of the text.
  /// [size] is the size of the marker.
  /// [textSizeMultiple] is the text size proportional to the marker, and can be used to control padding between the text and its encompassing circle.
  /// [enableShadow] is a flag to enable shadow.
  /// [shadowColor] is the color of the shadow.
  /// [shadowBlur] is the blur radius of the shadow.
  /// [textStyle] is the style of the text.
  /// [labelPadding] is the padding around the text in the textBubble marker.
  /// [imagePixelRatio] is the scale of the image relative to the device's pixel ratio, and defaults to the natural resolution if not specified.
  static Future<Marker> createCustomIconForMarker( {
    required GoogleMapsCustomMarkerType type,
    required Marker marker,
    int? number,
    String? title,
    Color backgroundColor = Colors.lightBlue,
    Color foregroundColor = Colors.white,
    double size = 48,
    double textSize = 24,
    bool enableShadow = true,
    Color shadowColor = const Color(0xA0000000),
    double shadowBlur = 6,
    TextStyle? textStyle,
    double? labelPadding,
    double? imagePixelRatio})
  async {
    try {
      if (type == GoogleMapsCustomMarkerType.circularNumbered && number == null) {
        throw Exception('GOOGLE_MAPS_CUSTOM_MARKER EXCEPTION: Number must be provided for a circular numbered marker.');
      }
      /*if (type == GoogleMapsCustomMarkerType.textBubble && title == null) {
        throw Exception('GOOGLE_MAPS_CUSTOM_MARKER EXCEPTION: Title must be provided for a text bubble marker.');
      }*/
      BitmapDescriptor bitmap;
      switch (type) {
        case GoogleMapsCustomMarkerType.circular:
          bitmap = await _createCircularMarkerBitmap(
            backgroundColor: backgroundColor,
            size: size,
            textSize: textSize,
            enableShadow: enableShadow,
            shadowColor: shadowColor,
            shadowBlur: shadowBlur,
            imagePixelRatio: imagePixelRatio,
          );
          break;
        case GoogleMapsCustomMarkerType.circularNumbered:
          bitmap = await _createCircularNumberedMarkerBitmap(
            number: number!,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            size: size,
            textSize: textSize,
            enableShadow: enableShadow,
            shadowColor: shadowColor,
            shadowBlur: shadowBlur,
            textStyle: textStyle,
            imagePixelRatio: imagePixelRatio,
          );
          break;
          /*
        case GoogleMapsCustomMarkerType.textBubble:
          bitmap = await _createAnchoredTextBubbleMarkerBitmap(
            title: title!,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            textSize: size,
            enableShadow: enableShadow,
            shadowColor: shadowColor,
            shadowBlur: shadowBlur,
            textStyle: textStyle,
            padding: labelPadding ?? 40,
            imagePixelRatio: imagePixelRatio,
          );
          break;*/
      }

      return marker.copyWith(
        iconParam: bitmap,
        anchorParam:  const Offset(0.5, 0.5),//type == GoogleMapsCustomMarkerType.textBubble ? const Offset(0.5, 1) : const Offset(0.5, 0.5),
      );
    } catch (e) {
      print(e);
      return marker;
    }
  }

  /// Draws a Circle with an optional shadow, and returns the bitmap size which includes the shadow.
  ///
  /// [backgroundColor] is the color of the circle.
  /// [size] is the size of the marker.
  /// [enableShadow] is a flag to enable shadow.
  /// [shadowColor] is the color of the shadow.
  /// [shadowBlur] is the blur radius of the shadow.
  static double _drawCircle({
    required Canvas canvas,
    required Color backgroundColor,
    required double size,
    required bool enableShadow,
    required Color shadowColor,
    required double shadowBlur})
  {
    final double radiusSize = size; // Smaller size for the marker
    final double circleSize = radiusSize * 2; // Circle diameter
    final int shadowSpacer = enableShadow ? (shadowBlur*2).toInt() : 0;
    final double bitmapSize = circleSize + shadowSpacer;

    if (enableShadow){
      // Draw a shadow (a blurred circle behind the main circle)
      final Paint shadowPaint = Paint()
        ..color = shadowColor // Shadow color with some transparency
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, shadowBlur/2); // Adjust blur radius

      canvas.drawCircle(
        Offset(bitmapSize / 2, bitmapSize / 2),
        radiusSize,
        shadowPaint,
      );
    }

    // Draw the main circle
    final Paint paint = Paint()..color = backgroundColor;
    canvas.drawCircle(
      Offset(bitmapSize / 2, bitmapSize / 2),
      radiusSize,
      paint,
    );

    return bitmapSize;
  }

  /// Draws an anchored bubble with an optional shadow, and returns the bitmap size which includes the shadow.
  ///
  /// [backgroundColor] is the color of the bubble.
  /// [size] is the size of the marker.
  /// [enableShadow] is a flag to enable shadow.
  /// [shadowColor] is the color of the shadow.
  /// [shadowBlur] is the blur radius of the shadow.
  static double _drawAnchoredBubble({
    required Canvas canvas,
    required Color backgroundColor,
    required double size,
    required bool enableShadow,
    required Color shadowColor,
    required double shadowBlur})
  {
    final double radiusSize = size; // Smaller size for the marker
    final double circleSize = radiusSize * 2; // Circle diameter
    final int shadowSpacer = enableShadow ? (shadowBlur*2).toInt() : 0;
    final double bitmapSize = circleSize + shadowSpacer;

    if (enableShadow){
      // Draw a shadow (a blurred circle behind the main circle)
      final Paint shadowPaint = Paint()
        ..color = shadowColor // Shadow color with some transparency
        ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, shadowBlur/2); // Adjust blur radius

      canvas.drawCircle(
        Offset(bitmapSize / 2, bitmapSize / 2),
        radiusSize,
        shadowPaint,
      );
    }

    // Draw the main circle
    final Paint paint = Paint()..color = backgroundColor;
    canvas.drawCircle(
      Offset(bitmapSize / 2, bitmapSize / 2),
      radiusSize,
      paint,
    );

    return bitmapSize;
  }

  static TextStyle _createTextStyle({
    required double textSize,
    required Color textColor,
    TextStyle? textStyle})
  {
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

  /// Creates a BitmapDescriptor for a circular marker.
  ///
  /// [backgroundColor] is the color of the circle.
  /// [size] is the size of the marker.
  /// [enableShadow] is a flag to enable shadow.
  /// [shadowColor] is the color of the shadow.
  /// [shadowBlur] is the blur radius of the shadow.
  /// [imagePixelRatio] is the scale of the image relative to the device's pixel ratio, and defaults to the natural resolution if not specified.
  static Future<BitmapDescriptor> _createCircularMarkerBitmap({
    required Color backgroundColor,
    required double size,
    required double textSize,
    required bool enableShadow,
    required Color shadowColor,
    required double shadowBlur,
    double? imagePixelRatio})
  async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final bitmapSize = _drawCircle(
      canvas: canvas,
      backgroundColor: backgroundColor,
      size: size,
      enableShadow: enableShadow,
      shadowColor: shadowColor,
      shadowBlur: shadowBlur,
    );

    int imgSize = bitmapSize.toInt();
    // Convert the canvas to an image at the original size
    final ui.Image img = await pictureRecorder.endRecording().toImage(imgSize, imgSize);

    // Convert to ByteData directly from the original image
    final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to convert image to ByteData');
    }

    return BitmapDescriptor.bytes(byteData.buffer.asUint8List(), imagePixelRatio: imagePixelRatio);
  }

  /// Creates a BitmapDescriptor for a circular marker with a number in the center.
  ///
  /// [number] is the number to display in the center of the marker.
  /// [backgroundColor] is the color of the circle.
  /// [foregroundColor] is the color of the text.
  /// [size] is the size of the marker.
  /// [textSizeMultiple] is the text size proportional to the marker, and can be used to control padding between the text and its encompassing circle.
  /// [enableShadow] is a flag to enable shadow.
  /// [shadowColor] is the color of the shadow.
  /// [shadowBlur] is the blur radius of the shadow.
  /// [textStyle] is the style of the text.
  /// [imagePixelRatio] is the scale of the image relative to the device's pixel ratio, and defaults to the natural resolution if not specified.
  static Future<BitmapDescriptor> _createCircularNumberedMarkerBitmap({
    required int number,
    required Color backgroundColor,
    required Color foregroundColor,
    required double size,
    required double textSize,
    required bool enableShadow,
    required Color shadowColor,
    required double shadowBlur,
    TextStyle? textStyle,
    double? imagePixelRatio})
  async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final bitmapSize = _drawCircle(
      canvas: canvas,
      backgroundColor: backgroundColor,
      size: size,
      enableShadow: enableShadow,
      shadowColor: shadowColor,
      shadowBlur: shadowBlur,
    );

    // Draw the number with appropriate size
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textStyle = _createTextStyle(
      textSize: textSize,
      textColor: foregroundColor,
      textStyle: textStyle,
    );
    textPainter.text = TextSpan(
      text: number.toString(),
      style: textStyle,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (bitmapSize - textPainter.width) / 2,
        (bitmapSize - textPainter.height) / 2,
      ),
    );

    // Convert the canvas to an image at the original size
    int imgSize = bitmapSize.toInt();
    final ui.Image img = await pictureRecorder.endRecording().toImage(imgSize, imgSize);

    // Convert to ByteData directly from the original image
    final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to convert image to ByteData');
    }

    return BitmapDescriptor.bytes(byteData.buffer.asUint8List(), imagePixelRatio: imagePixelRatio);
  }


  static Future<Marker> createCustomMarker({
    required Marker marker,
    String? title,
    Color backgroundColor = Colors.blueGrey,
    Color foregroundColor = Colors.white,
    Color pinDotColor = Colors.white, //only if pin, only if no label
    double textSize = 20,
    bool enableShadow = true,
    Color shadowColor = const Color(0xaa000000),
    double shadowBlur = 12, //TODO support large shadow values
    bool enableAnchorTriangle = true,
    double anchorTriangleWidth = 16, //bubble only
    double anchorTriangleHeight = 16, //bubble only
    double padding = 32,
    double cornerRadius = 64,
    TextStyle? textStyle,
    MarkerShape shape = MarkerShape.pin,
    double? circleDiameter, //if not specified, it will fit to text plus padding
    double? imagePixelRatio})
  async {
    textStyle = _createTextStyle(
      textSize: textSize,
      textColor: foregroundColor,
      textStyle: textStyle,
    );

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
          // Draw circle with text inside
          final double diameter = circleDiameter ?? painter.width + padding;
          final double radius = diameter / 2;

          // Full bitmap dimensions including shadow
          final double bitmapWidth = diameter + shadowNeededSpace * 2;
          final double bitmapHeight = diameter + shadowNeededSpace * 2;

          // Draw shadow
          if (enableShadow) {
            final Paint shadowPaint = Paint()
              ..color = shadowColor
              ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, shadowBlur / 2);
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
          final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
          if (byteData == null) {
            throw Exception('Failed to convert image to ByteData');
          }

          BitmapDescriptor bitmap = BitmapDescriptor.bytes(
            byteData.buffer.asUint8List(),
            imagePixelRatio: imagePixelRatio,
          );

          return marker.copyWith(
            iconParam: bitmap,
            anchorParam: Offset(0.5, 0.5), // Center of the circle
          );
        }

      case MarkerShape.pin:
        {
          // Pin shape: circle with a triangle (like a pin icon)

          final double diameter = circleDiameter ?? painter.width + padding;
          final double radius = diameter / 2;
          final double pinHeight = radius;//anchorTriangleHeight;

          // Full bitmap dimensions including shadow and anchor
          final double bitmapWidth = diameter + shadowNeededSpace * 2;
          final double bitmapHeight = diameter + shadowNeededSpace * 2 + pinHeight;

          // Draw shadow
          if (enableShadow) {
            final Paint shadowPaint = Paint()
              ..color = shadowColor
              ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, shadowBlur / 2);

            //Pin shadow
            var arrowPath = Path();
            arrowPath.moveTo(
              shadowNeededSpace,
              shadowNeededSpace + diameter/2,
            );
            arrowPath.arcTo(
              Rect.fromCircle(center: Offset(bitmapWidth / 2, shadowNeededSpace + diameter / 2), radius: diameter / 2), // Semicircle bounds
              -pi, // Start angle (π for semicircle starting on the left)
              pi,  // Sweep angle (draw a full semicircle)
              false, // Do not force the start to be a new sub-path
            );
            arrowPath.quadraticBezierTo(
              bitmapWidth-shadowNeededSpace, //control point
              shadowNeededSpace + diameter/5 * 4,
              bitmapWidth / 2, //end point
              shadowNeededSpace + diameter + pinHeight,
            );
            arrowPath.quadraticBezierTo(
              shadowNeededSpace, //control point
              shadowNeededSpace + diameter/5 * 4,
              shadowNeededSpace, //end point
              shadowNeededSpace + diameter/2,
            );
            arrowPath.close();
            canvas.drawPath(arrowPath, shadowPaint);
          }

          // Draw the pin
          var arrowPath = Path();
          arrowPath.moveTo(
            shadowNeededSpace,
            shadowNeededSpace + diameter/2,
          );
          arrowPath.arcTo(
            Rect.fromCircle(center: Offset(bitmapWidth / 2, shadowNeededSpace + diameter / 2), radius: diameter / 2), // Semicircle bounds
            -pi, // Start angle (π for semicircle starting on the left)
            pi,  // Sweep angle (draw a full semicircle)
            false, // Do not force the start to be a new sub-path
          );
          arrowPath.quadraticBezierTo(
            bitmapWidth-shadowNeededSpace, //control point
            shadowNeededSpace + diameter/5 * 4,
            bitmapWidth / 2, //end point
            shadowNeededSpace + diameter + pinHeight,
          );
          arrowPath.quadraticBezierTo(
            shadowNeededSpace, //control point
            shadowNeededSpace + diameter/5 * 4,
            shadowNeededSpace, //end point
            shadowNeededSpace + diameter/2,
          );
          arrowPath.close();
          canvas.drawPath(arrowPath, Paint()..color = backgroundColor);

          // Draw the pin dot circle
          if (title == null) {
            double pinDotCircleRadius = radius * 0.4;
            canvas.drawCircle(
              Offset(bitmapWidth / 2, shadowNeededSpace + radius),
              pinDotCircleRadius,
              Paint()..color = pinDotColor,
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
          final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
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
          final double paddingHorizontal = padding;
          final double paddingVertical = padding / 2;
          int textWidth = painter.width.toInt();
          int textHeight = painter.height.toInt();
          double bubbleWidth = textWidth + paddingHorizontal;
          double bubbleHeight = textHeight + paddingVertical;

          // Full bitmap dimensions including shadow space and anchor
          final double bitmapWidth = bubbleWidth + shadowNeededSpace * 2;
          final double bitmapHeight = bubbleHeight + shadowNeededSpace * 2 + (enableAnchorTriangle ? anchorTriangleHeight : 0);

          ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
          Canvas canvas = Canvas(pictureRecorder);

          // Draw shadow
          if (enableShadow) {
            final Paint shadowPaint = Paint()
              ..color = shadowColor
              ..maskFilter = ui.MaskFilter.blur(ui.BlurStyle.normal, shadowBlur / 2);

            canvas.drawRRect(
              RRect.fromLTRBAndCorners(
                shadowBlur, // Shift shadow
                shadowBlur,
                bubbleWidth + shadowBlur,
                bubbleHeight + shadowBlur,
                bottomLeft: Radius.circular(cornerRadius),
                bottomRight: Radius.circular(cornerRadius),
                topLeft: Radius.circular(cornerRadius),
                topRight: Radius.circular(cornerRadius),
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
              bottomLeft: Radius.circular(cornerRadius),
              bottomRight: Radius.circular(cornerRadius),
              topLeft: Radius.circular(cornerRadius),
              topRight: Radius.circular(cornerRadius),
            ),
            Paint()..color = backgroundColor,
          );

          // Draw the anchor triangle
          if (enableAnchorTriangle) {
            var arrowPath = Path();
            arrowPath.moveTo(
              shadowBlur + bubbleWidth / 2 - anchorTriangleWidth / 2,
              shadowBlur + bubbleHeight,
            );
            arrowPath.lineTo(
              shadowBlur + bubbleWidth / 2,
              shadowBlur + bubbleHeight + anchorTriangleHeight,
            );
            arrowPath.lineTo(
              shadowBlur + bubbleWidth / 2 + anchorTriangleWidth / 2,
              shadowBlur + bubbleHeight,
            );
            arrowPath.close();
            canvas.drawPath(arrowPath, Paint()..color = backgroundColor);
          }

          // Draw the text, shifted for shadow
          painter.paint(
            canvas,
            Offset(shadowBlur + paddingHorizontal / 2, shadowBlur + paddingVertical / 2),
          );

          // Convert the canvas to an image
          final ui.Image img = await pictureRecorder.endRecording().toImage(
            bitmapWidth.toInt(),
            bitmapHeight.toInt(),
          );

          final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
          if (byteData == null) {
            throw Exception('Failed to convert image to ByteData');
          }

          BitmapDescriptor bitmap = BitmapDescriptor.bytes(byteData.buffer.asUint8List(), imagePixelRatio: imagePixelRatio);

          double anchorY = enableAnchorTriangle ? 1 - shadowNeededSpace / bitmapHeight : 0.5;
          return marker.copyWith(
            iconParam: bitmap,
            anchorParam: Offset(0.5, anchorY),
          );
        }
    }
  }
}



