import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:go_router/go_router.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/dialog_module.dart';
import 'package:mit_dir_utility/modules/loading_module.dart';
import 'package:mit_dir_utility/modules/user_editor_module.dart';
import 'package:mit_dir_utility/modules/user_list_tile_module.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/filesystem_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
import 'package:mit_dir_utility/services/theme_service.dart';

class CSVImporterModule extends StatelessWidget {
  const CSVImporterModule({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return const CSVImportDialog();
              });
        },
        child: const Text("Import CSV"));
  }
}

class CSVImportDialog extends StatefulWidget {
  const CSVImportDialog({
    super.key,
    this.width = 1000,
    this.height = 600,
  });

  final double width;
  final double height;

  @override
  State<CSVImportDialog> createState() => _CSVImportDialogState();
}

class _CSVImportDialogState extends State<CSVImportDialog> {
  List<List<dynamic>>? tableData;
  bool isLoading = false;
  String message = 'Pick a CSV file to import';


  void _showImportConfirmationDialog() => showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              icon: Icon(Icons.warning, color: ThemeService.colors.error),
              content: const Text('Are you sure you want to import all this data?'),
              actionsAlignment: MainAxisAlignment.spaceAround,
              actions: [
                TextButton(
                  onPressed: () => GoRouter.of(context).pop(),
                  child: Text('NO', style: TextStyle(color: ThemeService.colors.errorLight)),
                ),
                TextButton(
                  onPressed: () async {
                    _importData();

                    if (!mounted) return;

                    GoRouter.of(context).pop();
                  },
                  child: Text('YES', style: TextStyle(color: ThemeService.colors.okLight)),
                )
              ]);
        },
      );

  late Map<String, void Function()> actions = {
    'Pick CSV File': () {
      pickCSVFile();
    },
    'Close': () {
      GoRouter.of(context).pop();
    }
  };

  _importData() async {
    setState(() => isLoading = true);
    try {
      for (var row in tableData!.sublist(1)) {
        final stringList = (row.map((e) => e.toString()).toList());

        await DatabaseService.createUser(UserModel.fromList(list: stringList));
      }
      if (!mounted) return;

      GoRouter.of(context).pop();
    } catch (error) {
      log(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> pickCSVFile() async {
    setState(() {
      isLoading = true;
    });

    try {
      var result = await FilesystemService.pickCSVFile(); // Replace with your async function

      if (!mounted) return;

      if (result == null) {
        setState(() {
          message = 'No file picked';
        });
        return;
      }
      setState(() {
        tableData = result;
        actions['Import Data'] = _showImportConfirmationDialog;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        message = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      log('Finished picking CSV file. Message: $message. Table data: $tableData.', long: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.black), borderRadius: BorderRadius.circular(5)),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Column(
          children: [
            Expanded(
                flex: 4,
                child: SizedBox.expand(
                  child: Builder(builder: (context) {
                    if (isLoading) {
                      return const LoadingModule.fullScreen();
                    }

                    if (tableData != null) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StickyHeadersTable(
                          headers: tableData![0].map((cell) => cell.toString()).toList(),
                          tableData: tableData!.sublist(1),
                        ),
                      );
                    }

                    return Center(
                        child: Text(
                      message,
                      style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ));
                  }),
                )),
            Expanded(
              flex: 1,
              child: Row(
                  children: actions.entries
                      .map((e) => Expanded(
                            child: SizedBox.expand(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  // style: TextButton.styleFrom(
                                  //     backgroundColor: Colors.),
                                  onPressed: e.value,
                                  child: Text(
                                    e.key,
                                    style:
                                        const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList()),
            )
          ],
        ),
      ),
    );
  }
}

class StickyHeadersTable extends StatelessWidget {
  const StickyHeadersTable({super.key, required this.headers, required this.tableData});

  final List<String> headers;
  final List<List<dynamic>> tableData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: headers
              .map((header) => Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: ThemeService.colors.oldPrimaryColor,
                      child: Text(
                        header,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ))
              .toList(),
        ),
        const ColoredBox(color: Colors.black, child: SizedBox(height: 1)),
        Expanded(
          child: ListView.builder(
            itemCount: tableData.length,
            itemBuilder: (context, index) {
              return Row(
                children: tableData[index]
                    .map((cell) => Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Tooltip(
                                message: cell.toString(),
                                child: Text(
                                  maxLines: 1,
                                  softWrap: false,
                                  cell.toString(),
                                  overflow: TextOverflow.fade,
                                )),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}
