//
//  XMScreenToward.m
//  TowardComponent
//
//  Created by xiaomai on 2022/2/14.
//

#import "XMScreenToward.h"
#import <CoreMotion/CoreMotion.h>

#define haveTowardDown @"HAVETOWARDDOWN"//本地缓存是否屏幕朝下对key
#define haveTowardUp @"HAVETOWARDUP"//本地缓存是否屏幕朝上对应的key

static const NSTimeInterval UpdateInterval = 0.5;//设置刷新速度(也就是每隔多长时间取得一次数据)
static const double Grativy = 0.85;

@interface XMScreenToward()
@property(nonatomic,strong)CMMotionManager *manager;
@property(nonatomic,assign)double aZ;
@property(nonatomic,assign)id<TowardDelegate> towardDelegate;
@end


@implementation XMScreenToward

+ (instancetype)sharedInstance {
    static XMScreenToward* instance;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        instance = [[XMScreenToward alloc] init];
    });
    return instance;
}

- (void)registerHandler:(id<TowardDelegate>)handler {
    self.towardDelegate = handler;
}

- (void)startHandling {
    if (!self.manager) {//初始化CMMotionManager
        self.manager = [[CMMotionManager alloc] init];
    }
    
    if (self.manager.deviceMotionAvailable) {//如果可以获取设备的动作信息
        [self pushApproach];
    } else {
        if (self.towardDelegate && [self.towardDelegate respondsToSelector:@selector(deviceMotionNotAvailable)])[self.towardDelegate deviceMotionNotAvailable];
    }
}

- (void)stopHandling {
    if (!self.manager) {
        return;
    }
    
    if (self.manager.deviceMotionActive) {
        [self.manager stopDeviceMotionUpdates];
    }
}

- (void)pushApproach {
    XMScreenToward *__weak weakSelf = self;
    self.manager.deviceMotionUpdateInterval = UpdateInterval;//设置刷新速度
    [self.manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        //CMAcceleration：加速器 设备在各轴方向上检测到的加速度值（包含重力加速度的影响），以重力加速度g为单位
        CMAcceleration accrleration = motion.gravity;
        weakSelf.aZ = accrleration.z;//z是z轴上的重力分量
        
        if ([self isScrrenFaceDown] && self.towardDelegate && [self.towardDelegate respondsToSelector:@selector(deviceMotionToWardDown)]) {
            [self.towardDelegate deviceMotionToWardDown];

            [self resetTowardDownYes];
            [self resetTowardUpNo];
        }

        if ([self isScrrenFaceUp] && self.towardDelegate && [self.towardDelegate respondsToSelector:@selector(deviceMotionToWardUp)]) {
            [self.towardDelegate deviceMotionToWardUp];

            [self resetTowardDownNo];
            [self resetTowardUpYes];
        }
     }];
}

- (BOOL)isFaceDown {
    if (self.aZ >= Grativy) {
        return YES;
    }
    return NO;
}

//结合是否有朝下缓存+屏幕朝下
- (BOOL)isScrrenFaceDown {
    XMScreenToward *__weak weakSelf = self;
    if (!weakSelf.isTowardDown && weakSelf.isFaceDown) {
        return YES;
    }
    return NO;
}

//结合是否有朝上缓存+屏幕朝上
- (BOOL)isScrrenFaceUp {
    XMScreenToward *__weak weakSelf = self;
    if (!weakSelf.isTowardUp && !weakSelf.isFaceDown) {
        return YES;
    }
    return NO;
}

//查询本地缓存是否有屏幕朝下缓存
- (BOOL)isTowardDown {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:haveTowardDown]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)resetTowardDownYes {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:haveTowardDown];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- (void)resetTowardDownNo {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:haveTowardDown];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//查询本地缓存是否有屏幕朝上缓存
- (BOOL)isTowardUp {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:haveTowardUp]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)resetTowardUpYes {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:haveTowardUp];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetTowardUpNo {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:haveTowardUp];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
