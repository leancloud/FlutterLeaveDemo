import 'package:flutter/material.dart';
import 'package:flutterapplc/WeeklySummary.dart';
import 'Leavepage.dart';
import 'TodayLeaves.dart';
import 'MyWeekly.dart';

class WeeklyTabBarPage extends StatefulWidget {
  WeeklyTabBarPage({Key key}) : super(key: key);
  _WeeklyTabBarPageState createState() => _WeeklyTabBarPageState();
}

class _WeeklyTabBarPageState extends State<WeeklyTabBarPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List _tabs = ["写周报", "周报汇总"];
  List<Widget> _pages = [
    MyWeeklyPage(),
    WeeklySummaryPage(),
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
        physics: new NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _pages,
      ),
    );
  }
}
