import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mit_dir_utility/modules/quill_resizing_image_module.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(debugShowCheckedModeBanner: false, home: QuillModule()));
}

class QuillModule extends StatefulWidget {
  const QuillModule({super.key});

  @override
  State<QuillModule> createState() => _QuillModuleState();
}

class _QuillModuleState extends State<QuillModule> {
  ///[controller] create a QuillEditorController to access the editor methods
  late QuillEditorController controller;

  ///[customToolBarList] pass the custom toolbarList to show only selected styles in the editor

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

  final _toolbarColor = Colors.grey.shade200;
  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(
      fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal, fontFamily: 'Roboto');
  final _hintTextStyle =
      const TextStyle(fontSize: 18, color: Colors.black12, fontWeight: FontWeight.normal);

  bool _hasFocus = false;

  Widget _htmlSizeInMBTextWidget =
      const Text('Size: 0.000000MB', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20));

  String _htmlText = '';

  Widget _buildHtmlSizeInMBText(String htmlString) {
    Uint8List bytes = utf8.encode(htmlString) as Uint8List;

    var size = bytes.length / (1024 * 1024);

    var color = Colors.black;

    TextStyle style = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: color);

    if (size >= 0.85) {
      color = Colors.orange;
      debugPrint('Orange');
    }

    if (size >= 0.99) {
      color = Colors.red;
    }

    return Row(
      children: [
        Text('Size: ', style: style),
        Text(size.toStringAsFixed(6), style: style.copyWith(color: color)),
        Text('MB', style: style),
      ],
    );
  }

  Widget _buildImageResizingButton() {
    onPressed() async {
      String selectedHtmlText = await controller.getSelectedHtmlText();

      if (selectedHtmlText.startsWith('<p><img')) {
        debugPrint('Its an Image!');

        // var selectionIndex = await controller.getSelectionRange().then(
        //       (value) => value.index,
        //     );

        String completeHtmlText = await controller.getText();

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

        String newHtml = '$s1 height="100" $s2';

        // controller.replaceText(newHtml);

        controller.setText(newHtml);

        // controller.insertText(text)
      } else {
        debugPrint('No Image selecetd!');
      }
    }

    return Row(
      children: [
        SizedBox(height: 20, width: 100, child: const TextField()),
        TextButton(onPressed: onPressed, child: Text('Resize Image')),
      ],
    );
  }

  late Timer _sizeCountingTimer;

  @override
  void initState() {
    controller = QuillEditorController();

    controller.onTextChanged((text) async {
      // debugPrint('listening to $text');
      // debugPrint(_countHtmlSizeInMB(text).toString());

      // var newHtml = await controller.getText();

      setState(() {
        _htmlSizeInMBTextWidget = _buildHtmlSizeInMBText(text);
        _htmlText = text;
      });
    });
    controller.onEditorLoaded(() {
      debugPrint('Editor Loaded :)');
    });

    // _sizeCountingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
    //   final text = await controller.getText();

    //   debugPrint('Printing HtmlSizeInMB.');

    //   setState(() {
    //     _htmlSizeInMBTextWidget = _buildHtmlSizeInMBText(text);
    //   });
    // });

    super.initState();
  }

  @override
  void dispose() {
    /// please do not forget to dispose the controller
    controller.dispose();
    _sizeCountingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        borderOnForeground: true,
        child: Container(
          // clipBehavior: Clip.hardEdge,
          foregroundDecoration: BoxDecoration(
            border: Border.all(
              color: Colors.amber,
              width: 5,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: ToolBar(
                  // clipBehavior: Clip.hardEdge,
                  toolBarColor: _toolbarColor,
                  padding: const EdgeInsets.all(8),
                  iconSize: 25,
                  iconColor: _toolbarIconColor,
                  activeIconColor: Colors.green,
                  controller: controller,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  direction: Axis.horizontal,
                  customButtons: [
                    Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                          color: _hasFocus ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    InkWell(
                        onTap: () => unFocusEditor(),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.black,
                        )),
                    InkWell(
                        onTap: () async {
                          var selectedText = await controller.getSelectedText();
                          debugPrint('selectedText $selectedText');
                          var selectedHtmlText = await controller.getSelectedHtmlText();
                          debugPrint('selectedHtmlText $selectedHtmlText');
                        },
                        child: const Icon(
                          Icons.add_circle,
                          color: Colors.black,
                        )),
                    _htmlSizeInMBTextWidget,
                    _buildImageResizingButton(),
                    // InkWell(
                    //   onTap: ,
                    // )

                    QuillResizingImageModule(quillEditorController: controller),
                  ],
                ),
              ),
              Expanded(
                child: QuillHtmlEditor(
                  text: "<h1>Hello</h1>This is a quill html editor example 😊",
                  hintText: 'Hint text goes here',
                  controller: controller,
                  isEnabled: true,
                  ensureVisible: false,
                  minHeight: 500,
                  autoFocus: true,
                  textStyle: _editorTextStyle,
                  hintTextStyle: _hintTextStyle,
                  hintTextAlign: TextAlign.start,
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  hintTextPadding: const EdgeInsets.only(left: 20),
                  backgroundColor: _backgroundColor,
                  inputAction: InputAction.newline,
                  onEditingComplete: (s) => debugPrint('Editing completed $s'),
                  loadingBuilder: (context) {
                    return const Center(
                        child: CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.red,
                    ));
                  },
                  onFocusChanged: (focus) {
                    debugPrint('has focus $focus');
                    setState(() {
                      _hasFocus = focus;
                    });
                  },
                  // onTextChanged: (text) => debugPrint('widget text change $text'),
                  onEditorCreated: () {
                    debugPrint('Editor has been loaded');
                    setHtmlText('Testing text on load');
                  },
                  onEditorResized: (height) => debugPrint('Editor resized $height'),
                  onSelectionChanged: (sel) =>
                      debugPrint('index ${sel.index}, range ${sel.length}'),
                ),
              ),
              // HtmlElementView(viewType: viewType),
              ElevatedButton(
                  onPressed: () async {
                    final text = await controller.getText();
                    setState(() {
                      _htmlText = text;
                    });
                  },
                  child: Text('Refresh HTML')),
              Html(data: _htmlText),
            ],
          ),
        ),
      ),
    );
  }

  Widget textButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: _toolbarIconColor,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: _toolbarColor),
          )),
    );
  }

  ///[getHtmlText] to get the html text from editor
  void getHtmlText() async {
    String? htmlText = await controller.getText();
    debugPrint(htmlText);
    debugPrint('Length of the string is: ${htmlText.length.toString()}');
  }

  ///[setHtmlText] to set the html text to editor
  void setHtmlText(String text) async {
    await controller.setText(text);
  }

  ///[insertNetworkImage] to set the html text to editor
  void insertNetworkImage(String url) async {
    await controller.embedImage(url);
  }

  ///[insertVideoURL] to set the video url to editor
  ///this method recognises the inserted url and sanitize to make it embeddable url
  ///eg: converts youtube video to embed video, same for vimeo
  void insertVideoURL(String url) async {
    await controller.embedVideo(url);
  }

  /// to set the html text to editor
  /// if index is not set, it will be inserted at the cursor postion
  void insertHtmlText(String text, {int? index}) async {
    await controller.insertText(text, index: index);
  }

  /// to clear the editor
  void clearEditor() => controller.clear();

  /// to enable/disable the editor
  void enableEditor(bool enable) => controller.enableEditor(enable);

  /// method to un focus editor
  void unFocusEditor() => controller.unFocus();
}
