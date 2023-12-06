import 'package:flutter/material.dart';
import 'package:mit_dir_utility/globals.dart';

class DialogModule extends StatelessWidget {
  const DialogModule(
      {super.key,
      this.width = 1000,
      this.height = 600,
      required this.content,
      this.actions = const {}});

  final double width;
  final double height;
  final Widget content;
  final Map<String, void Function()> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(5)),
      
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: SizedBox.expand(child: content),
            ),
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
                                  child: Text(e.key,
                                  style: const TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold
                                  ),
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
