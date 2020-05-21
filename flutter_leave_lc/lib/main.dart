import 'package:flutter/material.dart';
import 'package:flutterapplc/Login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
void main(){
  runApp(new MyApp());
}
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

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//
//    new Text('data');
//    return new MaterialApp(
//      title: 'Fetch Data Example',
//      theme: new ThemeData(
//        primarySwatch: Colors.blue,
//      ),
//      home: new Scaffold(
//        appBar: new AppBar(
//          title: new Text('登录'),
//        ),
//        body: new Center(
//          child: new FutureBuilder<LCObject>(
//            future: saveLeaving(),
//            builder: (context, snapshot) {
//              if (snapshot.hasData) {
//                return new Text(snapshot.data.objectId);
//              } else if (snapshot.hasError) {
//                return new Text('${snapshot.error}');
//              }
//              return new CircularProgressIndicator();
//            },
//          ),
//        ),
//      ),
//    );
//  }
//}



