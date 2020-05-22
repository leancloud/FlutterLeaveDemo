import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';

class TodayLeavesPage extends StatefulWidget {
  @override
  _TodayLeavesPageState createState() => new _TodayLeavesPageState();
}

class _TodayLeavesPageState extends State<TodayLeavesPage>  with AutomaticKeepAliveClientMixin{
  @protected
  bool get wantKeepAlive=>true;

  List<LCObject> _historyList ; //全部记录
  int _listSize = 0;

  @override
  void initState() {
    super.initState();
    _retrieveData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: this._listSize,
      itemBuilder: (context, index) {
        if ( this._listSize == 0) {
          return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16.0),
              child: Text("没有请假记录", style: TextStyle(color: Colors.grey),)
          );

        } else {
          return ListTile(
              title: Text(this._historyList[index]['note'])
          );
        }
      },
      separatorBuilder: (context, index) => Divider(height: .0),
    );
  }
  void _retrieveData () async{

    LCQuery<LCObject> query = LCQuery('Leave');
    List<LCObject> leaves = await query.find();
    print(leaves.length);
    this._historyList = leaves;
    this._listSize  =leaves.length;
//        for (LCObject comment in leaves) {
//          String post = comment['note'];
//        }
  }

}