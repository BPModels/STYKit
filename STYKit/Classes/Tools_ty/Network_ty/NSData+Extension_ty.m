//
//  NSData+Extension_ty.m
//  STYKit
//
//  Created by apple on 2022/4/15.
//

#import "NSData+Extension_ty.h"

//https://github.com/cstaylor/iOS-Crypto-API

@implementation NSData (Extension_ty)

+(NSData*)random_ty:(NSUInteger)size
{
    NSData * ret_val = nil;
    if ( size == 0 ) errno = EINVAL;
    else {
        NSUInteger byte_length = size * sizeof(uint8_t);
        uint8_t * data = malloc( byte_length );
        memset ( (void*)data, 0x0, size );
        OSStatus err = SecRandomCopyBytes (kSecRandomDefault, byte_length, data );
        if ( !err ) ret_val = [NSData dataWithBytes:data length:byte_length];
        free ( data );
    }
    return ret_val;
}

// 16进制转NSData
+ (NSData*)convertHexStrToData_ty:(NSString*)str {
    if (!str || [str length] ==0) {
        return nil;
    }
   
    NSMutableData *hexData = [[NSMutableData alloc]initWithCapacity:8];
    NSRange range;
    if ([str length] %2==0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [str length]; i +=2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc]initWithString:hexCharStr];
       
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc]initWithBytes:&anInt length:1];
        [hexData appendData:entity];
       
        range.location+= range.length;
        range.length=2;
    }
    return hexData;
}

- (NSString *)convertDataToHexStr_ty{
    if (!self || [self length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[self length]];
    
    [self enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}


@end
