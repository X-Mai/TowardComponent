//
//  XMScreenToward.h
//  TowardComponent
//
//  Created by xiaomai on 2022/2/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TowardDelegate <NSObject>
- (void)deviceMotionNotAvailable;//不能获取设备的动作信息
- (void)deviceMotionToWardDown;//设备屏幕朝下
- (void)deviceMotionToWardUp;//设备屏幕朝上
@end


@interface XMScreenToward : NSObject
+ (instancetype)sharedInstance;

- (void)registerHandler:(id<TowardDelegate>)handler;
- (void)startHandling;//打开监听(打开监听屏幕是否朝上朝下)
- (void)stopHandling;//停止监听(取消监听屏幕是否朝上朝下)
@end

NS_ASSUME_NONNULL_END
