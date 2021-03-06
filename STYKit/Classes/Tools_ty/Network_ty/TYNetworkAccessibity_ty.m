//
//  TYNetworkAccessibity_ty.m
//  STYKit
//
//  Created by apple on 2022/4/14.
//

#import "TYNetworkAccessibity_ty.h"
#import <UIKit/UIKit.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCellularData.h>
#import <SystemConfiguration/SystemConfiguration.h>

#import <netdb.h>
#import <sys/socket.h>
#import <netinet/in.h>

// ifaddrs
#import <ifaddrs.h>

// inet
#import <arpa/inet.h>

NSString * const TYNetworkAccessibityChanged_tyNotification = @"TYNetworkAccessibityChanged_tyNotification";

typedef NS_ENUM(NSInteger, ZYNetworkType_ty) {
    ZYNetworkTypeUnknown_ty ,
    ZYNetworkTypeOffline_ty ,
    ZYNetworkTypeWiFi_ty    ,
    ZYNetworkTypeCellularData_ty ,
};

@interface TYNetworkAccessibity_ty(){
    SCNetworkReachabilityRef _reachabilityRef_ty;
    CTCellularData *_cellularData_ty;
    NSMutableArray *_becomeActiveCallbacks_ty;
    TYNetworkAccessibleState_ty _previousState_ty;
    UIAlertController *_alertController_ty;
    BOOL _automaticallyAlert_ty;
    NetworkAccessibleStateNotifier _networkAccessibleStateDidUpdateNotifier_ty;
    BOOL _checkActiveLaterWhenDidBecomeActive_ty;
    BOOL _checkingActiveLater_ty;
}


@end

@interface TYNetworkAccessibity_ty()
@end



@implementation TYNetworkAccessibity_ty

#pragma mark - Public

+ (void)start_ty {
    [[self sharedInstance_ty] setupNetworkAccessibity_ty];
}

+ (void)stop_ty {
    [[self sharedInstance_ty] cleanNetworkAccessibity_ty];
}

+ (void)setAlertEnable_ty:(BOOL)setAlertEnable_ty {
    [self sharedInstance_ty]->_automaticallyAlert_ty = setAlertEnable_ty;
}


+ (void)setStateDidUpdateNotifier_ty:(void (^)(TYNetworkAccessibleState_ty))block_ty {
    [[self sharedInstance_ty] monitorNetworkAccessibleStateWithCompletionBlock_ty:block_ty];
}

+ (TYNetworkAccessibleState_ty)currentState_ty {
    return [[self sharedInstance_ty] currentState_ty];
}

#pragma mark - Public entity method


+ (TYNetworkAccessibity_ty *)sharedInstance_ty {
    static TYNetworkAccessibity_ty * instance_ty = nil;
    static dispatch_once_t onceToken_ty;
    dispatch_once(&onceToken_ty, ^{
        instance_ty = [[self alloc] init];
    });
    return instance_ty;
}


- (void)setNetworkAccessibleStateDidUpdateNotifier_ty:(NetworkAccessibleStateNotifier)networkAccessibleStateDidUpdateNotifier_ty {
    _networkAccessibleStateDidUpdateNotifier_ty = [networkAccessibleStateDidUpdateNotifier_ty copy];
    [self startCheck_ty];
}



- (void)monitorNetworkAccessibleStateWithCompletionBlock_ty:(void (^)(TYNetworkAccessibleState_ty))block_ty {
    _networkAccessibleStateDidUpdateNotifier_ty = [block_ty copy];
}

- (TYNetworkAccessibleState_ty)currentState_ty {
    return _previousState_ty;
}

#pragma mark - Life cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - NSNotification

