import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter_sample/ui/pages/home_page.dart';
import 'package:amplify_flutter_sample/ui/pages/login_page.dart';
import 'package:flutter/material.dart';

class Initializer {
  static Future<Widget> getInitialWidget() async {
    final _authState = await Amplify.Auth.fetchAuthSession(
            options: CognitoSessionOptions(getAWSCredentials: true))
        as CognitoAuthSession;
    if (_authState.isSignedIn) {
      return MyHomePage(idToken: _authState.userPoolTokens.idToken);
    } else {
      return LoginPage();
    }
  }
}
