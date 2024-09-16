library google_maps_custom_marker;

import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:ui' as ui;

/// A Calculator.
class Calculator {
  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;
}

class GoogleMapsCustomMarker {

  GoogleMapsCustomMarker._();

  static bool? _isMobile;

  static Future<BitmapDescriptor> createNumberedMarkerBitmap(int number, {Color color = Colors.lightBlue}) async {
    final double baseSize = kIsWeb ? (isMobile() ? 10 : 24) : 40; // Smaller size for the marker
    final double circleSize = baseSize * 2; // Circle diameter
    final double textSize = baseSize * (kIsWeb && isMobile() ? 0.5 : 1); // Text size proportional to the marker

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Draw a shadow (a blurred circle behind the main circle)
    final Paint shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.3) // Shadow color with some transparency
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 2.0); // Adjust blur radius

    canvas.drawCircle(
      Offset(circleSize / 2, circleSize / 2),
      circleSize / 2 - 2, // Make the shadow slightly larger
      shadowPaint,
    );

    // Draw the main circle
    final Paint paint = Paint()..color = color;
    canvas.drawCircle(
      Offset(circleSize / 2, circleSize / 2),
      circleSize / 2 - 6,
      paint,
    );

    // Draw the number with appropriate size
    final TextPainter textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    textPainter.text = TextSpan(
      text: number.toString(),
      style: TextStyle(
        fontSize: textSize,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (circleSize - textPainter.width) / 2,
        (circleSize - textPainter.height) / 2,
      ),
    );

    // Convert the canvas to an image at the original size
    final ui.Image img = await pictureRecorder.endRecording().toImage(circleSize.toInt(), circleSize.toInt());

    // Convert to ByteData directly from the original image
    final ByteData? byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to convert image to ByteData');
    }

    return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
  }

  static bool isMobile() {
    if (_isMobile != null) return _isMobile!;
    if (!kIsWeb) return true;
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    final patterns = [
      r'(android|bb\d+|meego).+mobile',
      r'avantgo',
      r'bada\/',
      r'blackberry',
      r'blazer',
      r'compal',
      r'elaine',
      r'fennec',
      r'hiptop',
      r'iemobile',
      r'ip(hone|od)',
      r'iris',
      r'kindle',
      r'lge ',
      r'maemo',
      r'midp',
      r'mmp',
      r'mobile.+firefox',
      r'netfront',
      r'opera m(ob|in)i',
      r'palm( os)?',
      r'phone',
      r'p(ixi|re)\/',
      r'plucker',
      r'pocket',
      r'psp',
      r'series(4|6)0',
      r'symbian',
      r'treo',
      r'up\.(browser|link)',
      r'vodafone',
      r'wap',
      r'windows ce',
      r'xda',
      r'xiino',
      r'1207',
      r'6310',
      r'6590',
      r'3gso',
      r'4thp',
      r'50[1-6]i',
      r'770s',
      r'802s',
      r'a wa',
      r'abac',
      r'ac(er|oo|s\-)',
      r'ai(ko|rn)',
      r'al(av|ca|co)',
      r'amoi',
      r'an(ex|ny|yw)',
      r'aptu',
      r'ar(ch|go)',
      r'as(te|us)',
      r'attw',
      r'au(di|\-m|r |s )',
      r'avan',
      r'be(ck|ll|nq)',
      r'bi(lb|rd)',
      r'bl(ac|az)',
      r'br(e|v)w',
      r'bumb',
      r'bw\-(n|u)',
      r'c55\/',
      r'capi',
      r'ccwa',
      r'cdm\-',
      r'cell',
      r'chtm',
      r'cldc',
      r'cmd\-',
      r'co(mp|nd)',
      r'craw',
      r'da(it|ll|ng)',
      r'dbte',
      r'dc\-s',
      r'devi',
      r'dica',
      r'dmob',
      r'do(c|p)o',
      r'ds(12|\-d)',
      r'el(49|ai)',
      r'em(l2|ul)',
      r'er(ic|k0)',
      r'esl8',
      r'ez([4-7]0|os|wa|ze)',
      r'fetc',
      r'fly(\-|_)',
      r'g1 u',
      r'g560',
      r'gene',
      r'gf\-5',
      r'g\-mo',
      r'go(\.w|od)',
      r'gr(ad|un)',
      r'haie',
      r'hcit',
      r'hd\-(m|p|t)',
      r'hei\-',
      r'hi(pt|ta)',
      r'hp( i|ip)',
      r'hs\-c',
      r'ht(c(\-| |_|a|g|p|s|t)|tp)',
      r'hu(aw|tc)',
      r'i\-(20|go|ma)',
      r'i230',
      r'iac( |\-|\/)',
      r'ibro',
      r'idea',
      r'ig01',
      r'ikom',
      r'im1k',
      r'inno',
      r'ipaq',
      r'iris',
      r'ja(t|v)a',
      r'jbro',
      r'jemu',
      r'jigs',
      r'kddi',
      r'keji',
      r'kgt( |\/)',
      r'klon',
      r'kpt ',
      r'kwc\-',
      r'kyo(c|k)',
      r'le(no|xi)',
      r'lg( g|\/(k|l|u)|50|54|\-[a-w])',
      r'libw',
      r'lynx',
      r'm1\-w',
      r'm3ga',
      r'm50\/',
      r'ma(te|ui|xo)',
      r'mc(01|21|ca)',
      r'm\-cr',
      r'me(rc|ri)',
      r'mi(o8|oa|ts)',
      r'mmef',
      r'mo(01|02|bi|de|do|t(\-| |o|v)|zz)',
      r'mt(50|p1|v )',
      r'mwbp',
      r'mywa',
      r'n10[0-2]',
      r'n20[2-3]',
      r'n30(0|2)',
      r'n50(0|2|5)',
      r'n7(0(0|1)|10)',
      r'ne((c|m)\-|on|tf|wf|wg|wt)',
      r'nok(6|i)',
      r'nzph',
      r'o2im',
      r'op(ti|wv)',
      r'oran',
      r'owg1',
      r'p800',
      r'pan(a|d|t)',
      r'pdxg',
      r'pg(13|\-([1-8]|c))',
      r'phil',
      r'pire',
      r'pl(ay|uc)',
      r'pn\-2',
      r'po(ck|rt|se)',
      r'prox',
      r'psio',
      r'pt\-g',
      r'qa\-a',
      r'qc(07|12|21|32|60|\-[2-7]|i\-)',
      r'qtek',
      r'r380',
      r'r600',
      r'raks',
      r'rim9',
      r'ro(ve|zo)',
      r's55\/',
      r'sa(ge|ma|mm|ms|ny|va)',
      r'sc(01|h\-|oo|p\-)',
      r'sdk\/',
      r'se(c(\-|0|1)|47|mc|nd|ri)',
      r'sgh\-',
      r'shar',
      r'sie(\-|m)',
      r'sk\-0',
      r'sl(45|id)',
      r'sm(al|ar|b3|it|t5)',
      r'so(ft|ny)',
      r'sp(01|h\-|v\-|v )',
      r'sy(01|mb)',
      r't2(18|50)',
      r't6(00|10|18)',
      r'ta(gt|lk)',
      r'tcl\-',
      r'tdg\-',
      r'tel(i|m)',
      r'tim\-',
      r't\-mo',
      r'to(pl|sh)',
      r'ts(70|m\-|m3|m5)',
      r'tx\-9',
      r'up(\.b|g1|si)',
      r'utst',
      r'v400',
      r'v750',
      r'veri',
      r'vi(rg|te)',
      r'vk(40|5[0-3]|\-v)',
      r'vm40',
      r'voda',
      r'vulc',
      r'vx(52|53|60|61|70|80|81|83|85|98)',
      r'w3c(\-| )',
      r'webc',
      r'whit',
      r'wi(g |nc|nw)',
      r'wmlb',
      r'wonu',
      r'x700',
      r'yas\-',
      r'your',
      r'zeto',
      r'zte\-',
    ];
    bool isMobile = patterns.any((pattern) => RegExp(pattern).hasMatch(userAgent));
    //logger.t("CrossplatformUtils.isMobile() -> userAgent=$userAgent, isMobile=$isMobile");
    _isMobile = isMobile;
    return isMobile; //userAgent.contains('mobi');
  }
}