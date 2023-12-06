import 'package:flutter/material.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/dialog_module.dart';
import 'package:mit_dir_utility/modules/user_editor_module.dart';
import 'package:mit_dir_utility/modules/user_list_tile_module.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/filesystem_service.dart';

class CSVImporterModule extends StatefulWidget {
  const CSVImporterModule({super.key});

  @override
  State<CSVImporterModule> createState() => _CSVImporterModuleState();
}

class _CSVImporterModuleState extends State<CSVImporterModule> {
  late final List<List<dynamic>>? tableData;

  @override
  void initState() {
    super.initState();
  }

  _showImportDialog(BuildContext context, List<List<dynamic>> tableData) {
    showDialog(
        context: context,
        builder: (context) => DialogModule(
                content: StickyHeadersTable(
              headers: tableData[0].map((cell) => cell.toString()).toList(),
              tableData: tableData.sublist(1),
            )));
  }

  _pickCSVFile() async {
    final tableData = await FilesystemService.pickCSVFile();

    if (!mounted) return;

    if (tableData == null) {
      showDialog(
          context: context,
          builder: (context) =>
              const AlertDialog(title: Text('Error'), content: Text('No file selected.')));
      return;
    }

    _showImportDialog(context, tableData);
  }

  final importButton = TextButton(
    onPressed: () async {
      final usersTabel = await FilesystemService.pickCSVFile();

      if (!mounted) return;

      if (usersTabel == null) {
        showDialog(
            context: context,
            builder: (context) =>
                const AlertDialog(title: Text('Error'), content: Text('No file selected.')));
        return;
      }

      showDialog(
          context: context,
          builder: (context) => DialogModule(
                  content: StickyHeadersTable(
                      headers: usersTabel[0].map((cell) => cell.toString()).toList(),
                      tableData: usersTabel.sublist(1)),
                  actions: {
                    'Cancel': () => Navigator.pop(context),
                    // 'Import': () async {
                    //   await DatabaseService.importUsers(users!);
                    //   Navigator.pop(context);
                    // }
                  }));
    },
    child: const Text('Import CSV'),
  );

  @override
  Widget build(BuildContext context) {
    return textButton;
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
                      color: Colors.grey[300],
                      child: Text(header),
                    ),
                  ))
              .toList(),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: tableData.length,
            itemBuilder: (context, index) {
              return Row(
                children: tableData[index]
                    .map((cell) => Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(cell.toString()),
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

  // Expanded(
          //   child: Table(
          //     border: TableBorder.all(),
          //     columnWidths: const <int, TableColumnWidth>{
          //       0: FixedColumnWidth(120.0), // fixed to 120.0 width
          //       1: FlexColumnWidth(),
          //     },
          //     defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          //     children: tableData.map((row) {
          //       return TableRow(
          //         children: row.map((cell) {
          //           return Padding(
          //             padding: EdgeInsets.all(8.0),
          //             child: Text(cell.toString()),
          //           );
          //         }).toList(),
          //       );
          //     }).toList(),
          //   ),
          // ),

// class MapTableWidget extends StatelessWidget {
//   final Map<String, dynamic> data;

//   const MapTableWidget({Key? key, required this.data}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: Table(
//         border: TableBorder.all(),
//         columnWidths: const <int, TableColumnWidth>{
//           0: FixedColumnWidth(120.0), // fixed to 120.0 width
//           1: FlexColumnWidth(),
//         },
//         defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//         children: data.entries.map((entry) {
//           return TableRow(
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(entry.key),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(entry.value),
//               ),
//             ],
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