- (void)setupNetworkAccessibity_ty {
    
    if (_reachabilityRef_ty || _cellularData_ty) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive_ty) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive_ty) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    _reachabilityRef_ty = SCNetworkReachabilityCreateWithName(NULL, "223.5.5.5");
    // ??????????????????????????????????????????
    SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef_ty, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    

    _becomeActiveCallbacks_ty = [NSMutableArray array];
    
    BOOL firstRun_ty = ({
        static NSString * RUN_FLAG_ty = @"TYNetworkAccessibityRunFlag_ty";
        BOOL value_ty = [[NSUserDefaults standardUserDefaults] boolForKey:RUN_FLAG_ty];
        if (!value_ty) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:RUN_FLAG_ty];
        }
        !value_ty;
    });
    
    dispatch_block_t startNotifier_ty = ^{
        [self startReachabilityNotifier_ty];
        
        [self startCellularDataNotifier_ty];
    };
    
    if (firstRun_ty) {
        // ????????????????????????????????????????????????????????????????????????????????????????????????
        // ????????????ReachabilityNotifier ?????????????????????????????????????????????, CellularDataNotifier ??????????????????
        // ???????????? 3 ?????????????????????????????????????????????????????????????????????
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self waitActive_ty:^{
                startNotifier_ty();
            }];
        });
    } else {
        startNotifier_ty();
    }
    
    
}

- (void)cleanNetworkAccessibity_ty {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _cellularData_ty.cellularDataRestrictionDidUpdateNotifier = nil;
    _cellularData_ty = nil;
    
    SCNetworkReachabilityUnscheduleFromRunLoop(_reachabilityRef_ty, CFRunLoopGetMain(), kCFRunLoopCommonModes);
    _reachabilityRef_ty = nil;
    
    [self cancelEnsureActive_ty];
    [self hideNetworkRestrictedAlert_ty];
    
    [_becomeActiveCallbacks_ty removeAllObjects];
    _becomeActiveCallbacks_ty = nil;
    
    _previousState_ty = TYNetworkChecking_ty;
    
    _checkActiveLaterWhenDidBecomeActive_ty = NO;
    _checkingActiveLater_ty = NO;
    
}


- (void)applicationWillResignActive_ty {
    [self hideNetworkRestrictedAlert_ty];
    
    if (_checkingActiveLater_ty) {
        [self cancelEnsureActive_ty];
        _checkActiveLaterWhenDidBecomeActive_ty = YES;
    }
}

- (void)applicationDidBecomeActive_ty {
    
    if (_checkActiveLaterWhenDidBecomeActive_ty) {
        [self checkActiveLater_ty];
        _checkActiveLaterWhenDidBecomeActive_ty = NO;
    }
}


#pragma mark - Active Checker

// ???????????? app ??????????????????????????????????????????????????????????????? app ???????????????????????????????????????
// ????????????????????????2 ?????????????????????????????????????????? XXX ??????????????????????????? applicationState ??? UIApplicationStateInactive???

- (void)waitActive_ty:(dispatch_block_t)block_ty {
    [_becomeActiveCallbacks_ty addObject:[block_ty copy]];
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
       _checkActiveLaterWhenDidBecomeActive_ty = YES;
    } else {
        [self checkActiveLater_ty];
    }
}

- (void)checkActiveLater_ty {
    _checkingActiveLater_ty = YES;
    [self performSelector:@selector(ensureActive_ty) withObject:nil afterDelay:2 inModes:@[NSRunLoopCommonModes]];
}

- (void)ensureActive_ty {
    _checkingActiveLater_ty = NO;
    for (dispatch_block_t block_ty in _becomeActiveCallbacks_ty) {
        block_ty();
    }
    [_becomeActiveCallbacks_ty removeAllObjects];
}

- (void)cancelEnsureActive_ty {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(ensureActive_ty) object:nil];
}


#pragma mark - Reachability

static void ReachabilityCallback_ty(SCNetworkReachabilityRef target_ty, SCNetworkReachabilityFlags flags_ty, void* info_ty) {
    TYNetworkAccessibity_ty *networkAccessibity_ty = (__bridge TYNetworkAccessibity_ty *)info_ty;
    if (![networkAccessibity_ty isKindOfClass: [TYNetworkAccessibity_ty class]]) {
        return;
    }
    [networkAccessibity_ty startCheck_ty];
}

// ??????????????? Wi-Fi ????????? ????????????????????????????????????????????? Wi-Fi?????????????????????????????????????????????????????????????????????????????????
- (void)startReachabilityNotifier_ty {
    SCNetworkReachabilityContext context_ty = {0, (__bridge void *)(self), NULL, NULL, NULL};
    if (SCNetworkReachabilitySetCallback(_reachabilityRef_ty, ReachabilityCallback_ty, &context_ty)) {
        SCNetworkReachabilityScheduleWithRunLoop(_reachabilityRef_ty, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
    }
}

- (void)startCellularDataNotifier_ty {
    __weak __typeof(self)weakSelf = self;
    self->_cellularData_ty = [[CTCellularData alloc] init];
    self->_cellularData_ty.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state_ty) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf startCheck_ty];
        });
    };
}

