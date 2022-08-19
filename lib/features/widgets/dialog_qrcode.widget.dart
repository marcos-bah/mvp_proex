import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mvp_proex/invoice_service.dart';
import 'package:mvp_proex/features/point/point.model.dart';

Future qrDialog(
  BuildContext context,
  PointModel point,
) async {
  final PdfInvoiceService service = PdfInvoiceService();

  return showDialog(
    context: context,
    builder: (context) {
      Size size = MediaQuery.of(context).size; //Mais responsivo
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        alignment: Alignment.center,
        insetPadding:
            EdgeInsets.symmetric(horizontal: size.width / 4, vertical: 24),
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                point.name,
                style: const TextStyle(fontSize: 20),
              ),
              QrImage(
                data: point.id.toString(),
                size: 150,
                errorCorrectionLevel: QrErrorCorrectLevel.H,
                backgroundColor: Colors.white,
                gapless: true,
              ),
              Text(
                point.description,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              OverflowBar(
                overflowAlignment: OverflowBarAlignment.end,
                overflowDirection: VerticalDirection.down,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Sair"),
                  ),
                  TextButton(
                    onPressed: () async {
                      final data = await service.createPDF([point]);
                      service.savePdfFile("QR_${point.name}", data);
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
