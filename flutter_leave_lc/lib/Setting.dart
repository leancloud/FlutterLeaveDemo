import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'Common/Global.dart';

class SettingPage extends StatefulWidget {
  SettingPage({Key key}) : super(key: key);
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final TextEditingController _controller = new TextEditingController();
// 弹出对话框
  Future<bool> showDeleteConfirmDialog1() async {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("确认保存修改?"),
          actions: <Widget>[
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(), // 关闭对话框
            ),
            FlatButton(
              child: Text("保存"),
              onPressed: () {
                saveWeekly(_controller.text)
                    .then((response) {})
                    .catchError((error) {
                  showToastRed(error);
                });
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
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Container(
      padding: const EdgeInsets.all(10),
      child: ListView(
        // padding: EdgeInsets.symmetric(horizontal: 22.0),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('意见反馈',
                  style: TextStyle(
                    fontSize: 23.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 6.0,
                  )),
            ],
          ),
          Row(
            children: <Widget>[
              new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Container(
                      padding: const EdgeInsets.only(
                          bottom: 8.0, right: 8, left: 10),
                      child: TextField(
                        controller: _controller,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.multiline,
                        maxLines: 20,
                        minLines: 7,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: "反馈内容...",
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
                    new Container(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, right: 8, left: 10),
                        child: RaisedButton(
                          child: Text('保存'),
                          onPressed: () async {
                            //弹出对话框并等待其关闭
                            bool delete = await showDeleteConfirmDialog1();
                            if (delete == false) {
                              print("取消");
                            } else {
                              print("保存");
                            }
                          },
                        )),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

Future<LCObject> saveWeekly(String text) async {
  LCUser user = await LCUser.getCurrent();
  LCObject obj = LCObject('Feedback');
  obj['content'] = text;
  obj['user'] = user;
  LCObject object = await obj.save();
  showToastGreen('提交成功');
  return object;
}
