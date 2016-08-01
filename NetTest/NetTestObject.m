//
//  NetTestObject.m
//  NetTest
//
//  Created by 廖挺 on 16/7/29.
//
//

#import "NetTestObject.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface NetTestObject () {
    Reachability *_obsearverReach;
}
@property (copy, nonatomic) NetworkStatusChangedBlock networkStatusChangeBlock;
@end

@implementation NetTestObject

+ (instancetype)shareTestObject {
    static NetTestObject *testObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        testObject = [[self alloc] init];
    });
    return testObject;
}

- (instancetype)init {
    if (self = [super init]) {
        _currentTestStatus = NetTestStatusNull;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    }
    return self;
}

- (NetTestStatus)parseReachabilityObject:(Reachability *)reachObj {
    NetTestStatus testStatus;
    NSParameterAssert([reachObj isKindOfClass: [Reachability class]]);
    NetworkStatus status = [reachObj currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            testStatus = NetTestStatusNull;
            NSLog(@"没有网络");
            break;
        case ReachableViaWiFi:
            testStatus = NetTestStatusWifi;
            NSLog(@"无线网络");
            break;
        case ReachableViaWWAN: {
            CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
            if ([telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE]) {
                testStatus = NetTestStatus4G;
                NSLog(@"4G");
            }else if([telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyGPRS] || [telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyeHRPD]){
                testStatus = NetTestStatus2G;
                NSLog(@"2G");
            }else{
                testStatus = NetTestStatus3G;
                NSLog(@"3G");
            }
        }
            break;
        default:
            testStatus = NetTestStatusUnknow;
            NSLog(@"未知");
            break;
    }
    return testStatus;
}

- (void)addNetworkStatusChangeWithNetworkStatusChangedBlock:(NetworkStatusChangedBlock)networkStatusChangedBlock {
    if (!_obsearverReach) {
        if (networkStatusChangedBlock) {
            _networkStatusChangeBlock = networkStatusChangedBlock;
        }
        _obsearverReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
        [_obsearverReach startNotifier];
    }
}

- (void)reachabilityChanged:(NSNotification *)noti {
    Reachability *curReach = [noti object];
    NetTestStatus status = [self parseReachabilityObject:curReach];
    if (status != _currentTestStatus) {
        _currentTestStatus = status;
        if (_networkStatusChangeBlock) {
            _networkStatusChangeBlock(_currentTestStatus);
        }
    }
}

- (void)dealloc {
    if (_obsearverReach) {
        [_obsearverReach stopNotifier];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
