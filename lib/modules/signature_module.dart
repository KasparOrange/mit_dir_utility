import 'package:flutter/material.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/dialog_module.dart';
import 'package:mit_dir_utility/modules/signing_module.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
import 'package:signature/signature.dart';

class SignatureModule extends StatefulWidget {
  const SignatureModule({super.key, required this.user});

  final UserModel user;

  @override
  State<SignatureModule> createState() => _SignatureModuleState();
}

class _SignatureModuleState extends State<SignatureModule> {
  final double _dialogWidth = 1000;
  final double _dialogHeight = 600;
  late final SignatureController _signatureController;

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 4,
      penColor: Colors.black,
      exportBackgroundColor: Colors.transparent,
      exportPenColor: Colors.black,
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  _showSignatureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return DialogModule(
          width: _dialogWidth,
          height: _dialogHeight,
          content: FutureBuilder(
            future: DatabaseService.downloadSignature(widget.user),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Image.memory(snapshot.data!);
              } else if (snapshot.hasError) {
                log('ERROR while fetching signature: ${snapshot.error!}', long: true);

                return const Icon(Icons.error);
              }
              return const CircularProgressIndicator();
            },
          ),
          actions: {
            'Close': () {
              Navigator.of(context).pop();
            },
            'Delete': () async {
              await DatabaseService.deleteSignature(widget.user);

              setState(() {});

              if (!mounted) return;

              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  _takeSignatureDialoge(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: _dialogHeight,
            width: _dialogWidth,
            child: Column(
              children: [
                // SigningModule(user: widget.user, update: () => setState(() {})),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DatabaseService.doesSignatureExist(widget.user),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError || !snapshot.hasData) {
            log(snapshot.error!, onlyDebug: false, long: true);
            return const Icon(Icons.error);
          }

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: snapshot.data! ? Colors.green : Colors.red,
            ),
            onPressed: snapshot.data!
                ? () => _showSignatureDialog(context)
                : () => _takeSignatureDialoge(context),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('icons/icons8-signature-50.png'),
            ),
          );
        });
  }
}
