//
//  ZooAppInfoCell.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

@interface ZooAppInfoCell : UITableViewCell

- (void)renderUIWithData:(NSDictionary *)data;

+ (CGFloat)cellHeight;

@end
