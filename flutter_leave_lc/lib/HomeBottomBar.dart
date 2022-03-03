import 'package:flutter/material.dart';
import 'package:flutterapplc/Common/Global.dart';
import 'package:flutterapplc/Setting.dart';
import 'package:flutterapplc/WeeklySummary.dart';
import 'package:flutterapplc/WeeklyTabbar.dart';
import 'LeavePage.dart';
import 'MyInformation.dart';
import 'package:flutterapplc/WeeklySummary.dart';
import 'Contacts.dart';
import 'LeaveTabBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'AdminTabPage.dart';

class HomeBottomBarPage extends StatefulWidget {
  @override
  _HomeBottomBarPageState createState() => _HomeBottomBarPageState();
}

class _HomeBottomBarPageState extends State<HomeBottomBarPage> {
  int _currentIndex = 0; //记录当前选中的页面
  bool _isAdmin = false;
  bool _isAdminButtonPressed = false;

  List<Widget> _pages = [
    LeaveTabPage(),
    WeeklyTabBarPage(),
    ContactsPage(),
    SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    queryProfile();
  }

  queryProfile() async {
    _isAdmin = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('username');
    String userType = prefs.getString('userType');
    if (userType == 'LeanCloud 员工') {
      if (name == 'hwang' || name == 'mwu') {
        _isAdmin = true;
      }
    } else {
      _isAdmin = false;
    }
    setState(() {});
  }

  Align navRightButton(BuildContext context) {
    Align content;
    if (_isAdmin == false) {
      content = Align(
        alignment: Alignment.center,
        child: new Container(height: 0.0, width: 0.0),
      );
    } else {
      content = Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(top: 0.0),
          child: IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                _isAdminButtonPressed = !_isAdminButtonPressed;
                if (_isAdminButtonPressed) {
                  showToastGreen('管理员模式');
                  _pages = [
                    AdminTabPage(),
                    WeeklyTabBarPage(),
                    ContactsPage(),
                  ];
                  setState(() {});
                } else {
                  showToastGreen('非管理员模式');
                  _pages = [
                    LeaveTabPage(),
                    WeeklyTabBarPage(),
                    ContactsPage(),
                  ];
                  setState(() {});
                }
              }),
        ),
      );
    }
    return content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //导航栏
        title: Text("LeanCloud"),
        centerTitle: true,
        //导航栏右侧菜单
        actions: <Widget>[
          navRightButton(context),
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
          BottomNavigationBarItem(icon: Icon(Icons.settings), title: Text('反馈')),
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
