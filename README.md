
## APP 效果预览

[App Store下载链接](https://apps.apple.com/us/app/id1518553843)，或者 App Store 搜索 `LeanCN` 下载。

<div align=center><img src="http://lc-elawfuk8.cn-n1.lcfile.com/d074ce9b7d1c69bb21d0/WechatIMG457.png" width = "250" height = "541" /> </div>


## APP 简介

* 登录注册模块使用 LeanCloud 存储服务的用户系统；
* 请假历史，周报内容与联系人列表等后端数据全部存放在 LeanCloud，不涉及后端系统的开发维护。

## 开发环境搭建

Flutter 安装和环境搭建直接查看：[ Flutter 文档](https://flutter.dev/docs/get-started/install)。
编辑器可以选择 Android Studio、Visual Studio 或者 Emacs，我选择 Android Studio 作为编辑器。

Flutter 开发环境配置好以后，再来创建 LeanCloud 应用。 

* 首先登录 [LeanCloud 控制台](https://leancloud.cn/dashboard/login.html#/signin)，创建一个新应用；
* 然后在应用 > 设置 >域名绑定页面绑定 **API 访问域名**，绑定自有域名有利于从域名层面做好应用隔离，确保业务稳定。暂时没有域名可以略过这一步，LeanCloud 提供了免费体验的域名。
* 在应用 > 设置 > 应用 Keys 页面记录 AppID、AppKey 与服务器地址备用（这里的服务器地址就是 REST API 服务器地址，如果未绑定自有域名，控制台也提供了供测试的共享域名，共享域名格式类似： https://e36trlaa.lc-cn-n1-shared.com ）。


Flutter 的 UI 搭建不做赘述，具体细节可以参考 Flutter 官方文档。主要介绍 LeanCloud Flutter 存储的 SDK 的使用。

## SDK 安装与初始化

LeanCloud Flutter SDK 获取地址：

1. [github 开源 SDK 地址](https://github.com/leancloud/Storage-SDK-Flutter/)
2. [pub.dev 地址](https://pub.dev/packages/leancloud_storage#)

#### 安装 SDK

在 pubspec.yaml 中，将 SDK 添加到依赖项列表:
```
dependencies:
  flutter:
    sdk: flutter
  ...
  leancloud_storage: ^0.4.0 
```
SDK 的版本更新历史可以在[这里](https://pub.dev/packages/leancloud_storage#-changelog-tab-)看。

#### 初始化 SDK
导入如下包：
```
import 'package:leancloud_storage/leancloud.dart';
```
然后运行
```
Future initLeanCloud() async {
  LeanCloud.initialize(
      'AppID', 'AppKey',//AppID 与 AppKey 在控制台设置 > 应用 Keys 页面获取
      server: 'https://e36trlaa.lc-cn-n1-shared.com',//这里填控制台绑定的域名或共享 API 域名
      queryCache: new LCQueryCache());
}
```

#### 测试

可以在项目 lib/main.dart 中编写如下测试代码，来检测SDK 是否安装成功。

```
Future testLeanCloud() async {
  //创建 Class 并保存一条数据，如果 Class 已经存在则新增一条数据。
  LCObject object = LCObject('TestObject');
  //新增一个 String 类型字段（列），字段名是 words，并赋值。
  object['words'] = 'Hello world!'; 
  //保存数据至 LeanCloud
  await object.save();
}
```
然后打开 控制台 > 存储 > 数据，可以看到数据表中多了一条名为 `TestObject` 的 Class，说明 SDK 安装成功。


## 登录注册

LeanCloud 提供了 LCUser 类来方便应用使用各项用户管理的功能，在控制台对应用户表（_User 表），
此 APP 用户的注册模块是选择了 **用户名+密码** 的注册方式。实现用户注册只需要执行以下代码，就会在 _User 表新增一条用户数据：

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
更多登录注册方式可以查看 [LeanCloud 用户文档](https://leancloud.cn/docs/leanstorage_guide-flutter.html#hash885156)。

## 请假模块的实现

#### 添加一条请假记录
```
//创建 Class 并保存一条数据，Leave 表用来存放请假员工数据
LCObject leave = LCObject("Leave");
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
#### 查询「我的」历史请假记录
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

#### 查询今天请假同事
```
LCQuery<LCObject> query = LCQuery('Leave');
//查找 DateTime.now() 在请假开始日期与结束日期之间的数据
query.whereGreaterThanOrEqualTo('endDate', DateTime.now());
query.whereLessThanOrEqualTo('startDate', DateTime.now());
query.orderByDescending('createdAt');
List<LCObject> leaves = await query.find();
```
## 周报模块实现

#### 保存周报
为了区分提交周报的员工，创建一个 Pointer 类型字段指向 _User 表。
```
//WeeklyPub 是存储周报数据的表
LCUser user = await LCUser.getCurrent();
LCObject obj = LCObject('WeeklyPub');
obj['content'] = text;
// user 字段是 pointer 类型，指向 _User 表
obj['user'] = user;
LCObject object = await obj.save();
```
#### 查询周报

查询周报时想要一并获取周报提交者的用户信息，可以使用 `include`:
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

本 APP 采用办法是结合云引擎，设置了查询用户表的云函数，来保证数据安全。

* 第一步根据 [云引擎快速入门](https://leancloud.cn/docs/leanengine_quickstart.html) 创建项目。
* 然后新增一个「查询用户列表的」云函数，部署到云端即可。

部署成功后，在移动端可以直接调用云函数，例如我的云函数名是 `queryUsers`,代码中可以这样调用云函数：
```
Map<String, dynamic> userMap = await LCCloud.run('queryUsers');
//users 就是云函数返回的用户列表
List<dynamic> users = userMap['result'];
```
