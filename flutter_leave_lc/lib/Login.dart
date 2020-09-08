import 'package:flutter/material.dart';
import 'HomeBottomBar.dart';
import 'SignUp.dart';
import 'Common/Global.dart';
import 'package:leancloud_storage/leancloud.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Todo 游客可以注册登录，LeanCloud 员工不必注册

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerName = new TextEditingController();
  final TextEditingController _controllerPassword = new TextEditingController();

  String _userIfLeancloud = '游客登录';
  final _formKey = GlobalKey<FormState>();
  String _userName, _password;
  bool _isObscure = true;
  Color _eyeColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveProfile();
  }

  saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('username');
    String userType = prefs.getString('userType');
    if(userType !=null || userType != ''){
      setState(() {
      });
    }

    if (name != null) {
      _controllerName.text = name;
    }
    String password = prefs.getString('password');
    if (password != null) {
      _controllerPassword.text = password;
    }
    if (userType != null) {
      _userIfLeancloud = userType;
    }
  }

  Future userLogin(String name, String password) async {
    CommonUtil.showLoadingDialog(context); //发起请求前弹出loading

    initLeanCloud().then((response) {
      saveUserType(this._userIfLeancloud);
      saveUserProfile();
      login(name, password).then((value) {
        Navigator.pop(context); //销毁 loading
        Navigator.pushAndRemoveUntil(
            context,
            new MaterialPageRoute(builder: (context) => HomeBottomBarPage()),
            (_) => false);
      }).catchError((error) {
        showToastRed(error.message);
        Navigator.pop(context); //销毁 loading
      });
    }).catchError((error) {
      showToastRed(error.message);
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
                SizedBox(height: 20.0),
                buildChooseUserDropdownButton(context),
                SizedBox(height: 30.0),
                buildEmailTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                buildForgetPasswordText(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
                buildRegisterText(context),
              ],
            )));
  }

  Align buildRegisterText(BuildContext context) {
    Align content;
    if (_userIfLeancloud == 'LeanCloud 员工') {
      content = Align(
        alignment: Alignment.center,
        child: new Container(height: 0.0, width: 0.0),
      );
    } else {
      content = Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('没有账号？'),
              GestureDetector(
                child: Text(
                  '点击注册',
                  style: TextStyle(color: Colors.green),
                ),
                onTap: () {
                  //跳转到注册页面
                  Navigator.pushAndRemoveUntil(
                      context,
                      new MaterialPageRoute(builder: (context) => SignUpPage()),
                      (_) => false);
                },
              ),
            ],
          ),
        ),
      );
    }
    return content;
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'Login',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.black,
          onPressed: () {
            if (_formKey.currentState.validate()) {
              //只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              userLogin(_userName, _password);
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  Padding buildChooseUserDropdownButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          DropdownButton<String>(
            value: this._userIfLeancloud,
            onChanged: (String newValue) {
              setState(() {
                this._userIfLeancloud = newValue;
              });
            },
            items: <String>['游客登录', 'LeanCloud 员工']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Padding buildForgetPasswordText(BuildContext context) {
    Padding content;
    if (_userIfLeancloud == '游客登录') {
      content = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: new Container(height: 0.0, width: 0.0),
      );
    } else {
      content = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
            child: Text(
              '忘记密码？',
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
            onPressed: () {
              showToastGreen('可以去控制台重置密码');
            },
          ),
        ),
      );
    }
    return content;
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      controller: _controllerPassword,
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
      controller: _controllerName,
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
            'LeanCloud Login',
            style: TextStyle(fontSize: 28.0),
          ),
        ));
  }

  Future login(String name, String password) async {
    LCUser user = await LCUser.login(name, password);
  }

  Future initLeanCloud() async {
    if (_userIfLeancloud == '游客登录') {
      LeanCloud.initialize(
          'eLAwFuK8k3eIYxh29VlbHu2N-gzGzoHsz', 'G59fl4C1uLIQVR4BIiMjxnM3',
          server: 'https://acn.iwxnews.com',
          queryCache: new LCQueryCache());
    } else {
      LeanCloud.initialize('88cqfanr9aztiol6h6fxeiuhioshn6ltb0ste28iwlgigexz',
          'mncaolv68uzwoftgmg3b8fvbrb4bql1re1epmgblknbyh4b0',
          server: 'https://acn.iwxnews.com',
          queryCache: new LCQueryCache());
    }
  }

  Future saveUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', this._controllerName.text);
    await prefs.setString('password', this._controllerPassword.text);
  }
}
