//
//  ZooCrashListCell.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

@class ZooSandboxModel;

NS_ASSUME_NONNULL_BEGIN

@interface ZooCrashListCell : UITableViewCell

- (void)renderUIWithData:(ZooSandboxModel *)model;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
