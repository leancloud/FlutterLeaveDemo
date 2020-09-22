import 'package:flutter/material.dart';
import 'package:flutterapplc/Login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Common/Global.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale.fromSubtags(languageCode: 'zh'),
        const Locale.fromSubtags(languageCode: 'en'),
      ],
      home:LoginPage(),
      locale: Locale('zh'),
    );
  }
}