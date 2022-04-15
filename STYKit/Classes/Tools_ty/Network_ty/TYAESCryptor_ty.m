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


+(NSData *) AES128EncryptWithKey_ty:(NSData*)key data:(NSData*)data
{
    return [self doCipher_ty:data iv_ty:nil key_ty:key context_ty:kCCEncrypt error_ty:nil];
}


+(NSData *) AES128DecryptWithKey_ty:(NSData*)key data:(NSData*)data
{
    return [self doCipher_ty:data iv_ty:nil key_ty:key context_ty:kCCDecrypt error_ty:nil];
}

// http://stackoverflow.com/questions/13490716/ios-aes-wrong-implemetation/13490717#13490717
// http://stackoverflow.com/questions/23637597/ios-aes-encryption-fail-to-encrypt/23641521#23641521
 
+ (NSData *)doCipher_ty:(NSData *)dataIn
                  iv_ty:(NSData *)iv
                 key_ty:(NSData *)symmetricKey
             context_ty:(CCOperation)encryptOrDecrypt
               error_ty:(NSError **)error
{
    CCCryptorStatus ccStatus   = kCCSuccess;
    size_t          cryptBytes = 0;
    NSMutableData  *dataOut    = [NSMutableData dataWithLength:dataIn.length + kCCBlockSizeAES128];
    
    ccStatus = CCCrypt( encryptOrDecrypt,
                       kCCAlgorithmAES,
                       kCCOptionECBMode | kCCOptionPKCS7Padding,
                       symmetricKey.bytes,
                       symmetricKey.length,
                       iv.bytes,
                       dataIn.bytes,
                       dataIn.length,
                       dataOut.mutableBytes,
                       dataOut.length,
                       &cryptBytes);
    
    if (ccStatus == kCCSuccess) {
        dataOut.length = cryptBytes;
    }
    else {
        if (error) {
            *error = [NSError errorWithDomain:@"kEncryptionError"
                                         code:ccStatus
                                     userInfo:nil];
        }
        dataOut = nil;
    }
    
    return dataOut;
}



@end
