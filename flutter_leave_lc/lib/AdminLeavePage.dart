import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:date_format/date_format.dart';
import 'Common/Global.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO：管理员请假、delete 历史记录

class AdminLeavePage extends StatefulWidget {
  AdminLeavePage({Key key}) : super(key: key);
  _AdminLeavePageState createState() => _AdminLeavePageState();
}

enum DateType { startDateType, endDateType }

class _AdminLeavePageState extends State<AdminLeavePage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _dropdownStartTime = 'AM';
  String _dropdownEndTime = 'AM';
  String _leaveType = '带薪休假或事假';
  String _leavePerson = '所有人';
  List<String> _usernameList = ['所有人'];
  bool _isButtonPressed = false;

  final TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _getUsersList();
  }

  String _formatDate(DateTime date, DateType type) {
    if (date != null) {
      return formatDate(date, ['yyyy', '-', 'mm', '-', 'dd']);
    } else if (type == DateType.startDateType) {
      this._startDate = DateTime.now();
      return '还未选择';
    } else {
      this._endDate = DateTime.now();
      return '还未选择';
    }
  }

  //调起日期选择器
  void _showStartDatePicker() async {
    DateTime result = await showDatePicker(
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

  void _showEndDatePicker() async {
    DateTime result = await showDatePicker(
      context: context,
      initialDate: this._endDate, //选中的日期
      firstDate: DateTime(1980), //日期选择器上可选择的最早日期
      lastDate: DateTime(2100),
    );
    //将选中的值传递出来
    setState(() {
      this._endDate = result;
    });
  }

  void _getUsersList() {
    List<String> userList = ['所有人'];
    queryUsers().then((response) {
      if (response.length > 0) {
        for (dynamic user in response) {
          String username = user['username'];
          userList.add(username);
        }
        _usernameList = userList;
        setState(() {});
      }
    }).catchError((error) {
      showToastRed(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        margin: const EdgeInsets.all(10.0),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('请假人： '),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    DropdownButton<String>(
                      value: this._leavePerson,
                      onChanged: (String newValue) {
                        setState(() {
                          this._leavePerson = newValue;
                        });
                      },
                      items: _usernameList
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('开始请假的日期： '),
                InkWell(
                  onTap: this._showStartDatePicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(this._formatDate(
                          this._startDate, DateType.startDateType)),
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
                  onTap: _showEndDatePicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(this
                          ._formatDate(this._endDate, DateType.endDateType)),
                      Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                  textInputAction: TextInputAction.done,
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
                  onPressed: () {
                    if (this._isButtonPressed == false) {
                      this._isButtonPressed = true;

                      if (formatDateForYMD(this._startDate)
                          .isBefore(formatDateForYMD(DateTime.now()))) {
                        showToastRed('起始时间非法！');
                        this._isButtonPressed = false;
                        return;
                      }
                      if (this._startDate == null || this._endDate == null) {
                        showToastRed('起始或终止时间非法！');
                        this._isButtonPressed = false;
                        return;
                      }
                      if (this._endDate.isBefore(this._startDate)) {
                        showToastRed('恢复工作日期需在请假日期之后');
                        this._isButtonPressed = false;
                        return;
                      }
                      if (isSameDay(formatDateForYMD(this._startDate),
                              formatDateForYMD(this._endDate)) &&
                          (this._dropdownStartTime == this._dropdownEndTime)) {
                        showToastRed('起始或终止时间非法！');
                        this._isButtonPressed = false;
                        return;
                      }
                      if(this._leavePerson =='所有人'){
                        showToastRed('未选择请假人！');
                        this._isButtonPressed = false;
                        return;
                      }

                      CommonUtil.showLoadingDialog(context); //发起请求前弹出loading
                      //返回所有 IrregularDays
                      getIrregular(this._startDate, this._endDate)
                          .then((irregulars) {
                        //获取请假时间
                        getDuration(
                                irregulars,
                                getVacationTypeInt(this._leaveType),
                                this._startDate,
                                this._dropdownStartTime,
                                this._endDate,
                                this._dropdownEndTime)
                            .then((duration) {
                          if (duration == null || duration <= 0) {
                            showToastRed('请假天数非法！可能是周末或者节假日，也可能是bug了！');
                            this._isButtonPressed = false;
                            return;
                          }
                          DateTime startDateFinal =
                              formatDateForYMD(this._startDate)
                                  .add(new Duration(hours: 8));
                          DateTime endDateFinal =
                              formatDateForYMD(this._endDate)
                                  .add(new Duration(hours: 8));
                          saveLeave(
                                  duration,
                                  getVacationTypeInt(this._leaveType),
                                  startDateFinal,
                                  this._dropdownStartTime,
                                  endDateFinal,
                                  this._dropdownEndTime,
                                  this._controller.text)
                              .then((response) {
                                sendEmail(response);
                            this._isButtonPressed = false;
                          }).catchError((error) {
                            showToastRed(error);
                            this._isButtonPressed = false;
                          });
                        }).catchError((error) {
                          showToastRed(error);
                          this._isButtonPressed = false;
                        });
                      }).catchError((error) {
                        showToastRed(error);
                        this._isButtonPressed = false;
                      });

                      Navigator.pop(context); //销毁 loading
                    } else {
                      showToastRed('请不要重复提交');
                    }
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
  Future sendEmail(LCObject leave) async {
    LCUser user = await LCUser.getCurrent();
    String userRN = user['realName'];
    String startTime = time2cn(leave['startTime']);
    String endTime = time2cn(leave['endTime']);
    DateTime startDate = leave['startDate'];
    DateTime endDate = leave['endDate'];
    String note = leave['note'];
    if (note == null || note == '') {
      note = getEmojiString();
    }
    String leaveType = getVacationTypeString(leave['type']);
    double duration = leave['duration'];
    String endDateString = formatDate(endDate, ['yyyy', '-', 'mm', '-', 'dd']);
    String startDateString =formatDate(startDate, ['yyyy', '-', 'mm', '-', 'dd']);
    if (userRN == null) {
      userRN = user.username;
    }
    String subject =
        '由管理员$userRN添加：$_leavePerson 从 $startDateString$startTime 到 $endDateString$endTime 请 $duration 天 $leaveType';
    try {
      Map response = await LCCloud.run('sendLeaveEmail', params: {
        'from': '${user.username}@leancloud.rocks',
        'subject': subject,
        'text': note
      });
    } on LCException catch (e) {
      showToastRed(e.message);
    }
  }
  Future<List<LCObject>> getIrregular(
      DateTime startDate, DateTime endDate) async {
    startDate = startDate.add(new Duration(hours: 8));
    endDate = endDate.add(new Duration(hours: 8));

    LCQuery<LCObject> query = LCQuery('Irregular');
    query.whereLessThanOrEqualTo('date', endDate);
    query.whereGreaterThanOrEqualTo('date', startDate);
    query.orderByAscending('date');
    List<LCObject> irregularDays = await query.find();
    return irregularDays;
  }

  Future<List<dynamic>> queryUsers() async {
    List<dynamic> users;
    try {
      Map<String, dynamic> userMap = await LCCloud.run('queryUsers');
      users = userMap['result'];
    } on LCException catch (e) {
      showToastRed(e.message);
    }
    return users;
  }

  Future<LCObject> saveLeave(double duration, int leaveType, DateTime startDate,
      String startTime, DateTime endDate, String endTime, String note) async {
    LCUser user = await LCUser.getCurrent();
    String userRN = user['realName'];
    if (userRN == null) {
      userRN = user.username;
    }
    LCObject leave = LCObject("Leave");
    leave['startTime'] = startTime;
    leave['endTime'] = endTime;
    leave['username'] = _leavePerson;
    leave['startDate'] = startDate;
    leave['type'] = leaveType;
    leave['duration'] = duration;
    leave['endDate'] = endDate;
    //管理员请假不需要 realName
    leave['realName'] = '';
    if (note == null || note == '') {
      leave['note'] = '（由管理员$userRN添加）';
    } else {
      leave['note'] = note;
    }
    LCObject obj = await leave.save();
    showToastGreen('请假成功');
    return obj;
  }

//计算天数
  Future<double> getDuration(
      List<LCObject> irregularDays,
      int type,
      DateTime startDate,
      String startTime,
      DateTime endDate,
      String endTime) async {
    startDate = formatDateForYMD(startDate);
    endDate = formatDateForYMD(endDate);
    double duration = 0;
    duration = endDate.difference(startDate).inDays.toDouble();

    if (type == 2 || type == 3 || type == 4 || type == 5) {
      // 产假/产检/婚假 需要算上周末和法定假日
      if (startDate == endDate) {
        // startTime == 'PM' is meaningless
        if (startTime == 'PM') {
          duration = 0;
        }
        if (endTime == 'PM') {
          duration += 0.5;
        }
      } else {
        if (startTime == 'PM') {
          duration -= 0.5;
        }
        if (endTime == 'PM') {
          duration += 0.5;
        }
      }

      return duration;
    }
    for (DateTime m = startDate;
        m.isBefore(endDate);
        m = m.add(new Duration(days: 1))) {
      // - weekends
      // 0 -> sunday
      // 6 -> saturday
      if (isWeekend(m)) {
        duration = duration - 1;
      }
      // - irregular
      if (irregularDays.length != 0) {
        for (int i = 0; i < irregularDays.length; i++) {
          DateTime dates = irregularDays[i]['date'];
          DateTime date = formatDateForYMD(dates);
          bool holiday = irregularDays[i]['holiday'];
          if (date != null && isSameDay(m, date)) {
            if (!isWeekend(m) && holiday == true) {
              duration = duration - 1;
            } else if (isWeekend(m) && holiday != true) {
              duration = duration + 1;
            }
          }
        }
      }
    }

    bool startinirregular = false;
    bool endinirregular = false;
    if (irregularDays.length != 0) {
      for (int j = 0; j < irregularDays.length; j++) {
        DateTime dates = irregularDays[j]['date'];
        DateTime date = formatDateForYMD(dates);
        bool holiday = irregularDays[j]['holiday'];
        if (isSameDay(startDate, date)) {
          startinirregular = true;
          if (!holiday) {
            if (startTime == 'PM') {
              duration += 0.5;
            } else {
              duration++;
            }
          }
        }

        if (isSameDay(endDate, date)) {
          endinirregular = true;
          if (!holiday) {
            if (endTime == 'PM') {
              duration += 0.5;
            }
          }
        }
      }
    }

    if (!startinirregular) {
      if (!isWeekend(startDate)) {
        if (startTime == 'PM') {
          duration -= 0.5;
        }
      }
    }
    if (!endinirregular) {
      if (endTime == 'PM' && !isWeekend(endDate)) {
        duration += 0.5;
      }
    }
    return duration;
  }
}
