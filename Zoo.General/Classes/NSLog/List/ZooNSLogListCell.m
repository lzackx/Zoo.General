//
//  ZooNSLogListCell.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNSLogListCell.h"
#import <Zoo/ZooDefine.h>
#import <Zoo/ZooUtil.h>

@interface ZooNSLogListCell()

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *logLabel;

@end

@implementation ZooNSLogListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kZooSizeFrom750_Landscape(27), [[self class] cellHeightWith:nil]/2-kZooSizeFrom750_Landscape(25)/2, kZooSizeFrom750_Landscape(25), kZooSizeFrom750_Landscape(25))];
        _arrowImageView.image = [UIImage zoo_xcassetImageNamed:@"zoo_expand_no"];
        _arrowImageView.contentMode = UIViewContentModeCenter;
        _arrowImageView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_arrowImageView];
        
        _logLabel = [[UILabel alloc] init];
        _logLabel.textColor = [UIColor zoo_black_1];
        _logLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(24)];
        [self.contentView addSubview:_logLabel];
    }
    return self;
}

- (void)renderCellWithData:(ZooNSLogModel *)model{
    NSString *content;
    if (model && model.expand){
        NSString *log = model.content;
        NSTimeInterval timeInterval = model.timeInterval;
        NSString *time = [ZooUtil dateFormatTimeInterval:timeInterval];
        content = [NSString stringWithFormat:ZooLocalizedString(@"%@\n触发时间: %@"),log,time];
        _logLabel.numberOfLines = 0;
        _logLabel.text = content;
        CGSize size = [_logLabel sizeThatFits:CGSizeMake(ZooScreenWidth-kZooSizeFrom750_Landscape(32)*2-kZooSizeFrom750_Landscape(25)-kZooSizeFrom750_Landscape(12)*2, MAXFLOAT)];
        _logLabel.frame = CGRectMake(_arrowImageView.zoo_right+kZooSizeFrom750_Landscape(12), [[self class] cellHeightWith:model]/2-size.height/2, size.width, size.height);
        
        _arrowImageView.image = [UIImage zoo_xcassetImageNamed:@"zoo_expand"];
    }else{
        _logLabel.numberOfLines = 1;
        _logLabel.text = model.content;
        _logLabel.frame = CGRectMake(_arrowImageView.zoo_right+kZooSizeFrom750_Landscape(12), [[self class] cellHeightWith:model]/2-kZooSizeFrom750_Landscape(34)/2,ZooScreenWidth-kZooSizeFrom750_Landscape(32)*2-kZooSizeFrom750_Landscape(25)-kZooSizeFrom750_Landscape(12)*2 , kZooSizeFrom750_Landscape(34));
        _arrowImageView.image = [UIImage zoo_xcassetImageNamed:@"zoo_expand_no"];
    }
    


}

+ (CGFloat)cellHeightWith:(ZooNSLogModel *)model{
    CGFloat cellHeight = kZooSizeFrom750_Landscape(60);
    if (model && model.expand) {
        NSString *log = model.content;
        NSTimeInterval timeInterval = model.timeInterval;
        NSString *time = [ZooUtil dateFormatTimeInterval:timeInterval];
        NSString *content = [NSString stringWithFormat:ZooLocalizedString(@"%@\n触发时间: %@"),log,time];
        
        UILabel *logLabel = [[UILabel alloc] init];
        logLabel.textColor = [UIColor zoo_black_1];
        logLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(24)];
        logLabel.text = content;
        logLabel.numberOfLines = 0;
        CGSize size = [logLabel sizeThatFits:CGSizeMake(ZooScreenWidth-kZooSizeFrom750_Landscape(32)*2-kZooSizeFrom750_Landscape(25)-kZooSizeFrom750_Landscape(12)*2, MAXFLOAT)];
        cellHeight = kZooSizeFrom750_Landscape(10) + size.height + kZooSizeFrom750_Landscape(10);
    }
    return cellHeight;
}



@end
