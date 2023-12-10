import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ffloat_nullsafety/ffloat_nullsafety.dart';
import 'package:mit_dir_utility/services/authentication_service.dart';
import 'package:mit_dir_utility/services/theme_service.dart';
import 'package:provider/provider.dart';

class ProfileModule extends StatefulWidget {
  const ProfileModule({super.key});

  @override
  State<ProfileModule> createState() => _ProfileModuleState();
}

class _ProfileModuleState extends State<ProfileModule> {
  late final FFloatController _floatController;
  late final FocusNode _buttonFocusNode;

  @override
  void initState() {
    super.initState();
    _floatController = FFloatController();
    _buttonFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return FFloat(
      (setter, contentState) => Container(
          decoration: BoxDecoration(
              // color: const Color.fromARGB(255, 139, 98, 20),
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Theme.of(context).colorScheme.secondary),),
          width: 400,
          height: 200,
          child: Consumer<User?>(
            builder: (context, value, child) {
              if (value == null) {
                return const SignInForm();
              } else {
                return const SignOutAndProfile();
              }
            },
          )),
      margin: const EdgeInsets.all(100),
      alignment: FFloatAlignment.bottomRight,
      controller: _floatController,
      color: Colors.transparent,
      igBackground: true,
      onDispose: () => _buttonFocusNode.unfocus(),
      anchor: TextButton(
        focusNode: _buttonFocusNode,
        onPressed: () {
          _buttonFocusNode.requestFocus();
          _floatController.show();
        },
        child: const UsernameOrSignIn(),
      ),
    );
  }
}

class UsernameOrSignIn extends StatelessWidget {
  const UsernameOrSignIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<User?>(
      builder: (BuildContext context, value, Widget? child) {
        if (value == null) {
          return const Text('Sign in', style: TextStyle(fontSize: 20));
        } else {
          return Center(
              child: Text(
            value.displayName ?? value.email ?? "Anonymous",
          ));
        }
      },
    );
  }
}

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  String error = '';
  String email = 'ko.fcbu@gmail.com';
  String password = 'MITDIRORGA!2022';
  final _formStateGK = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Form(
          key: _formStateGK,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                  initialValue: 'ko.fcbu@gmail.com',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                      labelText: "Email", prefixIcon: Icon(Icons.email_outlined)),
                  validator: (value) => AuthenticationService.validateEmail(value),
                  onChanged: (value) {
                    setState(() => email = value);
                  }),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                // autovalidateMode: AutovalidateMode.onUserInteraction,
                initialValue: 'MITDIRORGA!2022',
                decoration: const InputDecoration(
                    labelText: "Password", prefixIcon: Icon(Icons.key_outlined)),
                obscureText: true,
                // validator: (value) => AuthorizationService.validatePassword(value),
                onChanged: (value) {
                  setState(() => password = value);
                },
              ),
              const SizedBox(height: 10),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
              ElevatedButton(
                  onPressed: () {
                    AuthenticationService.signInWithEmailAndPassword(email, password);
                  },
                  child: Text('Sign in'))
            ],
          )),
    );
  }
}

class SignOutAndProfile extends StatelessWidget {
  const SignOutAndProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
            onPressed: () async => await AuthenticationService.signOut(),
            child: const Text('Sign Out')),
        const SizedBox(width: 10),
        ElevatedButton(
            onPressed: () async => await AuthenticationService.signOut(),
            child: const Text('Profile')),
      ],
    );
  }
}
