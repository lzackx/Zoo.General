//
//  ZooSandboxCell.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>
@class ZooSandboxModel;

@interface ZooSandBoxCell : UITableViewCell

- (void)renderUIWithData : (ZooSandboxModel *)model;

+ (CGFloat)cellHeight;

@end
