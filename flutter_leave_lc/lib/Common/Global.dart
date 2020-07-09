import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'ServiceLocator.dart';

String getEmojiString() {
  Runes input = new Runes('（因为某些羞羞的原因\u{1F60A}）');
  String emojiString = String.fromCharCodes(input);
  return emojiString;
}

String getVacationTypeString(int type) {
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

String time2cn(String time) {
  if (time == 'AM') {
    return '上午';
  } else {
    return '下午';
  }
}

int getVacationTypeInt(String type) {
  switch (type) {
    case '病假':
      return 0;
      break;
    case '带薪休假或事假':
      return 1;
      break;
    case '产假':
      return 2;
      break;
    case '产检假':
      return 3;
      break;
    case '婚假':
      return 4;
      break;
    case '陪产假':
      return 5;
      break;
  }
  return 100;
}

bool isSameDay(DateTime day1, DateTime day2) {
  return day1.isAtSameMomentAs(day2);
}

DateTime formatDateForYMD(DateTime day) {
  String newDay = formatDate(day, [yyyy, '-', mm, '-', dd]);
  return DateTime.parse(newDay);
}

bool isWeekend(DateTime someDay) {
  return someDay.weekday == 6 || someDay.weekday == 7;
}

void showToastRed(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 20.0);
}

void showToastGreen(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 20.0);
}

class CommonUtil {
  static Future<Null> showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                  onWillPop: () => new Future.value(false),
                  child: Center(
                    child: new CircularProgressIndicator(),
                  )));
        });
  }
}

class Global {
  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    // 注册服务
    setupLocator();
  }
}

Future saveUserType(String userType) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userType', userType);
}
