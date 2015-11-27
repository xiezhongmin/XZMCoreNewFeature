# XZMCoreNewFeature
![(logo)](http://images.cnitblog.com/blog2015/497279/201505/051004492043385.png)
##易用的版本新特性框架(添加了版本的本地缓存功能,适应各种APP的新特性界面，集成只需几行代码，没有耦合度)

#示例截图

##普通图片滚动新特性界面
![(logo)](http://7xkt3g.com1.z0.glb.clouddn.com/CoreNewFeatureputong.gif)
```objc

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

self.window = window;

//判断是否需要显示：（内部已经考虑版本及本地版本缓存）
BOOL canShow = [XZMCoreNewFeatureVC canShowNewFeature];

//测试代码，正式版本应该删除
canShow = YES;

if(canShow){ // 初始化新特性界面
window.rootViewController = [XZMCoreNewFeatureVC newFeatureVCWithImageNames:@[@"new1",@"new2",@"new3",@"new4"] enterBlock:^{

NSLog(@"进入主页面");
[self enter];

} configuration:^(UIButton *enterButton) { // 配置进入按钮
[enterButton setBackgroundImage:[UIImage imageNamed:@"btn_nor"] forState:UIControlStateNormal];
[enterButton setBackgroundImage:[UIImage imageNamed:@"btn_pressed"] forState:UIControlStateHighlighted];
enterButton.bounds = CGRectMake(0, 0, 120, 40);
enterButton.center = CGPointMake(KScreenW * 0.5, KScreenH* 0.85);
}];

}else{

[self enter];
}

[window makeKeyAndVisible];

return YES;
}

```

##视频新特性界面
###每天APP
![(logo)](http://7xkt3g.com1.z0.glb.clouddn.com/CoreNewFeatureshiping.gif)


###美团外卖APP
![(logo)](http://7xkt3g.com1.z0.glb.clouddn.com/CoreNewFeaturemeitushiping.gif)
```objc

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

self.window = window;

//判断是否需要显示：（内部已经考虑版本及本地版本缓存）
BOOL canShow = [XZMCoreNewFeatureVC canShowNewFeature];

//测试代码，正式版本应该删除
canShow = YES;

if(canShow){ // 初始化新特性界面
window.rootViewController = [XZMCoreNewFeatureVC newFeatureVCWithPlayerURL:[[NSBundle mainBundle] URLForResource:@"启动视频.mp4" withExtension:nil] enterBlock:^{

NSLog(@"进入主页面");
[self enter];
} configuration:^(AVPlayerLayer *playerLayer) {

}];

}else{

[self enter];
}

[window makeKeyAndVisible];

return YES;
}

```


## 特性说明:
###1.封装并简化了版本新特性启动视图！
###2.支持视频播放新特性
###3.添加了版本的本地缓存功能
###4.集成简单，使用方便，没有耦合度
###5.支持block回调。
###5.喜欢你就Star一下吧，感谢你的支持！
###6.本框架来自Charlin作者的框架上做了一些改动与增加新的内容，感谢Charlin作者！