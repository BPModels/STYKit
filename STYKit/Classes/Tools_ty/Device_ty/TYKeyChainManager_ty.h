//
//  TYKeyChainManager_ty.h
//  STYKit
//
//  Created by apple on 2022/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYKeyChainManager_ty : NSObject

+ (void)save:(NSString *)service data:(id)data;

+ (id)load:(NSString *)service;

+ (void)delete:(NSString *)service;

@end

NS_ASSUME_NONNULL_END
