import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'dart:async';
import 'package:flutterapplc/Login.dart';

void main(){
  runApp(MaterialApp(home: LoginPage()));
}

//Future<LCObject> saveLeaving() async {

//  LeanCloud.initialize(
//      'eLAwFuK8k3eIYxh29VlbHu2N-gzGzoHsz', 'G59fl4C1uLIQVR4BIiMjxnM3',
//      server: 'https://elawfuk8.lc-cn-n1-shared.com',
//      queryCache: new LCQueryCache());

//  try {
//    LCUser user = LCUser();
//    user.username = 'Tom';
//    user.password = '123';
//// 设置其他属性的方法跟 LCObject 一样
//    user['realname'] = '张三';
//    await user.signUp();
//  } on LCException catch (e) {
//    print('${e.code} : ${e.message}');
//  }

//    // 登录成功
//    LCUser user = await LCUser.login('Tom', '123');
//  } on LCException catch (e) {
//    // 登录失败（可能是密码错误）
//    print('${e.code} : ${e.message}');
//  }


//  LCUser currentUser = await LCUser.getCurrent();
////  // 构建对象
////  LCObject todo = LCObject("Leave");
////  todo['realName'] = currentUser['realName'];
////  todo['user'] = currentUser;
////  todo['duration'] = 1;
////
////// 将对象保存到云端
////  await todo.save();
//  return todo;
//}


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



