//
//  ZooSandboxCell.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooSandboxCell.h"
#import <Zoo/ZooSandboxModel.h>
#import <Zoo/ZooUtil.h>
#import <Zoo/UIView+Zoo.h>
#import <Zoo/ZooDefine.h>
#import <Zoo/UIImage+Zoo.h>
#import <Zoo/UIColor+Zoo.h>

@interface ZooSandBoxCell()

@property (nonatomic, strong) UIImageView *fileTypeIcon;
@property (nonatomic, strong) UILabel *fileTitleLabel;
@property (nonatomic, strong) UILabel *fileSizeLabel;

@end

@implementation ZooSandBoxCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.fileTypeIcon = [[UIImageView alloc] init];
        [self.contentView addSubview:self.fileTypeIcon];
        
        self.fileTitleLabel = [[UILabel alloc] init];
        self.fileTitleLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(32)];
        self.fileSizeLabel.textColor = [UIColor zoo_black_1];
        [self.contentView addSubview:self.fileTitleLabel];
        
        self.fileSizeLabel = [[UILabel alloc] init];
        self.fileSizeLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(32)];
        self.fileSizeLabel.textColor = [UIColor zoo_black_2];
        [self.contentView addSubview:self.fileSizeLabel];
    }
    return self;
}

- (void)renderUIWithData : (ZooSandboxModel *)model{
    NSString *iconName = nil;
    if (model.type == ZooSandboxFileTypeDirectory) {
        iconName = @"zoo_dir";
    }else{
        iconName = @"zoo_file_2";
    }
    self.fileTypeIcon.image = [UIImage zoo_xcassetImageNamed:iconName];
    [self.fileTypeIcon sizeToFit];
    self.fileTypeIcon.frame = CGRectMake(kZooSizeFrom750_Landscape(32), [[self class] cellHeight]/2-self.fileTypeIcon.zoo_height/2, self.fileTypeIcon.zoo_width, self.fileTypeIcon.zoo_height);
    
    self.fileTitleLabel.text = model.name;
    self.fileTitleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self.fileTitleLabel sizeToFit];
    self.fileTitleLabel.frame = CGRectMake(self.fileTypeIcon.zoo_right+kZooSizeFrom750_Landscape(32), [[self class] cellHeight]/2-self.fileTitleLabel.zoo_height/2, ZooScreenWidth-150, self.fileTitleLabel.zoo_height);

    ZooUtil *util = [[ZooUtil alloc] init];
    [util getFileSizeWithPath:model.path];
    NSInteger fileSize = util.fileSize;
    //将文件夹大小转换为 M/KB/B
    NSString *fileSizeStr = nil;
    if (fileSize > 1024 * 1024){
        fileSizeStr = [NSString stringWithFormat:@"%.2fM",fileSize / 1024.00f /1024.00f];
        
    }else if (fileSize > 1024){
        fileSizeStr = [NSString stringWithFormat:@"%.2fKB",fileSize / 1024.00f ];
        
    }else{
        fileSizeStr = [NSString stringWithFormat:@"%.2fB",fileSize / 1.00f];
    }
    
    self.fileSizeLabel.text = fileSizeStr;
    [self.fileSizeLabel sizeToFit];
    self.fileSizeLabel.frame = CGRectMake(ZooScreenWidth-15-self.fileSizeLabel.zoo_width, [[self class] cellHeight]/2-self.fileSizeLabel.zoo_height/2, self.fileSizeLabel.zoo_width, self.fileSizeLabel.zoo_height);
}

+ (CGFloat)cellHeight{
    return 48.;
}

@end
