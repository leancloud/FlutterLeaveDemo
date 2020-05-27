import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'Common/Global.dart';
import 'package:date_format/date_format.dart';

class MyLeavesPage extends StatefulWidget {
  @override
  _MyLeavesPageState createState() => new _MyLeavesPageState();
}

class _MyLeavesPageState extends State<MyLeavesPage> {
  List<LCObject> _historyList; //全部记录
  int _listSize = 0;

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(2.0),
        child: RefreshIndicator(
            onRefresh: _retrieveData,
            backgroundColor: Colors.blue,
            child: ListView.separated(
              //添加分割线
              separatorBuilder: (BuildContext context, int index) {
                return new Divider(height: 0.8, color: Colors.grey,);
              },
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: this._listSize,
              itemBuilder: (context, index) {
                var _data = this._historyList[index];

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
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                        flex: 2,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Container(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: new Text(
                                getVacationType(_type),
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            new Text(
                              note,
                              style: new TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      new Expanded(
                        flex: 1,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Container(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: new Text(
                                '${_duration.toString()} 天',
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            new Text(
                              updatedAtString,
                              style: new TextStyle(
                                color: Colors.grey[500],
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
            )),
      ),
    );
  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Container(
//        padding: EdgeInsets.all(2.0),
//        child: RefreshIndicator(
//            onRefresh: _retrieveData,
//            backgroundColor: Colors.blue,
//            child: ListView.builder(
//              physics: const AlwaysScrollableScrollPhysics(),
//              itemCount: this._listSize,
//              itemBuilder: (context, index) {
//                var _data = this._historyList[index];
//                int _type = _data['type'];
//                String note;
//                if (_data['note'] == null) {
//                  note = '因为羞羞的原因';
//                } else {
//                  note = _data['note'];
//                }
//                return Container(
//                  padding: const EdgeInsets.all(32.0),
//                  child: Row(
//                    children: <Widget>[
//                      new Expanded(
//                          child: new Column(
////                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: <Widget>[
//                              Text(
//                                getVacationType(_type),
//                                style: new TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                              Text(" I am Jack "),
//                            ],
//                          ),
//                          Row(
//                            mainAxisAlignment: MainAxisAlignment.end,
//                            children: <Widget>[
//                              Text(
//                                getVacationType(_type),
//                                style: new TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                ),
//                              ),
//                              Text(" I am Jack "),
//                            ],
//                          ),
//                          new Container(
//                            padding: const EdgeInsets.only(bottom: 8.0),
//                            child: new Text(
//                              getVacationType(_type),
//                              style: new TextStyle(
//                                fontWeight: FontWeight.bold,
//                              ),
//                            ),
//                          ),
//                          new Text(note,
//                              style: new TextStyle(
//                                color: Colors.grey[500],
//                              ))
//                        ],
//                      ))
//                    ],
//                  ),
//                );
//              },
////              separatorBuilder: (context, index) => Divider(height: .0),
//            )),
//      ),
//    );
//  }

  Future _retrieveData() async {
    LCQuery<LCObject> query = LCQuery('Leave');
    query.orderByAscending('createdAt');
    List<LCObject> leaves = await query.find();
    this._historyList = leaves;
    print(leaves);
    this._listSize = leaves.length;
    //更新视图
    setState(() {});
  }
}
