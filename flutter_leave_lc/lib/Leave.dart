import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

class LeavePage extends StatefulWidget {
  LeavePage({Key key}) : super(key: key);
  _LeavePageState createState() => _LeavePageState();
}

enum DateType { startDateType, endDateType }

class _LeavePageState extends State<LeavePage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _dropdownStartTime = 'AM';
  String _dropdownEndTime = 'AM';
  String _leaveType = '带薪休假或事假';
  final TextEditingController _controller = new TextEditingController();
  //_controller.text 就是请假原因
//  _LeavePageState() {
////    print(this._startDate);
////    print('时间戳: ${this._startDate.millisecondsSinceEpoch}');
////    print(DateTime.fromMillisecondsSinceEpoch(
////        this._startDate.millisecondsSinceEpoch));
//  }

  String _formatDate(DateType type) {
    switch (type) {
      case DateType.startDateType:
        if (this._startDate != null) {
          return formatDate(this._startDate, ['yyyy', '-', 'mm', '-', 'dd']);
        } else {
          this._startDate = DateTime.now();
          return '还未选择';
        }
        break;
      case DateType.endDateType:
        if (this._endDate != null) {
          return formatDate(this._endDate, ['yyyy', '-', 'mm', '-', 'dd']);
        } else {
          this._endDate = DateTime.now();
          return '还未选择';
        }
        break;
    }
  }

  //调起日期选择器
  void _showDatePicker() async {
    // 第二种方式：async+await
    //await的作用是等待异步方法showDatePicker执行完毕之后获取返回值
    var result = await showDatePicker(
      context: context,
      initialDate: this._startDate, //选中的日期
      firstDate: DateTime(1980), //日期选择器上可选择的最早日期
      lastDate: DateTime(2100),
    );
    //将选中的值传递出来
    setState(() {
      this._startDate = result;
    });
  }

  void saveLeaving() async {
  LeanCloud.initialize(
      'eLAwFuK8k3eIYxh29VlbHu2N-gzGzoHsz', 'G59fl4C1uLIQVR4BIiMjxnM3',
      server: 'https://elawfuk8.lc-cn-n1-shared.com',
      queryCache: new LCQueryCache());

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
//
//     登录成功
  try {
    LCUser user = await LCUser.login('Tom', '123');

    Fluttertoast.showToast(
        msg: "请假成功",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 20.0
    );
  } on LCException catch(e){
    print('${e.code} : ${e.message}');
    Fluttertoast.showToast(
        msg: '请假失败：${e.code} : ${e.message}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 20.0
    );
  }

//  LCUser currentUser = await LCUser.getCurrent();
//  // 构建对象
//  LCObject todo = LCObject("Leave");
//
//  todo['duration'] = 1;
//  await todo.save();

// 将对象保存到云端

//  return todo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("请假")),
      body: new Container(
        margin: const EdgeInsets.all(30.0),
        child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('开始请假的日期： '),
                InkWell(
                  onTap: this._showDatePicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(this._formatDate(DateType.startDateType)),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton<String>(
                        value: this._dropdownStartTime,
                        onChanged: (String newValue) {
                          setState(() {
                            this._dropdownStartTime = newValue;
                          });
                        },
                        items: <String>['AM', 'PM']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('恢复工作的日期： '),
                InkWell(
                  onTap: this._showDatePicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(this._formatDate(DateType.endDateType)),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton<String>(
                        value: this._dropdownEndTime,
                        onChanged: (String newValue) {
                          setState(() {
                            this._dropdownEndTime = newValue;
                          });
                        },
                        items: <String>['AM', 'PM']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('类型： '),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: this._leaveType,
                      onChanged: (String newValue) {
                        setState(() {
                          this._leaveType = newValue;
                        });
                      },
                      items: <String>['带薪休假或事假', '病假', '婚假', '产假', '产检假', '陪产假']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('附言：  '),
              Expanded(
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  minLines: 1,
                  decoration: const InputDecoration(
                    hintText: '原因及其他信息',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    isDense: true,
                    border: const OutlineInputBorder(
                      gapPadding: 10,
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(
                        width: 2,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  child: Text("保存"),
                  onPressed: saveLeaving,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
