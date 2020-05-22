import 'package:flutter/material.dart';
import 'package:flutterapplc/Leave/Leave.dart';
import 'MyInformation.dart';
import 'package:flutterapplc/WeeklySummary.dart';
import 'Contacts.dart';
import 'Leave/LeaveTabBar.dart';

class HomeBottomBarPage extends StatefulWidget {
  @override
  _HomeBottomBarPageState createState() => _HomeBottomBarPageState();
}

class _HomeBottomBarPageState extends State<HomeBottomBarPage> {
  int _currentIndex = 0; //记录当前选中的页面
  List<Widget> _pages = [
    LeaveTabPage(),
    WeeklySummaryPage(),
    ContactsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: Text("LeanCloud"),
        centerTitle: true,
        actions: <Widget>[
          //导航栏右侧菜单
//          IconButton(icon: Icon(Icons.share), onPressed: () {}),
        ],
      ),
      drawer: new MyDrawer(), //抽屉
      body: IndexedStack(
        index: this._currentIndex,
        children: this._pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.flight_takeoff), title: Text('请假')),
          BottomNavigationBarItem(
              icon: Icon(Icons.event_note), title: Text('周报')),
          BottomNavigationBarItem(icon: Icon(Icons.phone), title: Text('联系人')),
        ],
        currentIndex: this._currentIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      this._currentIndex = index;
    });
  }

  void _onAdd() {}
}
