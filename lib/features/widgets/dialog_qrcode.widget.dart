import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'navigation_printqr.widget.dart';

Future qrDialog(BuildContext context, dynamic e) async {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        insetPadding: const EdgeInsets.symmetric(horizontal: 500, vertical: 24),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                e["name"],
                style: const TextStyle(fontSize: 20),
              ),
              QrImage(
                data: e["id"].toString(),
                size: 150,
                errorCorrectionLevel: QrErrorCorrectLevel.H,
                backgroundColor: Colors.white,
                gapless: true,
              ),
              Text(
                e["descricao"],
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Sair"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PrintQR()));
                    },
                    child: const Text("Imprimir"),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
