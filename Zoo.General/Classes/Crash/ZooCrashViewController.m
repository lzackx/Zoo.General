//
//  ZooCrashViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooCrashViewController.h"
#import <Zoo/ZooCellSwitch.h>
#import <Zoo/ZooCellButton.h>
#import <Zoo/UIView+Zoo.h>
#import "ZooCacheManager+General.h"
#import "ZooCrashListViewController.h"
#import <Zoo/Zooi18NUtil.h>
#import "ZooCrashTool.h"
#import <Zoo/ZooToastUtil.h>
#import <Zoo/ZooDefine.h>

@interface ZooCrashViewController () <ZooSwitchViewDelegate, ZooCellButtonDelegate>

@property (nonatomic, strong) ZooCellSwitch *switchView;
@property (nonatomic, strong) ZooCellButton *checkBtn;
@property (nonatomic, strong) ZooCellButton *clearBtn;

@end

@implementation ZooCrashViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self commonInit];
}

- (BOOL)needBigTitleView{
    return YES;
}

- (void)commonInit {
    self.title = ZooLocalizedString(@"Crash");
    
    self.switchView = [[ZooCellSwitch alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [self.switchView renderUIWithTitle:ZooLocalizedString(@"Crash日志收集开关") switchOn:[[ZooCacheManager sharedInstance] crashSwitch]];
    [self.switchView needDownLine];
    self.switchView.delegate = self;
    [self.view addSubview:self.switchView];
    
    self.checkBtn = [[ZooCellButton alloc] initWithFrame:CGRectMake(0, self.switchView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [self.checkBtn renderUIWithTitle:ZooLocalizedString(@"查看Crash日志")];
    self.checkBtn.delegate = self;
    [self.checkBtn needDownLine];
    [self.view addSubview:self.checkBtn];
    
    self.clearBtn = [[ZooCellButton alloc] initWithFrame:CGRectMake(0, self.checkBtn.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [self.clearBtn renderUIWithTitle:ZooLocalizedString(@"一键清理Crash日志")];
    self.clearBtn.delegate = self;
    [self.clearBtn needDownLine];
    [self.view addSubview:self.clearBtn];
}

#pragma mark - Delegate

#pragma mark ZooSwitchViewDelegate

- (void)changeSwitchOn:(BOOL)on sender:(id)sender{
    __weak typeof(self) weakSelf = self;
    [ZooAlertUtil handleAlertActionWithVC:self okBlock:^{
        [[ZooCacheManager sharedInstance] saveCrashSwitch:on];
        exit(0);
    } cancleBlock:^{
        weakSelf.switchView.switchView.on = !on;
    }];
}

#pragma mark ZooCellButtonDelegate

- (void)cellBtnClick:(id)sender {
    if (sender == self.checkBtn) {
        ZooCrashListViewController *vc = [[ZooCrashListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if (sender == self.clearBtn) {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:ZooLocalizedString(@"提示") message:ZooLocalizedString(@"确认删除所有崩溃日志吗？") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ZooLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:ZooLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm removeItemAtPath:[ZooCrashTool crashDirectory] error:nil]) {
                [ZooToastUtil showToast:ZooLocalizedString(@"删除成功") inView:self.view];
            } else {
                [ZooToastUtil showToast:ZooLocalizedString(@"删除失败") inView:self.view];
            }
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
