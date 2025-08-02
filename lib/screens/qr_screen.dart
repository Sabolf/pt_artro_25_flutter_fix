import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({super.key});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  String? scannedCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Code')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (BarcodeCapture) {
                final List<Barcode> barcodes = BarcodeCapture.barcodes;
                for (final barcode in barcodes) {
                  final code = barcode.rawValue;
                  if (code != null){
                    scannedCode = code;
                    print(code);
                  }
                }
                // Optionally stop the camera or navigate away here
              },
            ),
          ),
          if (scannedCode != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Scanned QR code: $scannedCode'),
            ),
        ],
      ),
    );
  }
}
