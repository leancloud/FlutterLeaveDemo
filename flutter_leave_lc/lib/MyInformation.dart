import 'package:flutter/material.dart';
import 'package:flutterapplc/Login.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Common/Global.dart';



//TODO 手机号、邮箱、RealName
class MyInformationPage extends StatefulWidget {
  MyInformationPage({Key key}) : super(key: key);
  _MyInformationPageState createState() => _MyInformationPageState();
}

class _MyInformationPageState extends State<MyInformationPage> {
  final TextEditingController _controllerRealName = new TextEditingController();
  final TextEditingController _controllerPhone = new TextEditingController();

  String _name = '暂无';

  @override
  void initState() {
    super.initState();
    getUserProfile();
  }

  getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    this._name = prefs.getString('username');

    getUserData().then((response) {
      String realName = response['realName'];
      String phone = response['mobilePhoneNumber'];

      if (realName != null && realName != '') {
        _controllerRealName.text = realName;
      } else {
        _controllerRealName.text = '未设置';
      }
      if (phone != null && phone != '') {
        _controllerPhone.text = phone;
      } else {
        _controllerPhone.text = '未设置';
      }
    }).catchError((error) {
      showToastRed(error.toString());
      print(error.toString());
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: MediaQuery.removePadding(
      context: context,
      //移除抽屉菜单顶部默认留白
      removeTop: true,
      child: new Container(
        margin: const EdgeInsets.fromLTRB(0, 50, 10, 0),
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0, bottom: 30),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipOval(
                      child: Icon(
                        Icons.face,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Text(
                    this._name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            new Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 10, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('姓名  '),
                    Expanded(
                      child: TextField(
                        controller: _controllerRealName,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: const InputDecoration(
                          hintText: '',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          isDense: true,
                          border: const OutlineInputBorder(
                            gapPadding: 10,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                              width: 2,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            new Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 10, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('电话  '),
                    Expanded(
                      child: TextField(
                        controller: _controllerPhone,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                        minLines: 1,
                        decoration: const InputDecoration(
                          hintText: '',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          isDense: true,
                          border: const OutlineInputBorder(
                            gapPadding: 10,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
                            borderSide: BorderSide(
                              width: 2,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            new Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    highlightColor: Colors.blue,
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    child: Text("保存"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                      if (this._controllerRealName.text == null ||
                          this._controllerRealName.text == '') {
                        showToastRed('姓名未填写');
                        return;
                      }
                      if (this._controllerPhone.text == null ||
                          this._controllerPhone.text == '') {
                        showToastRed('手机号未填写！');
                        return;
                      }
                      CommonUtil.showLoadingDialog(context); //发起请求前弹出loading

                      updateProfile(this._controllerRealName.text,
                              this._controllerPhone.text)
                          .then((response) {
                        showToastGreen('保存成功!');
                      }).catchError((error) {
                        showToastRed(error);
                      });
                      Navigator.pop(context); //销毁 loading
                    },
                  )
                ],
              ),
            ),
            new Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    highlightColor: Colors.blue,
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    child: Text("退出登录"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                      showConfirmDialog();
                    },
                  )
                ],
              ),
            ),
            new Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 10, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    color: Colors.blue,
                    highlightColor: Colors.blue,
                    colorBrightness: Brightness.dark,
                    splashColor: Colors.grey,
                    child: Text("注销账号"),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    onPressed: () {
                      showConfirmDialog_cancel();
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
  Future<bool> showConfirmDialog_cancel() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("确认注销账号吗"),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            FlatButton(
              child: Text("确认"),
              onPressed: () {
                //Client close；
                //关闭对话框并返回true
                clientCancel();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<bool> showConfirmDialog() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("确认退出登录"),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            FlatButton(
              child: Text("确认"),
              onPressed: () {
                //Client close；
                //关闭对话框并返回true
                clientClose();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  //退出
  Future clientCancel() async {
    CommonUtil.showLoadingDialog(context); //发起请求前弹出loading

    cancel().then((value) {
      Navigator.pop(context); //销毁 loading
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(builder: (context) => LoginPage()),
              (_) => false);
    }).catchError((error) {
      showToastRed(error.message);
      Navigator.pop(context); //销毁 loading
    });
  }
//退出
  Future clientClose() async {
    CommonUtil.showLoadingDialog(context); //发起请求前弹出loading
    close().then((value) {
    Navigator.pop(context); //销毁 loading
    Navigator.pushAndRemoveUntil(
    context,
    new MaterialPageRoute(builder: (context) => LoginPage()),
    (_) => false);
    }).catchError((error) {
    showToastRed(error.message);
    Navigator.pop(context); //销毁 loading
    });
  }
  Future close() async {
    LCUser user = await LCUser.getCurrent();
    if (user != null) {
      await LCUser.logout();
    } else {
      showToastRed('有 BUG，重启一下试试。。。');
    }
  }
  Future cancel() async {
    LCUser user = await LCUser.getCurrent();
    if (user != null) {
      await user.delete();
    } else {
      showToastRed('有 BUG，重启一下试试。。。');
    }
  }
  Future updateProfile(String name, String phoneNumber) async {
    LCUser user = await LCUser.getCurrent();
    user['mobilePhoneNumber'] = phoneNumber;
    user['realName'] = name;
    await user.save();
  }

  Future<dynamic> getUserData() async {

    LCUser user = await LCUser.getCurrent();
    dynamic currentUser;
    try {
      Map<String, dynamic> userMap = await LCCloud.run('queryUsers');
      List<dynamic> users = userMap['result'];

      for (var obj in users) {
        if (obj['objectId'] == user.objectId) {
          currentUser = obj;
          return currentUser;
        }
      }
    } on LCException catch (e) {
      showToastRed(e.message);
    }

    return user;
  }

}
