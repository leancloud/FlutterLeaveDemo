import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'Common/Global.dart';
import 'package:date_format/date_format.dart';

class TodayLeavesPage extends StatefulWidget {
  @override
  _TodayLeavesPageState createState() => new _TodayLeavesPageState();
}

class _TodayLeavesPageState extends State<TodayLeavesPage> {
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
                    var data = snapshot.data[index];
                    int type = data['type'];
                    String name;
                    String username = data['username'];
                    String realName = data['realName'];
                    if (realName == null || realName == '') {
                      name = username;
                    } else {
                      name = realName;
                    }
                    var duration = data['duration'];
                    String note;
                    if (data['note'] == null || data['note'] == '') {
                      note = getEmojiString();
                    } else {
                      note = data['note'];
                    }
                    DateTime startDate = data['startDate'];
                    String startDateString =
                        formatDate(startDate, [mm, "-", dd, " "]);
                    DateTime endDate = data['endDate'];
                    String endDateString =
                        formatDate(endDate, [mm, "-", dd, " "]);
                    String startTime = data['startTime'];
                    String endTime = data['endTime'];

                    String leaveMessageString =
                        '$startDateString$startTime - $endDateString$endTime';
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: <Widget>[
                          new Expanded(
                            flex: 2,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                new Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, right: 8, left: 10),
                                  child: new Text(
                                    '$name ${getVacationTypeString(type)}',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                new Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, right: 8, left: 10),
                                  child: new Text(
                                    note,
                                    style: new TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                                new Container(
                                  padding:
                                      const EdgeInsets.only(right: 8, left: 10),
                                  child: new Text(
                                    leaveMessageString,
                                    style: new TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          new Expanded(
                            flex: 1,
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                new Container(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, right: 15),
                                  child: new Text(
                                    '${duration.toString()} 天',
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

  Future<List<LCObject>> retrieveData() async {
    DateTime today = formatDateForYMD(DateTime.now());
    DateTime tomorrow = today.add(new Duration(days: 1));
    DateTime todayBeijingTime = today.add(new Duration(hours: 8));

    //第一种情况查询今天在开始截止日期中间
    LCQuery<LCObject> query1 = LCQuery('Leave');
    query1.whereGreaterThan('endDate', tomorrow);
    query1.whereLessThan('startDate', today);

    //第二种：截止日期是今天下午
    LCQuery<LCObject> query2 = LCQuery('Leave');
    query2.whereEqualTo('endDate', todayBeijingTime);
    query2.whereEqualTo('endTime', 'PM');

    //第三种：开始日期是今天（上午或下午）
    LCQuery<LCObject> query3 = LCQuery('Leave');
    query3.whereEqualTo('startDate', todayBeijingTime);

    LCQuery<LCObject> query = LCQuery.or([query1, query2, query3]);
    query.orderByDescending('createdAt');
    query.limit(100);
    List<LCObject> leaves = await query.find();

    return leaves;
  }
}
