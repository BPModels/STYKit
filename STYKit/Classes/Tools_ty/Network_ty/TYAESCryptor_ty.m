//
//  TYAESCryptor_ty.m
//  STYKit
//
//  Created by apple on 2022/4/15.
//

#import "TYAESCryptor_ty.h"
#import <CommonCrypto/CommonCryptor.h>
#import "NSData+Extension_ty.h"

// https://github.com/Gurpartap/AESCrypt-ObjC


@implementation TYAESCryptor_ty

#pragma mark -

+(NSData*) generateRandom128BitAESKey_ty
{
    return [NSData random_ty: kCCKeySizeAES128];
}


+(NSData *) AES128EncryptWithKey_ty:(NSData*)key_ty data_ty:(NSData*)data_ty
{
    return [self doCipher_ty:data_ty iv_ty:nil key_ty:key_ty context_ty:kCCEncrypt error_ty:nil];
}


+(NSData *) AES128DecryptWithKey_ty:(NSData*)key_ty data_ty:(NSData*)data_ty
{
    return [self doCipher_ty:data_ty iv_ty:nil key_ty:key_ty context_ty:kCCDecrypt error_ty:nil];
}

// http://stackoverflow.com/questions/13490716/ios-aes-wrong-implemetation/13490717#13490717
// http://stackoverflow.com/questions/23637597/ios-aes-encryption-fail-to-encrypt/23641521#23641521
 
+ (NSData *)doCipher_ty:(NSData *)dataIn_ty
                  iv_ty:(NSData *)iv_ty
                 key_ty:(NSData *)symmetricKey_ty
             context_ty:(CCOperation)encryptOrDecrypt_ty
               error_ty:(NSError **)error_ty
{
    CCCryptorStatus ccStatus_ty   = kCCSuccess;
    size_t          cryptBytes_ty = 0;
    NSMutableData  *dataOut_ty    = [NSMutableData dataWithLength:dataIn_ty.length + kCCBlockSizeAES128];
    
    ccStatus_ty = CCCrypt( encryptOrDecrypt_ty,
                       kCCAlgorithmAES,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,
                       symmetricKey_ty.bytes,
                       symmetricKey_ty.length,
                       iv_ty.bytes,
                       dataIn_ty.bytes,
                       dataIn_ty.length,
                       dataOut_ty.mutableBytes,
                       dataOut_ty.length,
                       &cryptBytes_ty);
    
    if (ccStatus_ty == kCCSuccess) {
        dataOut_ty.length = cryptBytes_ty;
    }
    else {
        if (error_ty) {
            *error_ty = [NSError errorWithDomain:@"kEncryptionError"
                                         code:ccStatus_ty
                                     userInfo:nil];
        }
        dataOut_ty = nil;
    }
    
    return dataOut_ty;
}



@end
