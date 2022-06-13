//
//  ZooDBShowView.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooDBShowView.h"
#import <Zoo/ZooDefine.h>

@interface ZooDBShowView()

@property (nonatomic, strong) UITextView *displayTextView;

@end

@implementation ZooDBShowView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _displayTextView = [[UITextView alloc] init];
        _displayTextView.font = [UIFont systemFontOfSize:16.0];
        _displayTextView.editable = NO;
        _displayTextView.textAlignment = NSTextAlignmentCenter;
        _displayTextView.backgroundColor = [UIColor zoo_black_2];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            _displayTextView.textColor = [UIColor labelColor];
        }
#endif
        [self addSubview:_displayTextView];
    }
    return self;
}

- (void)showText:(NSString *)text{
    _displayTextView.frame = CGRectMake(self.zoo_width/2-150/2, self.zoo_height/2-100/2, 150, 100);
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.displayTextView.frame = CGRectMake(self.zoo_width/2-300/2, self.zoo_height/2-200/2, 300, 200);
    } completion:^(BOOL finished) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.displayTextView.text = text;
    }];
}

@end
