import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class QuillResizingImageModule extends StatefulWidget {
  const QuillResizingImageModule({super.key, required this.quillEditorController});
  final QuillEditorController quillEditorController;

  @override
  State<QuillResizingImageModule> createState() => _QuillResizingImageModuleState();
}

class _QuillResizingImageModuleState extends State<QuillResizingImageModule> {
  // State

  late final TextEditingController _heightInputFieldController;
  String? imageHeight;

  void _onTextChanged(String text) {
    debugPrint(text);
  }

  @override
  void initState() {
    super.initState();
    widget.quillEditorController.onTextChanged(_onTextChanged);
    _heightInputFieldController = TextEditingController(text: imageHeight ?? '000');
  }

  @override
  void dispose() {
    _heightInputFieldController.dispose();
    super.dispose();
  }

  _resizeImage() async {
    String selectedHtmlText = await widget.quillEditorController.getSelectedHtmlText();

    if (selectedHtmlText.startsWith('<p><img')) {
      debugPrint('Its an Image!');

      // var selectionIndex = await controller.getSelectionRange().then(
      //       (value) => value.index,
      //     );

      String completeHtmlText = await widget.quillEditorController.getText();

      var selectionIndex = completeHtmlText.indexOf(selectedHtmlText.substring(3));

      if (selectionIndex == -1) {
        debugPrint('selectedHtmlText');
        debugPrint(selectedHtmlText.substring(3).substring(0, 100));
        debugPrint('completeHtmlText');
        debugPrint(completeHtmlText.substring(0, 100));
        debugPrint('Selectionindex was: $selectionIndex');

        return;
      }
      debugPrint('Selectionindex is: $selectionIndex');

      String s1 = completeHtmlText.substring(0, selectionIndex + 5);
      String s2 = completeHtmlText.substring(selectionIndex);

      String newHtml = '$s1 height="${_heightInputFieldController.text}" $s2';

      widget.quillEditorController.setText(newHtml);
    } else {
      debugPrint('No Image selecetd!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 30,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      margin: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Height: '),
            Flexible(
              child: Center(
                child: TextField(
                  maxLength: 3,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _heightInputFieldController,
                  decoration: const InputDecoration(
                    suffixText: 'px',
                    // counter: null,
                    counterText: ''

                    ),
                ),
              ),
            ),
            Material(
              color: Colors.amber,
              child: InkWell(
                  onTap: _resizeImage,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Resize Image',
                        overflow: TextOverflow.clip,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
            ),
            // TODO: Add maxSize button.
          ],
        ),
    );
  }
}
