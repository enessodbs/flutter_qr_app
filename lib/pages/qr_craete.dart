import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:share_plus/share_plus.dart';

class QrCraete extends StatefulWidget {
  const QrCraete({super.key});

  @override
  State<QrCraete> createState() => _QrCraeteState();
}

class _QrCraeteState extends State<QrCraete> {
  String? qrData;
  final GlobalKey _qrKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'QR Code Generator',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Center _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onSubmitted: (value) {
                setState(() {
                  qrData = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Enter Data',
                labelStyle: const TextStyle(color: Colors.teal),
                hintText: 'Type something to generate QR',
                hintStyle: TextStyle(color: Colors.teal[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.teal[700]!),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          if (qrData != null && qrData!.isNotEmpty)
            RepaintBoundary(
              key: _qrKey,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 4),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: PrettyQrView.data(
                  data: qrData!,
                  errorCorrectLevel: QrErrorCorrectLevel.H,
                ),
              ),
            ),
          if (qrData == null || qrData!.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Please enter some text to generate QR code',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          const SizedBox(height: 20),
          IconButton(
            onPressed: () async {
              if (qrData != null && qrData!.isNotEmpty) {
                await _shareQrImage();
              }
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
    );
  }

  Future<void> _shareQrImage() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer;

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/qr_code.png';
      File file = File(filePath);
      await file.writeAsBytes(buffer.asUint8List());

      await Share.shareXFiles([XFile(filePath)],
          text: 'Bu QR kodunu paylaşmak istiyorum.');
    } catch (e) {
      debugPrint('QR paylaşımında hata: $e');
    }
  }
}
