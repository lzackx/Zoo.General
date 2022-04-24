//
//  ZooNSLogSearchView.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNSLogSearchView.h"
#import "ZooDefine.h"

@interface ZooNSLogSearchView()

@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation ZooNSLogSearchView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = kZooSizeFrom750_Landscape(8);
        self.layer.borderWidth = kZooSizeFrom750_Landscape(2);
        self.layer.borderColor = [UIColor zoo_colorWithHex:0x999999 andAlpha:0.2].CGColor;
        
        _searchIcon = [[UIImageView alloc] initWithImage:[UIImage zoo_xcassetImageNamed:@"zoo_search"]];
        _searchIcon.frame = CGRectMake(kZooSizeFrom750_Landscape(20), self.zoo_height/2-_searchIcon.zoo_height/2, _searchIcon.zoo_width, _searchIcon.zoo_height);
        [self addSubview:_searchIcon];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(_searchIcon.zoo_right+kZooSizeFrom750_Landscape(20), self.zoo_height/2-kZooSizeFrom750_Landscape(50)/2, self.zoo_width-_searchIcon.zoo_right-kZooSizeFrom750_Landscape(20), kZooSizeFrom750_Landscape(50))];
        _textField.placeholder = ZooLocalizedString(@"请输入您要搜索的关键字");
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
    }
    return self;
}

-(void)textFieldDidChange:(id)sender{
    UITextField *senderTextField = (UITextField *)sender;
    //去除首尾空格
    NSString *textSearchStr = [senderTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchViewInputChange:)]) {
        [self.delegate searchViewInputChange:textSearchStr];
    }
}

@end
