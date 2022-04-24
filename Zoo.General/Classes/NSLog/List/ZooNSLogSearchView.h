//
//  ZooNSLogSearchView.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ZooNSLogSearchViewDelegate  <NSObject>

- (void)searchViewInputChange:(NSString *)text;

@end

@interface ZooNSLogSearchView : UIView

@property (nonatomic, weak) id<ZooNSLogSearchViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
