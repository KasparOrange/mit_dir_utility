import 'package:date_field/date_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mit_dir_utility/models/user_model.dart';
import 'package:mit_dir_utility/services/authentication_service.dart';
import 'package:mit_dir_utility/services/database_service.dart';

class UserEditorModule extends StatefulWidget {
  const UserEditorModule({super.key, required this.user});

  final UserModel user;

  @override
  State<UserEditorModule> createState() => _UserEditorModuleState();
}

class _UserEditorModuleState extends State<UserEditorModule> {
  final decoration = BoxDecoration(
    border: Border.all(width: 4),
    shape: BoxShape.rectangle,
    borderRadius: const BorderRadius.all(Radius.circular(5)),
  );

  late final UserModel user = widget.user;

  late final _formFieldDateOfBirth = DateTimeFormField(
    initialValue: user.dateOfBirth,
    decoration:
        const InputDecoration(labelText: "Date of Birth", prefixIcon: Icon(Icons.date_range)),
    mode: DateTimeFieldPickerMode.date,
    initialEntryMode: DatePickerEntryMode.input,
    initialDate: user.dateOfBirth,
    onDateSelected: (value) {
      setState(() {
        user.dateOfBirth = value;
      });
    },
  );

  late final _formFieldEmail = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: user.email,
      decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email_outlined)),
      validator: (value) => AuthenticationService.validateEmail(value),
      onChanged: (value) {
        setState(() => user.email = value);
      });

  late final _formFieldFirstName = SizedBox(
    width: 400,
    child: TextFormField(
        textCapitalization: TextCapitalization.words,
        initialValue: user.firstName,
        decoration:
            const InputDecoration(labelText: "First Name", prefixIcon: Icon(Icons.person_add)),
        onChanged: (value) {
          setState(() => user.firstName = value);
        }),
  );

  late final _formFieldLastName = SizedBox(
    width: 400,
    child: TextFormField(
        textCapitalization: TextCapitalization.words,
        initialValue: user.lastName,
        decoration:
            const InputDecoration(labelText: "Last Name", prefixIcon: Icon(Icons.person_add_alt_1)),
        onChanged: (value) {
          setState(() => user.lastName = value);
        }),
  );

  late final _fromFieldPhone = TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: user.phone,
      decoration: const InputDecoration(labelText: "Phone", prefixIcon: Icon(Icons.phone)),
      // validator: (value) => AuthenticationService.validateEmail(value), //TODO: Make validator for Phone.
      onChanged: (value) {
        setState(() => user.phone = value);
      });

  final _userEditorFormStateGK = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: const EdgeInsets.all(50),
        width: 1000,
        height: 1000,
        decoration: decoration,
        child: Form(
            key: _userEditorFormStateGK,
            child: Column(
              children: <Widget>[
                Row(
                  children: [_formFieldFirstName, _formFieldLastName],
                ),
                const SizedBox(height: 20),
                _formFieldEmail,
                const SizedBox(height: 20),
                _fromFieldPhone,
                const SizedBox(height: 20),

                const SizedBox(height: 20),
                _formFieldDateOfBirth,
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                          DatabaseService.createPersonInFBFireStore(user: user);
                        },
                        child: const Text('Save')),
                    ElevatedButton(
                        onPressed: () {
                          GoRouter.of(context).pop();
                        },
                        child: const Text('Back')),
                  ],
                ),
                // Text(
                //   // error,
                //   'Error Placeholder',
                //   style: const TextStyle(color: Colors.red, fontSize: 14),
                // )
              ],
            )),
      ),
    );
  }
}
