import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:fluttertoast/fluttertoast.dart';

String getVacationType(int type) {
  //['带薪休假或事假', '病假', '婚假', '产假', '产检假', '陪产假']

  switch (type) {
    case 0:
      return '病假';
      break;
    case 1:
      return '带薪休假或事假';
      break;
    case 2:
      return '产假';
      break;
    case 3:
      return '产检假';
      break;
    case 4:
      return '婚假';
      break;
    case 5:
      return '陪产假';
      break;
  }
  return '错误的假期类型';
}
void showToast (String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 20.0);
}
class Global {
  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    //初始化网络请求相关配置
      LeanCloud.initialize(
          'eLAwFuK8k3eIYxh29VlbHu2N-gzGzoHsz', 'G59fl4C1uLIQVR4BIiMjxnM3',
          server: 'https://elawfuk8.lc-cn-n1-shared.com',
          queryCache: new LCQueryCache());
      print('init');
  }
}
