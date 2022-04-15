//
//  NSData+Extension_ty.h
//  STYKit
//
//  Created by apple on 2022/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (Extension_ty)

+(NSData*)random_ty:(NSUInteger)size;

// 16进制转NSData
+ (NSData*)convertHexStrToData_ty:(NSString*)str;

// data转16进制
- (NSString *)convertDataToHexStr_ty;
@end

NS_ASSUME_NONNULL_END
