import 'package:flutter/material.dart';

class DialogModule extends StatelessWidget {
  const DialogModule(
      {super.key,
      required this.width,
      required this.height,
      required this.content,
      required this.actions});

  final double width;
  final double height;
  final Widget content;
  final Map<String, void Function()> actions;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: [
            Flexible(
              flex: 4,
              child: content,
            ),
            Flexible(
              flex: 1,
              child: Flex(
                direction: Axis.horizontal,
                // mainAxisAlignment: MainAxisAlignment.end,
                children: actions.entries
                    .map((e) => Expanded(
                          child: TextButton(
                            onPressed: e.value,
                            child: Text(e.key),
                          ),
                        ))
                    .toList()
              ),
            )
          ],
        ),
      ),
    );
  }
}
