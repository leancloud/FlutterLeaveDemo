import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'Common/Global.dart';
import 'package:date_format/date_format.dart';
import 'package:flutterapplc/Common/ServiceLocator.dart';

import 'Common/TelAndSmsService.dart';

//TODO:云引擎查询用户
class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => new _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final TelAndSmsService _service = locator<TelAndSmsService>();

  Future<bool> showDeleteConfirmDialog1(String num, String name) async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("确认给$name拨打电话？"),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            FlatButton(
              child: Text("确认"),
              onPressed: () {
                _service.call(num);
                //关闭对话框并返回true
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
//        padding: EdgeInsets.all(2.0),
        child: FutureBuilder<List<dynamic>>(
          future: queryUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // 请求已结束
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (snapshot.data == null) {
                return Text("没有数据",
                    style: new TextStyle(
                      color: Colors.grey,
                    ));
              } else {
                return ListView.separated(
                  //添加分割线
                  separatorBuilder: (BuildContext context, int index) {
                    return new Divider(
                      height: 0.8,
                      color: Colors.grey,
                    );
                  },
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data[index];
                    String name;
                    String username = data['username'];
                    String realName = data['realName'];
                    if (realName == null || realName == '') {
                      name = username;
                    } else {
                      name = '$realName ($username)';
                    }
                    String phoneNum = data['mobilePhoneNumber'];
                    if (phoneNum == null || phoneNum == '') {
                      phoneNum = '暂未设置手机号';
                    }
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () => showDeleteConfirmDialog1(phoneNum, name),
                        child: Row(
                          children: <Widget>[
                            new Expanded(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  new Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, right: 8, left: 10),
                                    child: new Text(
                                      name,
                                      style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  new Container(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, right: 8, left: 10),
                                    child: new Text(
                                      phoneNum,
                                      style: new TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            } else {
              // 请求未结束，显示loading
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
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
}
