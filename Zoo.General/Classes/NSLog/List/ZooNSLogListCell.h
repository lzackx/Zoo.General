//
//  ZooNSLogListCell.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>
#import "ZooNSLogModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZooNSLogListCell : UITableViewCell

- (void)renderCellWithData:(ZooNSLogModel *)model;

+ (CGFloat)cellHeightWith:(nullable ZooNSLogModel *)model;

@end

NS_ASSUME_NONNULL_END
