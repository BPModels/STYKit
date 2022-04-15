//
//  TYNetworkAccessibity_ty.h
//  STYKit
//
//  Created by apple on 2022/4/14.
//

#import <Foundation/Foundation.h>

extern NSString * const TYNetworkAccessibityChangedNotification;

typedef NS_ENUM(NSUInteger, TYNetworkAccessibleState_ty) {
    TYNetworkChecking_ty  = 0,
    TYNetworkUnknown_ty     ,
    TYNetworkAccessible_ty  ,
    TYNetworkRestricted_ty  ,
};

typedef void (^NetworkAccessibleStateNotifier)(TYNetworkAccessibleState_ty state);


@interface TYNetworkAccessibity_ty : NSObject

/**
 开启 ZYNetworkAccessibity
 */
+ (void)start;

/**
 停止 ZYNetworkAccessibity
 */
+ (void)stop;

/**
 当判断网络状态为 ZYNetworkRestricted 时，提示用户开启网络权限
 */
+ (void)setAlertEnable:(BOOL)setAlertEnable;

/**
  通过 block 方式监控网络权限变化。
 */
+ (void)setStateDidUpdateNotifier:(void (^)(TYNetworkAccessibleState_ty))block;

/**
 返回的是最近一次的网络状态检查结果，若距离上一次检测结果短时间内网络授权状态发生变化，该值可能会不准确。
 */
+ (TYNetworkAccessibleState_ty)currentState;

@end
