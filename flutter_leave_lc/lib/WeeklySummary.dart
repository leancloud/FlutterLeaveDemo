import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'Common/Global.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class WeeklySummaryPage extends StatefulWidget {
  @override
  _WeeklySummaryPageState createState() => new _WeeklySummaryPageState();
}

class _WeeklySummaryPageState extends State<WeeklySummaryPage> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
//        padding: EdgeInsets.all(2.0),
        child: FutureBuilder<List<LCObject>>(
          future: retrieveData(),
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
                    LCObject data = snapshot.data[index];
                    LCObject user = data['user'];
                    //周报的 user 指向一个不存在的对象时把这条周报跳过
                    if (user == null) {
                      return new Container(height: 0.0, width: 0.0);
                    }
                    String name;
                    String username = user['username'];
                    String realName = user['realName'];
                    if (realName == null || realName == '') {
                      name = username;
                    } else {
                      name = realName;
                    }
                    String note;
                    if (data['content'] == null || data['content'] == '') {
                      note = '周报内容为空';
                    } else {
                      note = data['content'];
                    }
                    String createdAtString = formatDate(
                        data.createdAt, [yyyy, "-", mm, "-", dd, " "]);

                    return Container(
                      padding: const EdgeInsets.all(10),
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
                                    createdAtString,
                                    style: new TextStyle(
                                      color: Colors.black45,
                                    ),
                                  ),
                                ),
                                new Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, right: 8, left: 10),
                                  child: MarkdownBody(data: note),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
//              separatorBuilder: (context, index) => Divider(height: .0),
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

  Future<List<LCObject>> retrieveData() async {
    LCQuery<LCObject> query = LCQuery('WeeklyPub');
    query.include('user');
    query.orderByDescending('createdAt');
    query.whereGreaterThanOrEqualTo(
        'createdAt', DateTime.parse('2020-06-01 00:00:00Z'));
    query.limit(50);
    List<LCObject> weekly = await query.find();
    return weekly;
  }
}
