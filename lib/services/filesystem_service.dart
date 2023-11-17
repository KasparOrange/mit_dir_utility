import 'package:csv/csv.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';

class FilesystemService {
  static pickFile() async {
    FilePickerResult? filePickerResult = await FilePickerWeb.platform.pickFiles();

    if (filePickerResult != null) {
      log('File with name: ${filePickerResult.files[0].name} got picked.');

      final csvAsString = String.fromCharCodes(filePickerResult.files[0].bytes!);

      log('CSV as string is: $csvAsString');

      log('The string is ${csvAsString.length} long.');

      final rows = const CsvToListConverter(eol: '\n')
          .convert(csvAsString); // TODO: Find a way to detect the eol automatically.

      log('The list is ${rows.length} long.');

      for (var i = 0; i < 10; i++) {
        if (i == 0) continue;

        log(rows[i].runtimeType);

        final collumn = rows[i];

        log(collumn.runtimeType);

        log(i);

        final stringList = (rows[i].map((e) => e.toString()).toList());

        log('This collumn has the type of: ${stringList.runtimeType}');
        log('This collumn has the value of: $stringList');

        final user = UserModel.fromList(list: stringList);

        try {
          final firestoreResult = await DatabaseService.createMockUserInFBFireStore(user: user);
          log(firestoreResult!);
        } catch (e) {
          log(e);
        }
      }
    } else {
      log('User canceled the picker');
    }
  }
}
