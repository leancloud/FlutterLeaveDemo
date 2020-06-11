import 'package:flutter/material.dart';
import 'package:flutterapplc/WeeklySummary.dart';
import 'package:flutterapplc/WeeklyTabbar.dart';
import 'LeavePage.dart';
import 'MyInformation.dart';
import 'package:flutterapplc/WeeklySummary.dart';
import 'Contacts.dart';
import 'LeaveTabBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leancloud_storage/leancloud.dart';

class HomeBottomBarPage extends StatefulWidget {
  @override
  _HomeBottomBarPageState createState() => _HomeBottomBarPageState();
}

class _HomeBottomBarPageState extends State<HomeBottomBarPage> {
  int _currentIndex = 0; //记录当前选中的页面

  List<Widget> _pages = [
    LeaveTabPage(),
    WeeklyTabBarPage(),
    ContactsPage(),
  ];
//  final _pages = [LeaveTabPage(), WeeklySummaryPage(), ContactsPage()];
//  @override
//  void initState() {
//    super.initState();
////    this._pageController = PageController(initialPage: this._currentIndex);
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   saveProfile();
  }
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
      drawer: new MyInformationPage(), //抽屉
      body: this._pages[this._currentIndex],
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
        onTap: (index) {
          setState(() {
            //设置点击底部Tab的时候的页面跳转
            this._currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

Future saveProfile() async {
  final prefs = await SharedPreferences.getInstance();
  LCUser user = await LCUser.getCurrent();
  await prefs.setString('username', user.username);
  await prefs.setString('password', user.password);
}

