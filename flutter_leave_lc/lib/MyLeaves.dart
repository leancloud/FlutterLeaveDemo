import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'Common/Global.dart';

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
    print('_retrieveData-----1');

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
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),

              itemCount: this._listSize,
              itemBuilder: (context, index) {
                var _data = this._historyList[index];
//                print(this._historyList.length);
                print('00000000');

                if (this._listSize == 0) {
                  return Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16.0),
                      child: new Text(
                        "没有请假记录",
                        style: TextStyle(color: Colors.grey),
                      ));
                } else {
                  var _data = this._historyList[index];
                  print('999999999');

                  return Container(
                    padding: const EdgeInsets.all(32.0),
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                            child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: new Text(
                                '1111',
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            new Text('22',
                                //this._historyList[index]['note']
                                style: new TextStyle(
                                  color: Colors.grey[500],
                                ))
                          ],
                        ))
                      ],
                    ),
                  );
                }
              },
//              separatorBuilder: (context, index) => Divider(height: .0),
            )),
      ),
    );
  }

  Future _retrieveData() async {
    print('_retrieveData-----_retrieveData');
    LCQuery<LCObject> query = LCQuery('Leave');
    query.orderByAscending('createdAt');
    List<LCObject> leaves = await query.find();
    print(leaves.length);
    this._historyList = leaves;
    this._listSize = leaves.length;
//        for (LCObject comment in leaves) {
//          String post = comment['note'];
//        }
  }
}
