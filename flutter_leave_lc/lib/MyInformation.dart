import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//TODO 手机号、邮箱、RealName


class MyInformationPage extends StatefulWidget {
  MyInformationPage({Key key}) : super(key: key);
  _MyInformationPageState createState() => _MyInformationPageState();
}


class _MyInformationPageState extends State<MyInformationPage> {
  String  name = '暂无';
  @override
  void initState() {
    super.initState();
    getUserName();
 }

  getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    this.name = prefs.getString('username');
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 38.0),
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipOval(
                      child:Icon(Icons.face,color: Colors.blue,),
                    ),
                  ),
                  Text(this.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text('Add account'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Manage accounts'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}