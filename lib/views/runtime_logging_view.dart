import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:mit_dir_utility/interfaces.dart';
import 'package:mit_dir_utility/modules/quill_module.dart';
import 'package:mit_dir_utility/modules/rive_test_animation.dart';
import 'package:mit_dir_utility/services/runtime_logging_service.dart';
import 'package:provider/provider.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog_platform_interface.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class RuntimeLoggingView extends StatefulWidget implements SidebarActionsInterface {
  const RuntimeLoggingView({super.key});

  @override
  State<RuntimeLoggingView> createState() => _RuntimeLoggingViewState();

  @override
  List<Widget> get sidebarActions {
    return [const Text("RuntimeLoggingView Sidebar")];
  }
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
                onPressed: () {
                  Provider.of<RuntimeLoggingService>(context, listen: false).appendLog('Test');
                },
                child: Text('AddTestLog')),
          ],
        ),
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
