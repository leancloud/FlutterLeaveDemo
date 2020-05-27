import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'Common/Global.dart';

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
    return '还未选择';
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
    try {
      LCUser user = await LCUser.login('Tom', '123');
      showToast('请假成功');
    } on LCException catch (e) {
      print('${e.code} : ${e.message}');
      showToast('请假失败：${e.code} : ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        margin: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
