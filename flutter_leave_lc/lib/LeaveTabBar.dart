import 'package:flutter/material.dart';
import 'Leave.dart';
import 'MyLeaves.dart';
import 'TodayLeaves.dart';

class LeaveTabPage extends StatefulWidget {
  LeaveTabPage({Key key}) : super(key: key);
  _LeaveTabPageState createState() => _LeaveTabPageState();
}

class _LeaveTabPageState extends State<LeaveTabPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  int _currentIndex = 0; //选中下标

  List _tabs = ["请假", "请假历史", "今日休假"];
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
  void dispose() {
    ///页面销毁时，销毁控制器
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
          backgroundColor: Colors.white,
          elevation: 0, // 隐藏阴影
          bottom: (new TabBar(
              controller: this._tabController,
              labelColor: Colors.blue,
              indicatorColor: Colors.blue,
              tabs: this
                  ._tabs
                  .map((e) => Tab(text: e))
                  .toList()))), //  PageController _pageController;

      body: new TabBarView(
        controller: _tabController,
        children: _pages,
      ),
    );
  }
}
