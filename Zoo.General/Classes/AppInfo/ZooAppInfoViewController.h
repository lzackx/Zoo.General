//
//  ZooAppInfoViewController.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Zoo/ZooBaseViewController.h>

@interface ZooAppInfoViewController : ZooBaseViewController

/// 自定义App信息处理
@property (class, nonatomic, copy) void (^customAppInfoBlock)(NSMutableArray<NSDictionary *> *appInfos);

@end
