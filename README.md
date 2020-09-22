
## APP 效果预览

[App Store下载链接](https://apps.apple.com/us/app/id1518553843)，或者 App Store 搜索 `LeanCN` 下载。

<img src="http://lc-elawfuk8.cn-n1.lcfile.com/d074ce9b7d1c69bb21d0/WechatIMG457.png" width = "250" height = "541" />  
<img src="http://lc-elawfuk8.cn-n1.lcfile.com/f4de25bebcd5980c6be9/WechatIMG455.png" width = "250" height = "541" /> 
<img src="http://lc-elawfuk8.cn-n1.lcfile.com/4305bd10ea39512b2993/WechatIMG456.png" width = "250" height = "541" /> 
<br/>

## APP 简介
用 Flutter 快速实现请假与写周报 APP。

公司使用的请假及写周报系统一直都是网页版的，之前我们也有想过出一个移动端版本，但因为一些原因没有付诸行动。刚好最近 LeanCloud 新发布了 Flutter SDK，就决定用 Flutter 来开发这款 APP。

之所以选择 Flutter，主要原因是一份代码可以同时满足 iOS 和 Android 两大平台，这样所有同事都可以享受到这款 APP 带来的便利。

APP 的后端数据全部存放在 LeanCloud，不用担心后端系统的开发维护，实现起来也很简单。

## 开发环境搭建

Flutter 安装和环境搭建直接查看：[ Flutter 文档](https://flutter.dev/docs/get-started/install)。
编辑器可以选择 Android Studio、Visual Studio Code 或者 Emacs，编辑器就根据个人喜好和开发习惯选择了。

Flutter 开发环境配置好以后，再来创建 LeanCloud 应用。

- 首先登录 [LeanCloud 控制台](https://leancloud.cn/dashboard/login.html#/signin)，创建一个新应用；
- 在控制台 > 应用 > 设置 >域名绑定页面绑定 **API 访问域名**。暂时没有域名可以略过这一步，LeanCloud 也提供了短期有效的免费体验域名；或者注册[ LeanCloud 国际版](https://console.leancloud.app/login.html#/signin)，国际版不要求绑定域名。

在控制台 > 应用 > 设置 > 应用 Keys 页面记录 AppID、AppKey 与服务器地址备用，这里的服务器地址就是 REST API 服务器地址。如果未绑定域名，控制台相同的位置可以获取到免费的共享域名。

## 使用到的第三方库

在 pubspec.yaml 中，将 LeanCloud Flutter SDK：leancloud_storage 添加到依赖项列表:

```
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^0.1.2
  leancloud_storage: ^0.4.0 
  http: ^0.12.0+4
  date_format: ^1.0.8 
  flutter_localizations:
    sdk: flutter
  fluttertoast: ^4.0.1
  shared_preferences: ^0.5.7+3
  flutter_markdown: ^0.4.2
```

其他第三方插件的说明：

> date_format: 请假页面用到的日期相关格式化插件
>
> flutter_localizations：用于设置时间选择器的中文显示
>
> fluttertoast：类似 Android 中的 Toast 小插件
>
> shared_preferences：本地数据存储
>
> flutter_markdown：展示周报内容时支持 markdown 格式

## APP 初始化设置

#### 初始化 SDK

执行下面的代码连接到在 LeanCloud 创建好的应用。
导入如下包：

```
import 'package:leancloud_storage/leancloud.dart';
```

初始化配置代码：

```
Future initLeanCloud() async {
  LeanCloud.initialize(
      'AppID', 'AppKey',//AppID 与 AppKey 在控制台设置 > 应用 Keys 页面获取
      server: 'https://e36trlaa.lc-cn-n1-shared.com',//这里填控制台绑定的域名或共享 API 域名
      queryCache: new LCQueryCache());
}
```

#### 设计数据结构

在 LeanCloud 控制台 > 存储 > 结构化数据中创建需要的 Class，并添加相关字段，比如请假表（Leave）中，需要有请假人姓名，请假时长，请假原因，开始请假日期等。

客户端保存数据时，如果 Class 不存在，系统也会自动生成对应的 Class。

<div align=center><img src="http://lc-elawfuk8.cn-n1.lcfile.com/a9dbc6ee7a17f0d80bda/Snip20200623_8.png"style="transform: translate(-50%, -50%); height: 100%;"/> </div>
## 登录与注册模块

LeanCloud 提供了 LCUser 类来方便使用用户管理的功能，在控制台对应 _User 表。注册与登录选择了 **用户名+密码** 的方式。实现用户注册只需要执行以下代码，就会在 _User 表新增一条用户数据：

```
LCUser user = LCUser();
user.username = 'Tom';
user.password = 'cat!@#123';
await user.signUp();
```

用户登录也只需要传入用户名与密码：

```
LCUser user = await LCUser.login('Tom', 'cat!@#123');
```

在应用中如果想要获取当前登录用户，可以用：

```
LCUser currentUser = await LCUser.getCurrent();
```

LCUser 还支持手机号 + 验证码注册，更多登录注册方式可以查看 [LeanCloud 用户文档](https://leancloud.cn/docs/leanstorage_guide-flutter.html#hash885156)。

## 请假模块的实现

请假部分包含「提交一条请假记录」、「查询我的历史请假记录」与「查询今日请假同事」这三个部分。

#### 提交一条请假记录

保存一条数据到 LeanCloud 后台也很简单，一条数据可以看成一个 LCObject 对象，直接给 LCObject 对象赋值，save 成功以后可以在 Leave 表中看到新增了一行数据。

```
//创建 Class 并保存一条数据，Leave 表用来存放请假员工数据
LCObject leave = LCObject('Leave');
leave['startTime'] = startTime;//请假的开始时间(AM/PM)
leave['endTime'] = endTime;//请假结束时间(AM/PM)
LCUser user = await LCUser.getCurrent();
leave['username'] = user.username;//请假员工用户名
leave['startDate'] = startDate;//请假开始日期
leave['type'] = leaveType;//请假类型，病假、年假或产假等
leave['duration'] = duration;//请假时长
leave['note'] = note;//请假原因
leave['endDate'] = endDate;//请假结束日期
await leave.save();//保存到 LeanCloud 后台
```

#### 查询我的历史请假记录

查询数据使用 LCQuery，query.find() 返回符合条件的 List：

```
LCUser user = await LCUser.getCurrent();
//查询 Leave 表
LCQuery<LCObject> query = LCQuery('Leave');
query.whereEqualTo('username', user.username);
//按照创建时间排序
query.orderByDescending('createdAt');
//leaves 是当前登录用户的全部请假记录
List<LCObject> leaves = await query.find();
```

#### 查询今日请假同事

```
LCQuery<LCObject> query = LCQuery('Leave');
//查找 DateTime.now() 在请假开始日期与结束日期之间的数据
query.whereGreaterThanOrEqualTo('endDate', DateTime.now());
query.whereLessThanOrEqualTo('startDate', DateTime.now());
query.orderByDescending('createdAt');
List<LCObject> leaves = await query.find();
```

## 周报模块实现

周报模块分两部分，保存一条周报和查询历史周报。展示周报支持 markdown 格式，所以在提交周报的时候，可以设置默认周报格式，用三个单引号 ''' 包起来的文本可以保留原文本格式展示：

```
String text = '''
### This week
* done1
* done2

### Next week
* todo1
* todo2
    ''';
```

#### 保存周报

为了区分提交周报的员工，创建一个 Pointer 类型字段指向 _User 表，字段名称是 user，保存数据时把当前用户赋值给 user 即可。（Leave 表同理也可以创建 Pointer 类型字段记录请假员工）。

```
LCUser user = await LCUser.getCurrent();
//WeeklyPub 是存储周报数据的表
LCObject obj = LCObject('WeeklyPub');
obj['content'] = text;
// user 字段是 pointer 类型，指向 _User 表
obj['user'] = user;
LCObject object = await obj.save();
```

#### 查询周报

查询周报时，想要一并获取员工信息，可以使用 include，这样一次查询就可以查到这条周报的数据和员工（_User 表）的数据：

```
LCQuery<LCObject> query = LCQuery('WeeklyPub');
// 查询结果同时包含用户信息
query.include('user');
query.orderByDescending('createdAt');
query.whereGreaterThanOrEqualTo(
    'createdAt', DateTime.parse('2020-06-01 00:00:00Z'));
List<LCObject> weekly = await query.find();
```

## 联系人列表

联系人列表可以通过查询 _User 表获取，但这里会有一个问题。

为了安全起见，LeanCloud 新创建的应用的 _User 表默认关闭了 find 权限。用户只能查询到自己在 _User 表中的数据，无法查询其他用户的数据。

解决办法可以是单独创建一张表来保存这类数据，并开放这张表的 find 查询权限。或者可以在 [云引擎](https://leancloud.cn/docs/leanengine_overview.html) 里封装用户查询的方法，这样就无需开放 _User 表的 find 权限。

本 APP 采用的办法是结合云引擎，设置了查询用户表的云函数，来保证数据安全。

- 第一步参考 [在线编写云函数](https://leancloud.cn/docs/leanengine_cloudfunction_guide-node.html#hash-271574262) 文档，在 **LeanCloud 控制台 > 云引擎 > 部署 > 在线编辑** 标签页创建云函数。例如我的云函数名是 queryUsers：

```
AV.Cloud.define('queryUsers', async function (request) {
  if (request.currentUser) {
    const userQuery = new AV.Query('_User');
    userQuery.addDescending('createdAt');
    return await userQuery.find();
  } else {
    throw new AV.Cloud.Error('用户未登录');
  }
})
```

- 然后点击「部署」按钮，部署到生产环境。

部署成功后，在移动端可以直接调用云函数，Flutter 代码中可以这样调用云函数：

```
Map<String, dynamic> userMap = await LCCloud.run('queryUsers');
//users 就是云函数返回的用户列表
List<dynamic> users = userMap['result'];
```

## 参考文档

1. [LeanCloud  - 数据存储开发指南 · Flutter](https://leancloud.cn/docs/leanstorage_guide-flutter.html#hash765832)
2. [ Flutter 文档](https://flutter.dev/docs)

