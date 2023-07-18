import 'dart:developer' as dev;
import 'dart:math';
import 'dart:typed_data';
import 'dart:js' as js;

import 'package:clipboard/clipboard.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:signature/signature.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 4,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
    onDrawStart: () {},
    onDrawEnd: () {},
  );
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _selectionTextEditingController = TextEditingController();
  final FocusNode _selectionFocusNode = FocusNode();
  final GlobalKey _buttonKey = GlobalKey();

  bool loading = false;
  String? name;

  @override
  void initState() {
    _signatureController.addListener(() {
      setState(() {});
    });
    _selectionTextEditingController.addListener(() {
      final text = _selectionTextEditingController.text;
      _selectionTextEditingController.value = _selectionTextEditingController.value.copyWith(
        text: text,
        selection: TextSelection(baseOffset: 0, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
    super.initState();
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _textEditingController.dispose();
    _selectionTextEditingController.dispose();
    _selectionFocusNode.dispose();
    super.dispose();
  }

  // Future _fakeLoading() async {
  //   setState(() {
  //     loading = true;
  //   });
  //   return await Future.delayed(const Duration(seconds: 3)).then((_) {
  //     setState(() {
  //       loading = false;
  //     });
  //   });
  // }

  void _clickButtonProgrammatically() async {
    final renderBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;

    // final position = renderBox.localToGlobal(Offset.zero);
    final position =
        Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2);

    GestureBinding.instance.handlePointerEvent(PointerDownEvent(position: position));

    // await Future.delayed(const Duration(milliseconds: 10));

    GestureBinding.instance.handlePointerEvent(PointerUpEvent(position: position));
  }

  void _copyToClipboard(String content) {
    // FlutterClipboard.copy(content);
    js.context.callMethod('copyToClipboardJS', [content]);
    // Pasteboard.writeText(content);
    dev.log('copytoclipboard');
  }

  Future _uploadImageToFBStorage(String name, Uint8List bytes) async {
    final randomNumber = Random().nextInt(9000) + 1000;

    final ref = FirebaseStorage.instance
        .ref()
        .child('images/${name.replaceAll(' ', '_')}_${randomNumber}_signature.png');

    String url = '';

    await Future.wait([
      Future.delayed(const Duration(seconds: 2)),
      ref.putData(bytes).then((_) async {
        await ref.getDownloadURL().then((value) {
          _copyToClipboard(value);
          url = value;
        });
      })
    ]).then((_) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          onVisible: () {
            // _clickButtonProgrammatically();
            // Clipboard.setData(ClipboardData(text: url));
            _copyToClipboard(url);
          },
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          elevation: 50,
          duration: const Duration(days: 1),
          content: Center(
              child: Column(children: [
            Theme(
                data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                        selectionColor: Theme.of(context).colorScheme.tertiary)),
                child: TextField(
                  controller: _selectionTextEditingController..text = url,
                  focusNode: _selectionFocusNode,
                  onTap: () {
                    FocusScope.of(context).requestFocus(_selectionFocusNode);
                  },
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextButton(
                key: _buttonKey,
                onPressed: () {
                  // Clipboard.setData(ClipboardData(text: url));
                  _copyToClipboard(url);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
                child: const Text(
                  'Copy to clipboard',
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ]))));
    });
  }

  Future _showNameDialog() async {
    return await _signatureController.toPngBytes().then((value) {
      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
                child: ConstrainedBox(
                    constraints: BoxConstraints.loose(const Size(1000, 1000)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Expanded(flex: 2, child: FittedBox(child: Image.memory(value!))),
                      Container(
                        color: Theme.of(context).colorScheme.primary,
                        width: 8,
                      ),
                      TextFormField(
                        enableSuggestions: false,
                        decoration: const InputDecoration(hintText: 'Please input your name...'),
                        controller: _textEditingController,
                        textAlign: TextAlign.center,
                        autocorrect: false,
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                        onChanged: (value) => name = value,
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                                fit: FlexFit.tight,
                                child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: TextButton(
                                        child: const Text('UPLOAD'),
                                        onPressed: () async {
                                          if (name == null || name == ''.replaceAll(' ', '')) {
                                            return;
                                          }

                                          _signatureController.clear();
                                          _textEditingController.clear();
                                          setState(() {
                                            loading = true;
                                          });

                                          _uploadImageToFBStorage(name!, value);

                                          Navigator.pop(context);
                                          return;
                                        }))),
                            Flexible(
                              fit: FlexFit.tight,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('BACK')),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ])));
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      var height = MediaQuery.of(context).size.height;
      var width = MediaQuery.of(context).size.width;
      return SpinKitPulse(
        size: height > width ? height : width,
        itemBuilder: (context, index) {
          return Image.asset('assets/images/logo_brown.png');
        },
        duration: const Duration(seconds: 2),
      );
    } else {
      return Stack(children: [
        
        Flex(direction: Axis.vertical, children: [
          Flexible(
              fit: FlexFit.tight,
              flex: 4,
              child: ClipRect(
                child: Signature(
                  controller: _signatureController,
                  backgroundColor: Colors.white,
                ),
              )),
          Container(
            color: Theme.of(context).colorScheme.primary,
            height: 8,
          ),
          Builder(builder: (context) {
            if (_signatureController.isEmpty) {
              return Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(20),
                child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      'Please sign above the line...',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.none),
                    )),
              ));
            }
            return Flexible(
              fit: FlexFit.tight,
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: TextButton(
                          onPressed: _showNameDialog,
                          child:
                              const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Expanded(
                              flex: 2,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Icon(Icons.check),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: FittedBox(
                                    child: Text(
                                  'SAVE',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )))
                          ]))),
                  Container(
                    color: Theme.of(context).colorScheme.primary,
                    width: 8,
                  ),
                  Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: TextButton(
                        child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Expanded(
                            flex: 2,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(Icons.clear),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: FittedBox(
                                  child: Text(
                                'CLEAR',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )))
                        ]),
                        onPressed: () {
                          _signatureController.clear();
                        },
                      )),
                ],
              ),
            );
          })
        ]),
        Align(alignment: Alignment.topLeft, child: const Text('Verision: 0.0.1')),
      ]);
    }
  }
}
