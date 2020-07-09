import 'package:flutter/material.dart';
import 'AdminLeavePage.dart';
import 'AdminAllLeaveHistoryPage.dart';

class AdminTabPage extends StatefulWidget {
  AdminTabPage({Key key}) : super(key: key);
  _AdminTabPageState createState() => _AdminTabPageState();
}

class _AdminTabPageState extends State<AdminTabPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List _tabs = ['补假', '全员请假记录'];
  List<Widget> _pages = [
    AdminLeavePage(),
    AdminAllLeaveHistoryPage(),
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
