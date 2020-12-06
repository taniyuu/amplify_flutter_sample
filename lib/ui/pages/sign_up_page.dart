import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter_sample/ui/pages/confirm_code_page.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  void _signUp() async {
    Map<String, dynamic> userAttributes = {
      "email": emailController.text,
    };
    try {
      SignUpResult res = await Amplify.Auth.signUp(
          username: usernameController.text.trim(),
          password: passwordController.text.trim(),
          options: CognitoSignUpOptions(userAttributes: userAttributes));
      if (res.isSignUpComplete) return Navigator.of(context).pop();
      if (res.nextStep.signUpStep == 'CONFIRM_SIGN_UP_STEP') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return ConfirmCodePage(
                codeDetails: res.nextStep.codeDeliveryDetails,
                username: usernameController.text,
              );
            },
          ),
        );
      } else {
        UnsupportedError(res.nextStep.signUpStep);
      }
    } on AuthError catch (e) {
      e.exceptionList.forEach((element) {
        //print(element.exception);
      });
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('登録エラー'),
            content: Text(e.cause.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            // wrap your Column in Expanded
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Enter your username',
                      labelText: 'Username *',
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock),
                      hintText: 'Enter your password',
                      labelText: 'Password *',
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.email),
                      hintText: 'Enter your email',
                      labelText: 'Email *',
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10.0)),
                  RaisedButton(
                    onPressed: _signUp,
                    child: const Text('Sign Up'),
                  ),
                  //ErrorView(_signUpError, _signUpExceptions)
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
