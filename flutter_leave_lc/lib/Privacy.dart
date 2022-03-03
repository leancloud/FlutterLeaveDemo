import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
class PrivacyPage extends StatefulWidget {
  @override
  _UserProtocolPageState createState() => new _UserProtocolPageState();
}

class _UserProtocolPageState extends State<PrivacyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//     String str = '''
// 本应用不收集任何用户信息。包括：
//
// 1. 不会收集设备 Mac 地址，也不会采集唯一设备识别码（如 IMEI / android ID / IDFA / OPENUDID / GUID、SIM 卡 IMSI 信息）对用户进行唯一标识。
//
// 2.不会访问用户个人信息，也不会访问其他应用的数据信息。
//
// 个人信息权限授予说明：
//
// 1.应用开启 INTERNET 权限，用于允许应用程序联网和发送请求数据的权限，以便保存用户数据。
//
// 2.应用开启 ACCESS_NETWORK_STATE 权限，	用于检测联网方式，在网络异常状态下避免数据发送，节省流量和电量。
//
// 除此之外，本应用不要求任何系统权限。
//
// 公司主体：2021 美味书签（北京）信息技术有限公司
//
//     ''';
   return new WebviewScaffold(
      url:"https://leancn.goodluckin.top/",
              appBar: AppBar(
          //导航栏
          title: Text("用户隐私政策"),
          centerTitle: true,
        ),
      withZoom: true,
      // 允许网页缩放
      withLocalStorage: true,
      // 允许LocalStorage
      withJavascript: true, // 允许执行js代码
    );
  }
}