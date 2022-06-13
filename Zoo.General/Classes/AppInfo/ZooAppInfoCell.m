//
//  ZooAppInfoCell.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooAppInfoCell.h"
#import <Zoo/UIView+Zoo.h>
#import <Zoo/ZooDefine.h>
#import <Zoo/UIColor+Zoo.h>
#import <Zoo/ZooDefine.h>

@interface ZooAppInfoCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *valueLabel;

@end

@implementation ZooAppInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            self.backgroundColor = [UIColor systemBackgroundColor];
        } else {
#endif
            self.backgroundColor = [UIColor whiteColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        }
#endif
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor zoo_black_1];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(32)];
        [self.contentView addSubview:self.titleLabel];
        
        self.valueLabel = [[UILabel alloc] init];
        self.valueLabel.textColor = [UIColor zoo_black_2];
        self.valueLabel.textAlignment = NSTextAlignmentRight;
        self.valueLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(32)];
        self.valueLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        [self.contentView addSubview:self.valueLabel];
    }
    return self;
}

- (void)renderUIWithData:(NSDictionary *)data{
    NSString *title = data[@"title"];
    NSString *value = data[@"value"];
    
    self.titleLabel.text = title;
    
    NSString *cnValue = nil;
    if([value isEqualToString:@"NotDetermined"]){
        cnValue = ZooLocalizedString(@"用户没有选择");
    }else if([value isEqualToString:@"Restricted"]){
        cnValue = ZooLocalizedString(@"家长控制");
    }else if([value isEqualToString:@"Denied"]){
        cnValue = ZooLocalizedString(@"用户没有授权");
    }else if([value isEqualToString:@"Authorized"]){
        cnValue = ZooLocalizedString(@"用户已经授权");
    }else{
        cnValue = value;
    }
    
    self.valueLabel.text = cnValue;
    
    [self.titleLabel sizeToFit];
    [self.valueLabel sizeToFit];
    
    self.titleLabel.frame = CGRectMake(kZooSizeFrom750_Landscape(32),
                                       0,
                                       self.titleLabel.zoo_width,
                                       [[self class] cellHeight]);
    self.valueLabel.frame = CGRectMake(kZooSizeFrom750_Landscape(32) + CGRectGetMaxX(self.titleLabel.frame),
                                       0,
                                       ZooScreenWidth - (kZooSizeFrom750_Landscape(32) * 2) - CGRectGetMaxX(self.titleLabel.frame),
                                       [[self class] cellHeight]);
}

+ (CGFloat)cellHeight{
    return kZooSizeFrom750_Landscape(104);
}


@end
