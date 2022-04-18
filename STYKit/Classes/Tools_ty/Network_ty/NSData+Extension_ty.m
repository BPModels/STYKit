//
//  NSData+Extension_ty.m
//  STYKit
//
//  Created by apple on 2022/4/15.
//

#import "NSData+Extension_ty.h"

//https://github.com/cstaylor/iOS-Crypto-API

@implementation NSData (Extension_ty)

+(NSData*)random_ty:(NSUInteger)size_ty
{
    NSData * ret_val_ty = nil;
    if ( size_ty == 0 ) errno = EINVAL;
    else {
        NSUInteger byte_length_ty = size_ty * sizeof(uint8_t);
        uint8_t * data_ty = malloc( byte_length_ty );
        memset ( (void*)data_ty, 0x0, size_ty );
        OSStatus err_ty = SecRandomCopyBytes (kSecRandomDefault, byte_length_ty, data_ty );
        if ( !err_ty ) ret_val_ty = [NSData dataWithBytes:data_ty length:byte_length_ty];
        free ( data_ty );
    }
    return ret_val_ty;
}

// 16进制转NSData
+ (NSData*)convertHexStrToData_ty:(NSString*)str_ty {
    if (!str_ty || [str_ty length] ==0) {
        return nil;
    }
   
    NSMutableData *hexData_ty = [[NSMutableData alloc]initWithCapacity:8];
    NSRange range_ty;
    if ([str_ty length] %2==0) {
        range_ty = NSMakeRange(0,2);
    } else {
        range_ty = NSMakeRange(0,1);
    }
    for (NSInteger i_ty = range_ty.location; i_ty < [str_ty length]; i_ty +=2) {
        unsigned int anInt_ty;
        NSString *hexCharStr_ty = [str_ty substringWithRange:range_ty];
        NSScanner *scanner_ty = [[NSScanner alloc]initWithString:hexCharStr_ty];
       
        [scanner_ty scanHexInt:&anInt_ty];
        NSData *entity_ty = [[NSData alloc]initWithBytes:&anInt_ty length:1];
        [hexData_ty appendData:entity_ty];
       
        range_ty.location+= range_ty.length;
        range_ty.length=2;
    }
    return hexData_ty;
}

- (NSString *)convertDataToHexStr_ty{
    if (!self || [self length] == 0) {
        return @"";
    }
    NSMutableString *string_ty = [[NSMutableString alloc] initWithCapacity:[self length]];
    
    [self enumerateByteRangesUsingBlock:^(const void *bytes_ty, NSRange byteRange_ty, BOOL *stop_ty) {
        unsigned char *dataBytes_ty = (unsigned char*)bytes_ty;
        for (NSInteger i_ty = 0; i_ty < byteRange_ty.length; i_ty++) {
            NSString *hexStr_ty = [NSString stringWithFormat:@"%x", (dataBytes_ty[i_ty]) & 0xff];
            if ([hexStr_ty length] == 2) {
                [string_ty appendString:hexStr_ty];
            } else {
                [string_ty appendFormat:@"0%@", hexStr_ty];
            }
        }
    }];
    return string_ty;
}


@end
