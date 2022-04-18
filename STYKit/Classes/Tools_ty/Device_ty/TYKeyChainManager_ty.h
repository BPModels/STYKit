//
//  TYKeyChainManager_ty.h
//  STYKit
//
//  Created by apple on 2022/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYKeyChainManager_ty : NSObject

+ (void)saved_ty:(NSString *)service_ty data_ty:(id)data_ty;

+ (id)load_ty:(NSString *)service_ty;

+ (void)delete_ty:(NSString *)service_ty;

@end

NS_ASSUME_NONNULL_END
