//
//  ZooDBCell.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooDBCell.h"
#import "ZooDBRowView.h"

@interface ZooDBCell()

@end

@implementation ZooDBCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _rowView = [[ZooDBRowView alloc] init];
        [self.contentView addSubview:_rowView];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _rowView.frame = self.contentView.bounds;
}

- (void)renderCellWithArray:(NSArray *)array{
    _rowView.dataArray = array;
}

@end
