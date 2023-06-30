import 'dart:convert';

import 'package:cardapp/model/user_model.dart';
import 'package:cardapp/widgets/my_card.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    late QRViewController controller;

    void _onQRViewCreated(QRViewController qrViewController) {
      controller = qrViewController;
      controller.scannedDataStream.listen((scanData) {
        UserModel _userModel = UserModel.fromJson(jsonDecode(scanData.code!));
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
              content: MyCard(
            email: _userModel.email,
            name: _userModel.name,
            phone: _userModel.phone,
          )),
        );
      });
    }

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.81,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  "Place QR in the center",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Opacity(
                opacity: 0.9,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderRadius: 10,
                    borderColor: Colors.white,
                    borderLength: 40,
                    borderWidth: 5,
                    cutOutBottomOffset: 0,
                    cutOutHeight: 280,
                    cutOutWidth: MediaQuery.of(context).size.width * 0.88,
                    overlayColor: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
