//
//  ZooNSUserDefaultsEditViewController.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Zoo/Zoo.h>
#import <Zoo/ZooBaseViewController.h>
@class ZooNSUserDefaultsModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZooNSUserDefaultsEditViewController : ZooBaseViewController
@property (nonatomic, strong) ZooNSUserDefaultsModel *model;

- (instancetype)initWithModel: (ZooNSUserDefaultsModel *)model;
@end

NS_ASSUME_NONNULL_END
