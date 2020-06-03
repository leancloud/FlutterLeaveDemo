import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'Common/Global.dart';
import 'package:date_format/date_format.dart';

class MyLeavesPage extends StatefulWidget {
  @override
  _MyLeavesPageState createState() => new _MyLeavesPageState();
}

class _MyLeavesPageState extends State<MyLeavesPage> {

  @override
  void initState() {
    super.initState();
    retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
//        padding: EdgeInsets.all(2.0),
        child:
        FutureBuilder<List<LCObject>>(

          future: retrieveData(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            // 请求已结束
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // 请求失败，显示错误
                return Text("Error: ${snapshot.error}");
              } else {
                // 请求成功，显示数据
                return
                    ListView.separated(
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
                        var _data = snapshot.data[index];
                        int _type = _data['type'];
                        int _duration = _data['duration'];
                        String note;
                        if (_data['note'] == null) {
                          note = '因为羞羞的原因';
                        } else {
                          note = _data['note'];
                        }
                        DateTime createdAt = _data.createdAt;
                        String updatedAtString =
                        formatDate(createdAt, [yyyy, "-", mm, "-", dd, " "]);

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
                                      padding: const EdgeInsets.only(bottom: 8.0,right: 8,left: 10),
                                      child: new Text(
                                        getVacationTypeString(_type),
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    new Container(
                                      padding: const EdgeInsets.only(bottom: 8.0,right: 8,left: 10),
                                      child: new Text(
                                        note,
                                        style: new TextStyle(
                                          color: Colors.grey[500],
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
                                      padding: const EdgeInsets.only(bottom: 8.0,right: 10),
                                      child: new Text(
                                        '${_duration.toString()} 天',
                                        style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    new Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: new Text(
                                        updatedAtString,
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

  Future <List<LCObject>> retrieveData() async {
    LCQuery<LCObject> query = LCQuery('Leave');
    query.orderByAscending('createdAt');
    List<LCObject> leaves = await query.find();
    //更新视图
//    setState(() {});
    return leaves;
  }
}
