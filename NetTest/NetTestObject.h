//
//  NetTestObject.h
//  NetTest
//
//  Created by 廖挺 on 16/7/29.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

typedef NS_ENUM(NSUInteger, NetTestStatus) {
    NetTestStatusNull,
    NetTestStatusWifi,
    NetTestStatus2G,
    NetTestStatus3G,
    NetTestStatus4G,
    NetTestStatusUnknow
};

typedef void(^NetworkStatusChangedBlock)(NetTestStatus status);

@interface NetTestObject : NSObject

@property (assign, nonatomic, readonly) NetTestStatus currentTestStatus;


- (void)addNetworkStatusChangeWithNetworkStatusChangedBlock:(NetworkStatusChangedBlock)networkStatusChangedBlock;
@end
