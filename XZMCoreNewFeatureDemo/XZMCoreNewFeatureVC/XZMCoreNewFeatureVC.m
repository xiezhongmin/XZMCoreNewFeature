//
//  XZMCoreNewFeatureVC.m
//  XZMCoreNewFeatureDemo
//
//  Created by 谢忠敏 on 15/11/26.
//  Copyright © 2015年 com.xiaomage.new. All rights reserved.
//

#import "XZMCoreNewFeatureVC.h"

NSString *const NewFeatureVersionKey = @"NewFeatureVersionKey";

@interface CoreArchive : NSObject
/**
 *  保存普通字符串
 */
+ (void)setStr:(NSString *)str key:(NSString *)key;

/**
 *  读取
 */
+ (NSString *)strForKey:(NSString *)key;

@end


@interface NewFeatureScrollView : UIScrollView

@end

@implementation CoreArchive
// 保存普通对象
+ (void)setStr:(NSString *)str key:(NSString *)key{
    
    // 获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // 保存
    [defaults setObject:str forKey:key];
    
    // 立即同步
    [defaults synchronize];
    
}

// 读取
+ (NSString *)strForKey:(NSString *)key{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //读取
    NSString *str=(NSString *)[defaults objectForKey:key];
    
    return str;
    
}

@end


@implementation NewFeatureScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        //视图准备
        [self viewPrepare];
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self=[super initWithCoder:aDecoder];
    
    if(self){
        
        //视图准备
        [self viewPrepare];
    }
    
    return self;
}


// 视图准备
- (void)viewPrepare{
    
    //开启分页
    self.pagingEnabled = YES;
    
    //隐藏各种条
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    //取消boundce
    self.bounces = NO;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    __block CGRect frame = self.bounds;
    
    __block NSUInteger count = 0;
    
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subView, NSUInteger idx, BOOL *stop) {
        
        if([subView isKindOfClass:[UIImageView class]]){
            
            CGFloat frameX = frame.size.width * idx;
            
            frame.origin.x = frameX;
            
            subView.frame = frame;
            
            count ++;
        }
    }];
    
    self.contentSize = CGSizeMake(frame.size.width * count, 0);
}

@end


@interface XZMCoreNewFeatureVC ()

/** 模型数组 */
@property (nonatomic,strong) NSArray *imageNames;

/** scrollView */
@property (nonatomic,weak) NewFeatureScrollView *scrollView;

/** 播放器 */
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic,copy) void(^enterBlock)();

@end

@implementation XZMCoreNewFeatureVC

// 初始化滚动图片新特性界面
+ (instancetype)newFeatureVCWithImageNames:(NSArray *)imageNames enterBlock:(void(^)())enterBlock configuration:(void (^)(UIButton *enterButton))configurationBlock
{
    XZMCoreNewFeatureVC *newFeatureVC = [[XZMCoreNewFeatureVC alloc] init];
    
    newFeatureVC.imageNames = imageNames;
    
    //控制器准备
    configurationBlock([newFeatureVC vcPrepare]);
    
    //显示了版本新特性，保存版本号
    [newFeatureVC saveVersion];
    
    //记录block
    newFeatureVC.enterBlock =enterBlock;
    
    return newFeatureVC;
}

// 初始化视频新特性界面
+ (instancetype)newFeatureVCWithPlayerURL:(NSURL *)URL enterBlock:(void(^)())enterBlock configuration:(void (^)(AVPlayerLayer *playerLayer))configurationBlock
{
    XZMCoreNewFeatureVC *newFeatureVC = [[XZMCoreNewFeatureVC alloc] init];
    
    // 初始化播放器
    configurationBlock([newFeatureVC playerWith:URL]);
    
    // 监听通知
    [newFeatureVC setUpNotification];
    
    //显示了版本新特性，保存版本号
    [newFeatureVC saveVersion];
    
    //记录block
    newFeatureVC.enterBlock = enterBlock;
    
    return newFeatureVC;
}

// 监听通知
- (void)setUpNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerLayer.player.currentItem cancelPendingSeeks];
    [self.playerLayer.player.currentItem.asset cancelLoading];
}

#pragma mark - 初始化播放器
- (AVPlayerLayer *)playerWith:(NSURL *)URL
{
    if (_playerLayer == nil) {
        
        // 2.创建AVPlayerItem
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:URL];
        
        // 3.创建AVPlayer
        AVPlayer * player = [AVPlayer playerWithPlayerItem:item];
        
        // 4.添加AVPlayerLayer
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        
        playerLayer.frame = self.view.bounds;
        [self.view.layer addSublayer:playerLayer];
        [player play];
    }
    return _playerLayer;
}

// 显示了版本新特性，保存版本号
- (void)saveVersion{
    
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    
    //保存版本号
    [CoreArchive setStr:versionValueStringForSystemNow key:NewFeatureVersionKey];
    
}


// 控制器准备
- (UIButton *)vcPrepare{
    
    //添加scrollView
    NewFeatureScrollView *scrollView = [[NewFeatureScrollView alloc] init];
    _scrollView = scrollView;
    
    //添加
    [self.view addSubview:scrollView];
    
    //添加约束
    scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    //添加图片
    return [self imageViewsPrepare];
    
    
}

// 添加图片
- (UIButton *)imageViewsPrepare{
    
    [self.imageNames enumerateObjectsUsingBlock:^(NSString *imageName, NSUInteger idx, BOOL *stop) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        
        //设置图片
        imageV.image = [UIImage imageNamed:imageName];
        
        //记录tag
        imageV.tag = idx;
        
        [_scrollView addSubview:imageV];
        
        if(idx == self.imageNames.count -1) {
            
            // 添加按钮
            _enterButton = [self setUpEnterButton:imageV];
            
        }
        
    }];
    
    return _enterButton;
}

/** 初始化按钮 */
- (UIButton *)setUpEnterButton:(UIImageView *)imageView
{
    imageView.userInteractionEnabled = YES;
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [imageView addSubview:enterButton];
    [enterButton addTarget:self action:@selector(chickEnterButton) forControlEvents:UIControlEventTouchUpInside];
    return enterButton;
}

- (void)gestureAction:(UITapGestureRecognizer *)tap{
    
    UIView *tapView = tap.view;
    
    //禁用
    tapView.userInteractionEnabled = NO;
    
    if(UIGestureRecognizerStateEnded == tap.state) [self dismiss];
}

- (void)chickEnterButton
{
    [self dismiss];
}

- (void)dismiss{
    
    if(self.enterBlock != nil) _enterBlock();
}

// 是否应该显示版本新特性页面
+ (BOOL)canShowNewFeature{
    
    //系统直接读取的版本号
    NSString *versionValueStringForSystemNow=[[NSBundle mainBundle].infoDictionary valueForKey:(NSString *)kCFBundleVersionKey];
    
    //读取本地版本号
    NSString *versionLocal = [CoreArchive strForKey:NewFeatureVersionKey];
    
    if(versionLocal!=nil && [versionValueStringForSystemNow isEqualToString:versionLocal]){//说明有本地版本记录，且和当前系统版本一致
        
        return NO;
        
    }else{ // 无本地版本记录或本地版本记录与当前系统版本不一致
        
        //保存
        [CoreArchive setStr:versionValueStringForSystemNow key:NewFeatureVersionKey];
        
        return YES;
    }
}

@end
