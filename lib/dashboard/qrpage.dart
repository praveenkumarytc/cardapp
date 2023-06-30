import 'dart:io';

import 'package:cardapp/Hive/hive_methods.dart';
import 'package:cardapp/main.dart';
import 'package:cardapp/model/user_model.dart';
import 'package:cardapp/widgets/my_card.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class QRCodeScannerTab extends StatefulWidget {
  const QRCodeScannerTab({Key? key}) : super(key: key);

  @override
  _QRCodeScannerTabState createState() => _QRCodeScannerTabState();
}

class _QRCodeScannerTabState extends State<QRCodeScannerTab> with SingleTickerProviderStateMixin {
  bool _isTapped = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  UserModel? _userModel;
  Future<void> getUserData() async {
    _userModel = await HiveMethods.getUser();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
    getUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _flipCard() {
    setState(() {
      _isTapped = !_isTapped;
      if (_isTapped) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (_userModel == null)
            const Padding(
              padding: EdgeInsets.all(50.0),
              child: CircularProgressIndicator(color: primaryColor),
            )
          else
            Center(
              child: SizedBox(
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: _flipCard,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          final rotateAnimation = Tween<double>(begin: 0, end: 1).animate(animation);
                          return RotationTransition(
                            turns: rotateAnimation,
                            child: child,
                          );
                        },
                        child: _isTapped
                            ? RepaintBoundary(
                                key: _qrKey,
                                child: MyQrCode(userModel: _userModel!),
                              )
                            : RepaintBoundary(
                                key: _globalKey,
                                child: MyCard(
                                  email: _userModel!.email,
                                  name: _userModel!.name,
                                  phone: _userModel!.phone,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ShareButton(onTap: _onSharePressed),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  final GlobalKey _qrKey = GlobalKey();
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _onSharePressed() async {
    RenderRepaintBoundary boundary = _isTapped ? _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary : _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final directory = await getTemporaryDirectory();
    final file = await File('${directory.path}/image.png').create();

    await file.writeAsBytes(pngBytes);
    String message = 'Hello there!';

    Share.shareFiles([
      file.path
    ], text: message, subject: 'Image sharing', sharePositionOrigin: const Rect.fromLTWH(0, 0, 10, 10));
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({super.key, required this.onTap});

  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.black,
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              spreadRadius: -1,
            ),
          ],
        ),
        child: const Icon(
          Icons.share,
          size: 20,
        ),
      ),
    );
  }
}
