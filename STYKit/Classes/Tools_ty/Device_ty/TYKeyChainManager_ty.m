//
//  TYKeyChainManager_ty.m
//  STYKit
//
//  Created by apple on 2022/4/15.
//

#import "TYKeyChainManager_ty.h"
#import <Security/Security.h>

@implementation TYKeyChainManager_ty

+ (NSMutableDictionary *)getKeychainQuery_ty:(NSString *)service_ty {
    
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            
            service_ty, (__bridge id)kSecAttrService,
            
            service_ty, (__bridge id)kSecAttrAccount,
            
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            
            nil];
}

+ (void)save_ty:(NSString *)service_ty data_ty:(id)data_ty {
    
    //Get search dictionary
    
    NSMutableDictionary *keychainQuery_ty = [self getKeychainQuery_ty:service_ty];
    
    //Delete old item before add new item
    
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery_ty);
    
    //Add new object to search dictionary(Attention:the data format)
    
    [keychainQuery_ty setObject:[NSKeyedArchiver archivedDataWithRootObject:data_ty] forKey:(__bridge id)kSecValueData];
    
    //Add item to keychain with the search dictionary
    
    SecItemAdd((CFDictionaryRef)CFBridgingRetain(keychainQuery_ty), NULL);
    
}

+ (id)load_ty:(NSString *)service_ty {
    
    id ret_ty = nil;
    
    NSMutableDictionary *keychainQuery_ty = [self getKeychainQuery_ty:service_ty];
    
    //Configure the search setting
    
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    
    [keychainQuery_ty setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    [keychainQuery_ty setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef keyData_ty = NULL;
    
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery_ty, (CFTypeRef *)&keyData_ty) == noErr) {
        
        @try {
            
            ret_ty = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData_ty];
            
        } @catch (NSException *e_ty) {
            
            NSLog(@"Unarchive of %@ failed: %@", service_ty, e_ty);
            
        } @finally {
            
        }
        
    }
    
    if (keyData_ty)
        
        CFRelease(keyData_ty);
    
    return ret_ty;
    
}

+ (void)delete_ty:(NSString *)service_ty {
    
    NSMutableDictionary *keychainQuery_ty = [self getKeychainQuery_ty:service_ty];
    
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery_ty);
    
}


@end
