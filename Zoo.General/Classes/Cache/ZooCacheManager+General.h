//
//  ZooCacheManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>
#import <Zoo/ZooCacheManager.h>


@interface ZooCacheManager (General)

- (void)saveCrashSwitch:(BOOL)on;

- (BOOL)crashSwitch;

- (void)saveNSLogSwitch:(BOOL)on;

- (BOOL)nsLogSwitch;


/// 历史记录
- (NSArray<NSString *> *)routerHistoricalRecord;
- (void)saveRouterHistoricalRecordWithText:(NSString *)text;
- (void)clearAllRouterHistoricalRecord;
- (void)clearRouterHistoricalRecordWithText:(NSString *)text;

- (NSArray<NSString *> *)h5historicalRecord;
- (void)saveH5historicalRecordWithText:(NSString *)text;
- (void)clearAllH5historicalRecord;
- (void)clearH5historicalRecordWithText:(NSString *)text;

@end
