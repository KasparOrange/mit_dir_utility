import 'package:flutter/material.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/modules/signing_module.dart';

class SignatureButtonModule extends StatelessWidget {
  const SignatureButtonModule({super.key, required this.isSigned});

  final bool isSigned;
  // final UserModel user;

  _showSignatureDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Signature'),
          content: SizedBox(
            height: 300,
            width: 300,
            child: Image.asset('icons/icons8-signature-50.png'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  _takeSignatureDialoge(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: const SizedBox(
            height: 600,
            width: 1000,
            child: SigningModule(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSigned ? Colors.green : Colors.red,
      ),
      onPressed:
          isSigned ? () => _showSignatureDialog(context) : () => _takeSignatureDialoge(context),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset('icons/icons8-signature-50.png'),
      ),
    );
  }
}
