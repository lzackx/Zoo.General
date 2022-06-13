//
//  ZooNSLogViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNSLogViewController.h"
#import <Zoo/ZooCellSwitch.h>
#import <Zoo/ZooCellButton.h>
#import "ZooCacheManager+General.h"
#import "ZooNSLogListViewController.h"
#import <Zoo/ZooDefine.h>
#import "ZooNSLogManager.h"

@interface ZooNSLogViewController ()<ZooSwitchViewDelegate,ZooCellButtonDelegate>

@property (nonatomic, strong) ZooCellSwitch *switchView;
@property (nonatomic, strong) ZooCellButton *cellBtn;

@end

@implementation ZooNSLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSLog";
    
    _switchView = [[ZooCellSwitch alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [_switchView renderUIWithTitle:ZooLocalizedString(@"开关") switchOn:[[ZooCacheManager sharedInstance] nsLogSwitch]];
    [_switchView needTopLine];
    [_switchView needDownLine];
    _switchView.delegate = self;
    [self.view addSubview:_switchView];
    
    _cellBtn = [[ZooCellButton alloc] initWithFrame:CGRectMake(0, _switchView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [_cellBtn renderUIWithTitle:ZooLocalizedString(@"查看记录")];
    _cellBtn.delegate = self;
    [_cellBtn needDownLine];
    [self.view addSubview:_cellBtn];
    
}

- (BOOL)needBigTitleView{
    return YES;
}

#pragma mark -- ZooSwitchViewDelegate
- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    [[ZooCacheManager sharedInstance] saveNSLogSwitch:on];
    if (on) {
        [[ZooNSLogManager sharedInstance] startNSLogMonitor];
    }else{
        [[ZooNSLogManager sharedInstance] stopNSLogMonitor];
    }
}

#pragma mark -- ZooCellButtonDelegate
- (void)cellBtnClick:(id)sender{
    if (sender == _cellBtn) {
        ZooNSLogListViewController *vc = [[ZooNSLogListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
