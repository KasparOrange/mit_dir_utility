import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:mit_dir_utility/modules/rive_test_animation.dart';
import 'package:mit_dir_utility/services/runtime_logging_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog_platform_interface.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

class RuntimeLoggingView extends StatefulWidget {
  const RuntimeLoggingView({super.key});

  @override
  State<RuntimeLoggingView> createState() => _RuntimeLoggingViewState();
}

class _RuntimeLoggingViewState extends State<RuntimeLoggingView> {
  // final List<String> logs = [];

  // @override
  // void initState() {
  //   super.initState();
  //   // Configure logger
  //   Logger.level = Level.verbose;
  //   final logger = Logger(
  //     printer: SimplePrinter(),
  //     output: ExampleOutput((output) {
  //       setState(() {
  //         logs.add(output);
  //       });
  //     }),
  //   );

  //   // Log some data
  //   // logger.d("Hello, logs!");
  //   // logger.e("This is an error");
  //   // logger.i("This is informational");
  // }

  @override
  Widget build(BuildContext context) {
    var logger = Provider.of<RuntimeLoggingService>(context);

    return Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.expand(height: MediaQuery.of(context).size.height * 0.5),
          child: Consumer<RuntimeLoggingService>(
              builder: (context, loggingSerivce, child) => ListView(
                      children: loggingSerivce.logList.entries.map((entry) {
                    return ListTile(
                      shape: const Border.symmetric(horizontal: BorderSide()),
                      subtitle: Text('${entry.key.hour}:${entry.key.minute}:${entry.key.second}'),
                      title: Text(entry.value),
                    );
                  }).toList())),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () async {
                  FilePickerResult? result = await FilePickerWeb.platform.pickFiles();

                  if (result != null) {
                    logger.appendLog('File with name: ${result.files[0].name} got picked.');

                    final csvAsString = String.fromCharCodes(result.files[0].bytes!);

                    final rows = const CsvToListConverter().convert(csvAsString);

                    for (var element in rows) {
                      if (rows[0] == element) continue;
                      logger.appendLog('Vorname: ${element[0]} Nachname: ${element[1]}');
                      await Future.delayed(const Duration(milliseconds: 100));
                      print('Vorname: ${element[0]} Nachname: ${element[1]}');
                    }
                  } else {
                    logger.appendLog('User canceled the picker');
                  }
                },
                child: Text('Pick File')),
            ElevatedButton(
                onPressed: () {
                  Provider.of<RuntimeLoggingService>(context, listen: false).appendLog('Test');
                },
                child: Text('AddTestLog')),
            ElevatedButton(
                onPressed: () async {
                  // QRCodeDartScanView(
                  //   typeScan: TypeScan.takePicture,
                  //   onCapture: (result) {
                  //     Provider.of<RuntimeLoggingService>(context, listen: false).appendLog(result.text);
                  //   },
                  // );

                  QrBarCodeScannerDialog().getScannedQrBarCode(
                      context: context,
                      onCode: (value) {
                        Provider.of<RuntimeLoggingService>(context, listen: false)
                            .appendLog('Test');
                      });

                  await Future.delayed(const Duration(seconds: 10));

                  GoRouter.of(context).pop();
                },
                child: Text('Scan QR Code'))
          ],
        ),
          Expanded(child: const RiveTestAnimation.fullScreen())
      ],
    );
  }
}

class ExampleOutput extends LogOutput {
  final Function(String) onOutput;

  ExampleOutput(this.onOutput);

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      onOutput(line);
    }
  }
}
