import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

Future qrDialog(BuildContext context, dynamic e) async {
  final qrKey = GlobalKey();

  return showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Container(
          alignment: Alignment.center,
          constraints: const BoxConstraints(
              minWidth: 10, maxWidth: 320, minHeight: 10, maxHeight: 250),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                e["name"],
                style: const TextStyle(
                  backgroundColor: Colors.white,
                  fontSize: 20,
                ),
              ),
              RepaintBoundary(
                key: qrKey,
                child: QrImage(
                    data: e["id"].toString(),
                    size: 150,
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    backgroundColor: Colors.white,
                    gapless: true),
              ),
              Row(
                //// Colocar botões aqui
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Sair")),
                  TextButton(onPressed: () {}, child: const Text("Imprimir")),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
