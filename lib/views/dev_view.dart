import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mit_dir_utility/interfaces.dart';
import 'package:mit_dir_utility/modules/color_palette_module.dart';
import 'package:mit_dir_utility/services/runtime_logging_service.dart';
import 'package:provider/provider.dart';

class DevView extends StatelessWidget implements SidebarInterface {
  const DevView({super.key});

  @override
  List<Widget> get sidebarWidgets {
    return [
      const SizedBox(width: 0),
    ];
  }

  // final List<String> logs = [];
  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Provider.of<SidebarState>(context, listen: false).widgets = sidebarWidgets;
    // });

    return Column(
      children: [
        const SizedBox(height: 50,
        child: ColorPaletteModule()),
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
                child: const Text('AddTestLog')),
          ],
        ),
      ],
    );
  }

  @override
  List<Widget> get sidebarActions {
    return [const Text("RuntimeLoggingView Sidebar")];
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
