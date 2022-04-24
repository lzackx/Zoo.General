//
//  ZooDBManager.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooDBManager : NSObject

+ (ZooDBManager *)shareManager;

@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, copy) NSString *tableName;

- (NSArray *)tablesAtDB;
- (NSArray *)dataAtTable;

@end

NS_ASSUME_NONNULL_END
