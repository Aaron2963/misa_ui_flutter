import 'package:flutter/material.dart';
import 'package:misa_ui_flutter/controller/auth_controller.dart';
import 'package:misa_ui_flutter/settings/misa_locale.dart';
import 'package:provider/provider.dart';

final _authController = AuthController();

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    final headingStyle = Theme.of(context).textTheme.headlineLarge!.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );
    String? loginName;
    String? password;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 400,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 36.0),
                      child: Text(
                        locale.translate('User Log In'),
                        style: headingStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _LoginFormField(
                      label: 'Account',
                      onSaved: (value) => loginName = value,
                    ),
                    _LoginFormField(
                      label: 'Password',
                      onSaved: (value) => password = value,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _LoginFormButton(
                            label: locale.translate('Log In'),
                            onPressed: () async {
                              final navi = Navigator.of(context);
                              try {
                                if (!_formKey.currentState!.validate()) return;
                                _formKey.currentState!.save();
                                final result = await _authController.login(
                                  loginName!,
                                  password!,
                                );
                                if (result != null) {
                                  throw Exception(result);
                                }
                                navi.pushNamedAndRemoveUntil('/main', (route) => false);
                              } on Exception catch (e) {
                                final message = e.toString();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(locale.translate(message)),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: _LoginFormButton(
                            label: locale.translate('Reset'),
                            color: Colors.grey,
                            onPressed: () {
                              _formKey.currentState!.reset();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginFormButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final MaterialColor color;
  const _LoginFormButton({
    required this.label,
    required this.onPressed,
    this.color = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        backgroundColor: color,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }
}

class _LoginFormField extends StatelessWidget {
  final String label;
  final ValueSetter<String?> onSaved;
  const _LoginFormField({required this.label, required this.onSaved});

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<MisaLocale>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        decoration: InputDecoration(
          label: Text(locale.translate(label)),
          border: const OutlineInputBorder(),
        ),
        obscureText: label == 'Password',
        onSaved: onSaved,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return locale.translate('Required');
          }
          return null;
        },
      ),
    );
  }
}
