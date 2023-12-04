import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:signature/signature.dart';

class SigningModule extends StatefulWidget {
  const SigningModule({super.key});

  @override
  State<SigningModule> createState() => _SigningModuleState();
}

class _SigningModuleState extends State<SigningModule> {
  late final SignatureController _signatureController;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 4,
      penColor: Colors.black,
      // exportBackgroundColor: Colors.transparent,
      exportBackgroundColor: Colors.green,
      exportPenColor: Colors.black,
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 3,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Signature(
                controller: _signatureController,
                backgroundColor: Colors.white,
                // Set the size based on the constraints provided by LayoutBuilder
                height: constraints.maxHeight,
                width: constraints.maxWidth,
              );
            },
          ),
        ),
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final signaturePNG = await _signatureController.toPngBytes();

                  if (!mounted) return;

                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Image.memory(signaturePNG!));
                      });
                },
                child: const Text('Save'),
              ),
              ElevatedButton(
                onPressed: () {
                  _signatureController.clear();
                },
                child: const Text('Clear'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
