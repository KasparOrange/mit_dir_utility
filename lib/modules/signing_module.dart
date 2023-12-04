// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mit_dir_utility/models/user_model.dart';
// import 'package:mit_dir_utility/services/database_service.dart';
// import 'package:mit_dir_utility/services/logging_service.dart';
// import 'package:signature/signature.dart';

// class SigningModule extends StatefulWidget {
//   const SigningModule({super.key, required this.user, required this.update, required this.controller});

//   final UserModel user;
//   final Function update;
//   final SignatureController controller;

//   @override
//   State<SigningModule> createState() => _SigningModuleState();
// }

// class _SigningModuleState extends State<SigningModule> {


//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Flexible(
//           flex: 3,
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return Signature(
//                 controller: _signatureController,
//                 backgroundColor: Colors.white,
//                 // Set the size based on the constraints provided by LayoutBuilder
//                 height: constraints.maxHeight,
//                 width: constraints.maxWidth,
//               );
//             },
//           ),
//         ),
//         Flexible(
//           flex: 1,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_signatureController.isEmpty) return;
//                   final signaturePNG = await _signatureController.toPngBytes();

//                   final donwloadURL = await DatabaseService.uploadSignature(
//                     widget.user,
//                     signaturePNG!,
//                   );

//                   widget.update();

//                   if (!mounted) return;
//                   GoRouter.of(context).pop();
//                 },
//                 child: const Text('Save'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   _signatureController.clear();
//                 },
//                 child: const Text('Clear'),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