- (BOOL)currentReachable_ty {
    SCNetworkReachabilityFlags flags_ty;
    if (SCNetworkReachabilityGetFlags(self->_reachabilityRef_ty, &flags_ty)) {
        if ((flags_ty & kSCNetworkReachabilityFlagsReachable) == 0) {
            return NO;
        } else {
            return YES;
        }
    }
    return NO;
}


#pragma mark - Check Accessibity

- (void)startCheck_ty {
    if ([UIDevice currentDevice].systemVersion.floatValue < 10.0 || [self currentReachable_ty]) {
        
        /* iOS 10 ?????? ??????????????????????????? **/
        
        /* ?????? currentReachable ???????????????????????? YES ????????????
         1. ??????????????? ???WALN ????????????????????????????????????????????????????????????
         2. ??????????????? ???WALN???????????? WALN ??????????????????
         
         ???????????????????????????????????????????????? TYNetworkAccessible_ty
         **/
        
        [self notiWithAccessibleState_ty:TYNetworkAccessible_ty];
        return;
    }
    
    CTCellularDataRestrictedState state_ty = _cellularData_ty.restrictedState;
    
    switch (state_ty) {
        case kCTCellularDataRestricted: {// ?????? API ?????? ???????????????????????????
            
            [self getCurrentNetworkType_ty:^(ZYNetworkType_ty type_ty) {
                /*  ?????????????????????????????? ??? WLAN ???????????????????????? ?????????????????????**/
                
                if (type_ty == ZYNetworkTypeCellularData_ty || type_ty == ZYNetworkTypeWiFi_ty) {
                    [self notiWithAccessibleState_ty:TYNetworkRestricted_ty];
                } else {  // ???????????????????????????????????????
                    [self notiWithAccessibleState_ty:TYNetworkUnknown_ty];
                }
            }];
            
            break;
        }
        case kCTCellularDataNotRestricted: // ?????? API ?????????????????????????????????????????????????????? Wi-Fi ??????????????????
            [self notiWithAccessibleState_ty:TYNetworkAccessible_ty];
            break;
        case kCTCellularDataRestrictedStateUnknown: {
            // CTCellularData ????????????????????????????????????????????? kCTCellularDataRestrictedStateUnknown ???????????????????????????
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startCheck_ty];
            });
            break;
        }
        default:
            break;
    };
}


- (void)getCurrentNetworkType_ty:(void(^)(ZYNetworkType_ty))block_ty {
    if ([self isWiFiEnable_ty]) {
        return block_ty(ZYNetworkTypeWiFi_ty);
    }
    ZYNetworkType_ty type_ty = [self getNetworkTypeFromStatusBar_ty];
    if (type_ty == ZYNetworkTypeWiFi_ty) { // ????????????????????????????????? Wi-Fi ???????????????????????????????????????????????????
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self getCurrentNetworkType_ty:block_ty];
        });
    } else {
        block_ty(type_ty);
    }
}

