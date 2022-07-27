import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

Future qrDialog(BuildContext context, int pointId) async {
  return showDialog(
    context: context,
    builder: (context) {
      return QrImage(
          data: pointId.toString(),
          errorCorrectionLevel: QrErrorCorrectLevel.H,
          version: QrVersions.auto,
          size: 150.0,
          backgroundColor: Colors.white,
          gapless: true);
    },
  );
}
