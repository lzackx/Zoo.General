//
//  ZooDBRowView.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>
@class ZooDBRowView;

typedef NS_ENUM(NSInteger, ZooDBRowViewType) {
    ZooDBRowViewTypeForTitle  = 0,
    ZooDBRowViewTypeForOne   = 1,
    ZooDBRowViewTypeForTwo   = 2
    
};

@protocol ZooDBRowViewTypeDelegate <NSObject>

- (void)rowView:(ZooDBRowView *)rowView didLabelTaped:(UILabel *)label;

@end


@interface ZooDBRowView : UIView

@property(nonatomic, copy) NSArray *dataArray;

@property(nonatomic, assign) ZooDBRowViewType type;

@property(nonatomic, weak) id<ZooDBRowViewTypeDelegate> delegate;

@end

