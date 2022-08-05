// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class Qrcodescannermvp extends StatefulWidget {
//   const Qrcodescannermvp({Key? key}) : super(key: key);

//   @override
//   State<Qrcodescannermvp> createState() => _ScanQrView();
// }

// class _ScanQrView extends State<Qrcodescannermvp> {
//   Barcode? result;
//   QRViewController? controller;

//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   // Para utilizar o hot reload
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (!kIsWeb) {
//       if (Platform.isAndroid) {
//         controller!.pauseCamera();
//       } else if (Platform.isIOS) {
//         controller!.resumeCamera();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     readQr();
//     return Scaffold(
//       body: QRView(
//         key: qrKey,
//         onQRViewCreated: _onQRViewCreated,
//         overlay: QrScannerOverlayShape(
//           borderColor: Colors.orange,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: 250,
//         ),
//       ),
//     );
//   }

//   void readQr() async {
//     if (result != null) {
//       controller!.pauseCamera();
//       print(result!.code);
//       controller!.dispose();
//     }
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() => this.controller = controller);
//     controller.scannedDataStream.listen((scanData) {
//       setState(() => result = scanData);
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }
