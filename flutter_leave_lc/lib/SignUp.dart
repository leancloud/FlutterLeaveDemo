import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'Login.dart';
import 'HomeBottomBar.dart';
import 'Common/Global.dart';

import 'package:shared_preferences/shared_preferences.dart';
//用户注册的时候只要用户名+密码，手机号、邮箱、Realame等在个人中心自己设置
//eancloud 分支需要去掉注册账号这一步

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _userName, _password;
  bool _isObscure = true;
  Color _eyeColor;

  Future userSignUp(String name, String password) async {
    CommonUtil.showLoadingDialog(context); //发起请求前弹出loading

    initLeanCloud().then((response) {
      saveUserType('游客登录');

      saveUserProfile(name, password);
      signUp(name, password).then((value) {
        login(name, password).then((value) {
          Navigator.pop(context); //销毁 loading
          Navigator.pushAndRemoveUntil(
              context,
              new MaterialPageRoute(builder: (context) => HomeBottomBarPage()),
              (_) => false);
        }).catchError((error) {
          showToastRed(error.toString());
          Navigator.pop(context); //销毁 loading
        });
      }).catchError((error) {
        showToastRed(error.toString());
        Navigator.pop(context); //销毁 loading
      });
    }).catchError((error) {
      showToastRed(error);
      Navigator.pop(context); //销毁 loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle(),
                SizedBox(height: 70.0),
                buildEmailTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
                buildRegisterText(context),
              ],
            )));
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('已经有账号？'),
            GestureDetector(
              child: Text(
                '点击登录',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                // 跳转到登录页面
                Navigator.pushAndRemoveUntil(
                    context,
                    new MaterialPageRoute(builder: (context) => LoginPage()),
                    (_) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '注册',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.black,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              //注册
              userSignUp(this._userName, this._password);
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: 'Password',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'User Name',
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入用户名';
        }
        return null;
      },
      onSaved: (String value) => _userName = value,
    );
  }

  Padding buildTitle() {
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            'LeanCloud 注册',
            style: TextStyle(fontSize: 28.0),
          ),
        ));
  }

  Future login(String name, String password) async {
    LCUser user = await LCUser.login(name, password);
  }

  Future signUp(String name, String password) async {
    LCUser user = LCUser();
    user.username = name;
    user.password = password;
    await user.signUp();
  }

  Future initLeanCloud() async {
    //游客登录
    LeanCloud.initialize(
        'eLAwFuK8k3eIYxh29VlbHu2N-gzGzoHsz', 'G59fl4C1uLIQVR4BIiMjxnM3',
        server: 'https://elawfuk8.lc-cn-n1-shared.com',
        queryCache: new LCQueryCache());
  }
  Future saveUserProfile(String username,String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }
}
