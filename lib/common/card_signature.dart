import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignaturePage extends StatefulWidget {
  final Function(Uint8List) onSignatureSaved;

  SignaturePage({required this.onSignatureSaved});

  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final GlobalKey<SfSignaturePadState> signatureGlobalKey =
      GlobalKey<SfSignaturePadState>();
  void _clearSignature() {
    signatureGlobalKey.currentState!.clear();
  }

  void _saveSignature() {
    final signatureImage = signatureGlobalKey.currentState!.toImage();
    widget.onSignatureSaved(signatureImage as Uint8List);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Signature Pad'),
      ),
      body: Column(
        children: [
          SfSignaturePad(
            key: signatureGlobalKey,
            backgroundColor: Colors.grey[200],
            strokeColor: Colors.black,
            minimumStrokeWidth: 1.0,
            maximumStrokeWidth: 4.0,
          ),
          ElevatedButton(
            onPressed: _clearSignature,
            child: Text('Clear'),
          ),
          ElevatedButton(
            onPressed: _saveSignature,
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
