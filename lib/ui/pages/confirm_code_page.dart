import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';

class ConfirmCodePage extends StatefulWidget {
  final String username;
  final AuthCodeDeliveryDetails codeDetails;

  ConfirmCodePage({
    Key key,
    @required this.username,
    @required this.codeDetails,
  }) : super(key: key);

  @override
  _ConfirmCodePageState createState() => _ConfirmCodePageState();
}

class _ConfirmCodePageState extends State<ConfirmCodePage> {
  final confirmCodeController = TextEditingController();

  void _confirmCode() async {
    try {
      final res = await Amplify.Auth.confirmSignUp(
          username: widget.username,
          confirmationCode: confirmCodeController.text.trim());
      if (res.isSignUpComplete) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('成功しました'),
              content: Text('トップに戻ります'),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                )
              ],
            );
          },
        );
      }
    } on AuthError catch (e) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ログインエラー'),
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
        title: Text("Confirm"),
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
                  Text('${widget.codeDetails.destination}に確認コードを送信しました。'),
                  TextFormField(
                    controller: confirmCodeController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      hintText: 'Enter confirm code',
                      labelText: 'Code *',
                    ),
                  ),

                  const Padding(padding: EdgeInsets.all(10.0)),
                  RaisedButton(
                    onPressed: _confirmCode,
                    child: const Text('Confirm'),
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
