import 'package:flutter/material.dart';

class QRCodeScannerTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
    
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 4,
                    child: Image.asset('assets/images/cardimage.jpeg'), // Replace with your image path
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle Scan Button tap
                      // Open QR scanner
                    },
                    child: Text('Scan QR Code'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
