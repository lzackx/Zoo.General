//
//  ZooCacheManager.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooCacheManager+General.h"
#import <Zoo/ZooManager.h>
#import <Zoo/ZooDefine.h>


static NSString * const kZooCrashKey = @"zoo_crash_key";
static NSString * const kZooNSLogKey = @"zoo_nslog_key";
static NSString * const kZooRouterhistoricalRecord = @"zoo_router_historical_record";
static NSString * const kZooH5historicalRecord = @"zoo_h5_historical_record";


@implementation ZooCacheManager (General)

- (void)saveCrashSwitch:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kZooCrashKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)crashSwitch{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZooCrashKey];
}

- (void)saveNSLogSwitch:(BOOL)on{
    [[NSUserDefaults standardUserDefaults] setBool:on forKey:kZooNSLogKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)nsLogSwitch{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kZooNSLogKey];
}

- (NSArray<NSString *> *)h5historicalRecord {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kZooH5historicalRecord];
}

- (void)saveH5historicalRecordWithText:(NSString *)text {
    /// 过滤异常数据
    if (!text || text.length <= 0) { return; }

    NSArray *records = [self h5historicalRecord];

    NSMutableArray *muarr = [NSMutableArray arrayWithArray:records];

    /// 去重
    if ([muarr containsObject:text]) {
        if ([muarr.firstObject isEqualToString:text]) {
            return;
        }
        [muarr removeObject:text];
    }
    [muarr insertObject:text atIndex:0];

    /// 限制数量
    if (muarr.count > 10) { [muarr removeLastObject]; }

    [[NSUserDefaults standardUserDefaults] setObject:muarr.copy forKey:kZooH5historicalRecord];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearAllH5historicalRecord {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZooH5historicalRecord];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearH5historicalRecordWithText:(NSString *)text {
    /// 过滤异常数据
    if (!text || text.length <= 0) { return; }
    NSArray *records = [self h5historicalRecord];
    /// 不包含
    if (![records containsObject:text]) { return; }
    NSMutableArray *muarr = [NSMutableArray array];
    if (records && records.count > 0) { [muarr addObjectsFromArray:records]; }
    [muarr removeObject:text];


    if (muarr.count > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:muarr.copy forKey:kZooH5historicalRecord];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZooH5historicalRecord];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray<NSString *> *)routerHistoricalRecord {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kZooRouterhistoricalRecord];
}

- (void)saveRouterHistoricalRecordWithText:(NSString *)text {
    /// 过滤异常数据
    if (!text || text.length <= 0) { return; }

    NSArray *records = [self routerHistoricalRecord];

    NSMutableArray *muarr = [NSMutableArray arrayWithArray:records];

    /// 去重
    if ([muarr containsObject:text]) {
        if ([muarr.firstObject isEqualToString:text]) {
            return;
        }
        [muarr removeObject:text];
    }
    [muarr insertObject:text atIndex:0];

    /// 限制数量
    if (muarr.count > 10) { [muarr removeLastObject]; }

    [[NSUserDefaults standardUserDefaults] setObject:muarr.copy forKey:kZooRouterhistoricalRecord];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearAllRouterHistoricalRecord {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZooRouterhistoricalRecord];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearRouterHistoricalRecordWithText:(NSString *)text {
    /// 过滤异常数据
    if (!text || text.length <= 0) { return; }
    NSArray *records = [self routerHistoricalRecord];
    /// 不包含
    if (![records containsObject:text]) { return; }
    NSMutableArray *muarr = [NSMutableArray array];
    if (records && records.count > 0) { [muarr addObjectsFromArray:records]; }
    [muarr removeObject:text];

    if (muarr.count > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:muarr.copy forKey:kZooRouterhistoricalRecord];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kZooRouterhistoricalRecord];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