- (ZYNetworkType_ty)getNetworkTypeFromStatusBar_ty {
    NSInteger type_ty = 0;
    @try {
        UIApplication *app_ty = [UIApplication sharedApplication];
        UIView *statusBar_ty = [app_ty valueForKeyPath:@"statusBar"];
        
        if (statusBar_ty == nil ){
            return ZYNetworkTypeUnknown_ty;
        }
        
        BOOL isModernStatusBar_ty = [statusBar_ty isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")];
        
        if (isModernStatusBar_ty) { // ??? iPhone X ??? statusBar ?????? UIStatusBar_Modern ?????????????????????
            id currentData_ty = [statusBar_ty valueForKeyPath:@"statusBar.currentData"];
            BOOL wifiEnable_ty = [[currentData_ty valueForKeyPath:@"_wifiEntry.isEnabled"] boolValue];
            
            // ??????????????? _cellularEntry.isEnabled ?????????????????????????????????????????? YES
            
            BOOL cellularEnable_ty = [[currentData_ty valueForKeyPath:@"_cellularEntry.type"] boolValue];
            return wifiEnable_ty ? ZYNetworkTypeWiFi_ty :
                    cellularEnable_ty ? ZYNetworkTypeCellularData_ty : ZYNetworkTypeOffline_ty;
        } else { // ????????? statusBar
            NSArray *children_ty = [[statusBar_ty valueForKeyPath:@"foregroundView"] subviews];
            for (id child_ty in children_ty) {
                if ([child_ty isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
                    type_ty = [[child_ty valueForKeyPath:@"dataNetworkType"] intValue];
                    // type == 1  => 2G
                    // type == 2  => 3G
                    // type == 3  => 4G
                    // type == 4  => LTE
                    // type == 5  => Wi-Fi
                }
            }
            return type_ty == 0 ? ZYNetworkTypeOffline_ty :
                   type_ty == 5 ? ZYNetworkTypeWiFi_ty    : ZYNetworkTypeCellularData_ty;
        }
    } @catch (NSException *exception_ty) {
        
    }
    return 0;
}


/**
 ??????????????????????????? Wi-Fi
 */
- (BOOL)isWiFiEnable_ty {
    return [self wiFiIPAddress_ty].length > 0;
}

- (NSString *)wiFiIPAddress_ty {
    @try {
        NSString *ipAddress_ty;
        struct ifaddrs *interfaces_ty;
        struct ifaddrs *temp_ty;
        int Status_ty = 0;
        Status_ty = getifaddrs(&interfaces_ty);
        if (Status_ty == 0) {
            temp_ty = interfaces_ty;
            while(temp_ty != NULL) {
                if(temp_ty->ifa_addr->sa_family == AF_INET) {
                    if([[NSString stringWithUTF8String:temp_ty->ifa_name] isEqualToString:@"en0"]) {
                        ipAddress_ty = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_ty->ifa_addr)->sin_addr)];
                    }
                }
                temp_ty = temp_ty->ifa_next;
            }
        }
        
        freeifaddrs(interfaces_ty);
        
        if (ipAddress_ty == nil || ipAddress_ty.length <= 0) {
            return nil;
        }
        return ipAddress_ty;
    }
    @catch (NSException *exception_ty) {
        return nil;
    }
}

#pragma mark - Callback

- (void)notiWithAccessibleState_ty:(TYNetworkAccessibleState_ty)state_ty {
    if (_automaticallyAlert_ty) {
        if (state_ty == TYNetworkRestricted_ty) {
                [self showNetworkRestrictedAlert_ty];
        } else {
            [self hideNetworkRestrictedAlert_ty];
        }
    }
    
    if (state_ty != _previousState_ty) {
        _previousState_ty = state_ty;
        
        if (_networkAccessibleStateDidUpdateNotifier_ty) {
            _networkAccessibleStateDidUpdateNotifier_ty(state_ty);
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:TYNetworkAccessibityChanged_tyNotification object:nil];
        
    }
}


- (void)showNetworkRestrictedAlert_ty {
    if (self.alertController_ty.presentingViewController == nil && ![self.alertController_ty isBeingPresented]) {
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.alertController_ty animated:YES completion:nil];
    }
}

- (void)hideNetworkRestrictedAlert_ty {
    [_alertController_ty dismissViewControllerAnimated:YES completion:nil];
}

- (UIAlertController *)alertController_ty {
    if (!_alertController_ty) {
        
        _alertController_ty = [UIAlertController alertControllerWithTitle:@"?????????????????????" message:@"??????????????????????????????????????????????????????????????????????????????" preferredStyle:UIAlertControllerStyleAlert];
        
        [_alertController_ty addAction:[UIAlertAction actionWithTitle:@"?????????" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action_ty) {
            NSURL *settingsURL_ty = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if([[UIApplication sharedApplication] canOpenURL:settingsURL_ty]) {
                [[UIApplication sharedApplication] openURL:settingsURL_ty options:@{} completionHandler:^(BOOL success_ty) {
                    if (success_ty) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"] options:@{} completionHandler:nil];
                    }
                }];
            }
        }]];
        
        [_alertController_ty addAction:[UIAlertAction actionWithTitle:@"??????" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action_ty) {
            [self hideNetworkRestrictedAlert_ty];
        }]];
    }
    return _alertController_ty;
}



@end
