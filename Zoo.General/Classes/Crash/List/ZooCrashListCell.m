//
//  ZooCrashListCell.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooCrashListCell.h"
#import <Zoo/ZooSandboxModel.h>
#import <Zoo/ZooDefine.h>

@interface ZooCrashListCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation ZooCrashListCell

#pragma mark - Lifecycle

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor zoo_black_1];
        _titleLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(32)];
        [self.contentView addSubview:_titleLabel];
        
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage zoo_xcassetImageNamed:@"zoo_more"]];
        _arrowImageView.frame = CGRectMake(ZooScreenWidth-kZooSizeFrom750_Landscape(32)-_arrowImageView.zoo_width, [[self class] cellHeight]/2-_arrowImageView.zoo_height/2, _arrowImageView.zoo_width, _arrowImageView.zoo_height);
        [self.contentView addSubview:_arrowImageView];
        
    }
    return self;
}

#pragma mark - Public

- (void)renderUIWithData:(ZooSandboxModel *)model {
    self.titleLabel.text = @"";
    if ([model.name isKindOfClass:[NSString class]] && (model.name.length > 0)) {
        self.titleLabel.text = model.name;
        [self.titleLabel sizeToFit];
        CGFloat w = self.titleLabel.zoo_width;
        if (w > ZooScreenWidth-kZooSizeFrom750_Landscape(120)) {
            w = ZooScreenWidth-kZooSizeFrom750_Landscape(120);
        }
        self.titleLabel.frame = CGRectMake(kZooSizeFrom750_Landscape(32), [[self class] cellHeight]/2-self.titleLabel.zoo_height/2, w, self.titleLabel.zoo_height);
    }
}

+ (CGFloat)cellHeight{
    return kZooSizeFrom750_Landscape(104);
}

@end
