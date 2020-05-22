import 'package:flutter/material.dart';
import 'package:leancloud_storage/leancloud.dart';

class Global {
  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    //初始化网络请求相关配置
      LeanCloud.initialize(
          'eLAwFuK8k3eIYxh29VlbHu2N-gzGzoHsz', 'G59fl4C1uLIQVR4BIiMjxnM3',
          server: 'https://elawfuk8.lc-cn-n1-shared.com',
          queryCache: new LCQueryCache());
  }
}
