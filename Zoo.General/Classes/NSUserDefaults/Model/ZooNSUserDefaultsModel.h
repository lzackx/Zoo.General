//
//  ZooNSUserDefaultsModel.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooNSUserDefaultsModel : NSObject
@property (nonatomic, copy) NSString *key;
@property (nonatomic, strong) id value;
@end

NS_ASSUME_NONNULL_END
