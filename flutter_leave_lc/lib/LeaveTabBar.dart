import 'package:flutter/material.dart';
import 'Leavepage.dart';
import 'MyLeaves.dart';
import 'TodayLeaves.dart';

class LeaveTabPage extends StatefulWidget {
  LeaveTabPage({Key key}) : super(key: key);
  _LeaveTabPageState createState() => _LeaveTabPageState();
}

class _LeaveTabPageState extends State<LeaveTabPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List _tabs = ["请假", "我的请假历史", "今日休假同事"];
  List<Widget> _pages = [
    LeavePage(),
    MyLeavesPage(),
    TodayLeavesPage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: this._pages.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // 隐藏阴影
        //flexibleSpace 用于 Tabbar 去除 AppBar 行高
        flexibleSpace: new Column(
          children: <Widget>[
            new TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                indicatorColor: Colors.blue,
                tabs: this._tabs.map((e) => Tab(text: e)).toList())
          ],
        ),
      ),
      body: new TabBarView(
        //不要滑动
        physics: new NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _pages,
      ),
    );
  }
}
