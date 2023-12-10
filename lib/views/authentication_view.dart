import 'package:flutter/material.dart';
import 'package:mit_dir_utility/interfaces.dart';
import 'package:mit_dir_utility/services/authentication_service.dart';
import 'package:mit_dir_utility/services/logging_service.dart';
// import 'package:provider/provider.dart';

class AuthView extends StatefulWidget implements SidebarInterface {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();

  @override
  List<Widget> get sidebarWidgets {
    return [const Text("Authview Sidebar")];
  }
}

class _AuthViewState extends State<AuthView> {
  bool showSignIn = true;
  bool loading = false;
  String email = 'ko.fcbu@gmail.com';
  String error = '';
  String password = 'MITDIRORGA!2022';
  final _formStateGK = GlobalKey<FormState>();

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  Widget _buildElevatedButton(AuthenticationService authService) {
    return switch (authService.authViewToShow) {
      AuthViewToShow.ShowRegister => ElevatedButton(
          onPressed: () async {
            if (_formStateGK.currentState!.validate()) {
              dynamic result = await authService.createUserInFBAuthorization(email, password);
              if (result == null) {
                setState(() {
                  error = 'Fehler beim Registrieren';
                });
              }
            }
          },
          child: const Text("Register")),
      AuthViewToShow.ShowSignIn => ElevatedButton(
          onPressed: () async {
            if (_formStateGK.currentState!.validate()) {
              log('Loading: $loading');
              setState(() => loading = true);
              dynamic result =
                  await AuthenticationService.signInWithEmailAndPassword(email, password);
              if (result == null) {
                log('Loading: $loading');
                setState(() {
                  error = 'Damit kann ich dich nicht anmelden';
                  loading = false;
                });
              }
            }
          },
          child: const Text('Sign In')),
      AuthViewToShow.ShowSignOut => ElevatedButton(
          onPressed: () async => await AuthenticationService.signOut(),
          child: const Text('Sign Out')),
    };
  }

  @override
  Widget build(BuildContext context) {
    // final authService = Provider.of<AuthService>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 300),
      child: Form(
          key: _formStateGK,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
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
                height: 20,
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
              const SizedBox(height: 20),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
              ElevatedButton(
                  onPressed: () {
                    AuthenticationService.signInWithEmailAndPassword(email, password);
                  },
                  child: const Text('Sign in'))
            ],
          )),
    );
  }
}
