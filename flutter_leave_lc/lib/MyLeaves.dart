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
                int _type = _data['type'];
                String note;
                if (_data['note'] == null) {
                  note = '因为羞羞的原因';
                } else {
                  note = _data['note'];
                }

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
                              getVacationType(_type),
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          new Text(note,
                              style: new TextStyle(
                                color: Colors.grey[500],
                              ))
                        ],
                      ))
                    ],
                  ),
                );
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
    //更新视图.
    setState(() {});
  }
}
