//
//  ZooDeleteLocalDataViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooDeleteLocalDataViewController.h"
#import <Zoo/Zooi18NUtil.h>
#import <Zoo/ZooUtil.h>
#import <Zoo/ZooCellButton.h>
#import <Zoo/ZooDefine.h>

@interface ZooDeleteLocalDataViewController ()<ZooCellButtonDelegate>

@property (nonatomic, strong) ZooCellButton *cellBtn;

@end

@implementation ZooDeleteLocalDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"清理缓存");
    
    _cellBtn = [[ZooCellButton alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, kZooSizeFrom750_Landscape(104))];
    [_cellBtn renderUIWithTitle:ZooLocalizedString(@"清理缓存")];
    [_cellBtn renderUIWithRightContent:[self getHomeDirFileSize]];
    _cellBtn.delegate = self;
    [_cellBtn needDownLine];
    [self.view addSubview:_cellBtn];
}

- (BOOL)needBigTitleView{
    return YES;
}

- (void)cellBtnClick:(id)sender{
    [self deleteFile];
}

- (void)deleteFile{
    
    __weak typeof(self) weakSelf = self;
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:ZooLocalizedString(@"提示") message:ZooLocalizedString(@"确定要删除本地数据") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ZooLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:ZooLocalizedString(@"确定") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.cellBtn renderUIWithRightContent:ZooLocalizedString(@"正在清理中")];
        [ZooUtil clearLocalDatas];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.cellBtn renderUIWithRightContent:[self getHomeDirFileSize]];
        });
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)getHomeDirFileSize{
    // 获取沙盒主目录路径
    NSString *homeDir = NSHomeDirectory();
    
    ZooUtil *util = [[ZooUtil alloc] init];
    [util getFileSizeWithPath:homeDir];
    NSInteger fileSize = util.fileSize;
    NSString *fileSizeString = [NSByteCountFormatter stringFromByteCount:fileSize countStyle: NSByteCountFormatterCountStyleFile];
    return fileSizeString;
}


@end
