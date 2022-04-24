//
//  ZooNSLogManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>
#import "ZooNSLogModel.h"


@interface ZooNSLogManager : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) NSMutableArray<ZooNSLogModel *> *dataArray;

- (void)startNSLogMonitor;

- (void)stopNSLogMonitor;

- (void)addNSLog:(NSString *)log;
@end
