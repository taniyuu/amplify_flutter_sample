import 'package:amplify_analytics_pinpoint/amplify_analytics_pinpoint.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:amplify_flutter_sample/amplifyconfiguration.dart';
import 'package:amplify_flutter_sample/ui/controllers/process_initializer.dart';
import 'package:amplify_flutter_sample/ui/pages/login_page.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(MyApp());
  await _configureAmplify();
}

Future<void> _configureAmplify() async {
  // Instantiate Amplify
  Amplify amplifyInstance = Amplify();
  // Add Pinpoint and Cognito Plugins
  AmplifyAnalyticsPinpoint analyticsPlugin = AmplifyAnalyticsPinpoint();
  AmplifyAuthCognito authPlugin = AmplifyAuthCognito();
  amplifyInstance.addPlugin(authPlugins: [authPlugin]);
  amplifyInstance.addPlugin(analyticsPlugins: [analyticsPlugin]);

  // Once Plugins are added, configure Amplify
  await amplifyInstance.configure(amplifyconfig);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
          future: Initializer.getInitialWidget(),
          builder: (ctx, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return LoginPage();
            } else {
              return snapshot.data;
            }
          }),
    );
  }
}
