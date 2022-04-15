//
//  TYAESCryptor_ty.h
//  STYKit
//
//  Created by apple on 2022/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYAESCryptor_ty : NSObject

+(NSData*) generateRandom128BitAESKey_ty;

+(NSData *) AES128EncryptWithKey_ty:(NSData *)key data:(NSData*)data;

+(NSData *) AES128DecryptWithKey_ty:(NSData *)key data:(NSData*)data;

@end

NS_ASSUME_NONNULL_END
