import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/dialog_module.dart';
import 'package:mit_dir_utility/services/database_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
import 'package:mit_dir_utility/services/theme_service.dart';
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
                GoRouter.of(context).pop();
              },
              'Delete': () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          icon: Icon(Icons.warning, color: ThemeService.colors.error),
                          content: const Text('Are you sure you want to delete this signature?'),
                          actionsAlignment: MainAxisAlignment.spaceAround,
                          actions: [
                            TextButton(
                              onPressed: () => GoRouter.of(context).pop(),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await DatabaseService.deleteSignature(widget.user);

                                setState(() {});

                                if (!mounted) return;

                                GoRouter.of(context).pop();
                                GoRouter.of(context).pop();
                              },
                              child: const Text('Delete'),
                            )
                          ]);
                    },
                  ),
            },
          );
        });
  }

  _takeSignatureDialoge(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return DialogModule(
              width: _dialogWidth,
              height: _dialogHeight,
              content: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LayoutBuilder(builder: (context, constraints) {
                  return Signature(
                    controller: _signatureController,
                    backgroundColor: ThemeService.colors.linen,
                    // Set the size based on the constraints provided by LayoutBuilder
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                  );
                }),
              ),
              actions: {
                'Close': () {
                  GoRouter.of(context).pop();
                },
                'Save': () async {
                  if (_signatureController.isEmpty) return;

                  final signatureAsPngBytes = await _signatureController.toPngBytes();

                  await DatabaseService.uploadSignature(widget.user, signatureAsPngBytes!);
                  setState(() {});

                  if (!mounted) return;

                  GoRouter.of(context).pop();
                }
              });
        });
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
              backgroundColor:
                  snapshot.data! ? ThemeService.colors.okLight : ThemeService.colors.errorLight,
              side: const BorderSide(),
            ),
            onPressed: snapshot.data!
                ? () => _showSignatureDialog(context)
                : () => _takeSignatureDialoge(context),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(image: AssetImage('icons/icons8-signature-50.png')),
          ),

            // Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: DecorationImage
            //   AssetImage('icons/icons8-signature-50.png'),
            // ),
          );
        });
  }
}
