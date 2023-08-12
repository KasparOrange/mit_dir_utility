import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mit_dir_utility/services/runtime_logging_service.dart';
import 'package:provider/provider.dart';

class SignatureListEntryModule extends StatelessWidget {
  const SignatureListEntryModule({super.key, required this.signatureExists});
  final bool signatureExists;

  @override
  Widget build(BuildContext context) {
    final runtimeLoggingService = Provider.of<RuntimeLoggingService>(context);
    return InkWell(
      splashFactory: InkSplash.splashFactory,
      onTap: () {
        runtimeLoggingService.appendLog('Pressed InkWell');
      },
      child: Ink(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: signatureExists ? Colors.green[900] : Colors.red[900],
            border: Border.all(width: 1.5),
            borderRadius: BorderRadius.circular(5)),
             
        child: const FittedBox(child: Center(child: Icon(Icons.no_sim_outlined, color: Colors.black,))),
      ),
    );
  }
}
