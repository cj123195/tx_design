import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

export 'package:qr_code_scanner/qr_code_scanner.dart'
    show Barcode, BarcodeFormat;

/// @title 二维码扫描页面
/// @updateTime 2023/02/17 2:58 下午
/// @author 曹骏
class TxQrScanView extends StatefulWidget {
  const TxQrScanView({super.key});

  @override
  State<StatefulWidget> createState() => _TxQrScanViewState();
}

class _TxQrScanViewState extends State<TxQrScanView> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buildQrView(context),
          Positioned(
            top: 15,
            child: IconButton(
              color: Colors.white,
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Positioned(
            bottom: 15,
            left: 15,
            child: IconButton(
              icon: const Icon(Icons.flip_camera_ios, color: Colors.white),
              onPressed: () async {
                await controller?.flipCamera();
                setState(() {});
              },
            ),
          ),
          Positioned(
            bottom: 15,
            right: 15,
            child: FutureBuilder(
              future: controller?.getFlashStatus(),
              builder: (context, snapshot) {
                return IconButton(
                  onPressed: () async {
                    await controller!.toggleFlash();
                    setState(() {});
                  },
                  icon: Icon(
                    snapshot.data == true ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    final scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 400.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Theme.of(context).colorScheme.secondary,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
      // controller.resumeCamera();
      reassemble();
    });
    controller.scannedDataStream.listen((scanData) {
      controller.stopCamera();
      Navigator.pop(context, scanData);
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('无权限，请开启摄像头权限后重试。'),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
