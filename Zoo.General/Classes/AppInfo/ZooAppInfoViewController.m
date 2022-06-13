//
//  ZooAppInfoViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooAppInfoViewController.h"
#import "ZooAppInfoCell.h"
#import <Zoo/ZooDefine.h>
#import <Zoo/ZooAppInfoUtil.h>
#import <Zoo/Zooi18NUtil.h>
#import <Zoo/UIView+Zoo.h>
#import <Zoo/UIColor+Zoo.h>
#import <CoreTelephony/CTCellularData.h>
#import <objc/runtime.h>

@interface ZooAppInfoViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) CTCellularData *cellularData API_AVAILABLE(ios(9.0));
@property (nonatomic, copy) NSString *authority;

@end

@implementation ZooAppInfoViewController{
    
}

+ (void)setCustomAppInfoBlock:(void (^)(NSMutableArray<NSDictionary *> *))customAppInfoBlock {
    objc_setAssociatedObject(self, @selector(customAppInfoBlock), customAppInfoBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (void (^)(NSMutableArray<NSDictionary *> *))customAppInfoBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (@available(iOS 9.0, *)){
        _cellularData.cellularDataRestrictionDidUpdateNotifier = nil;
        _cellularData = nil;
    }
}

- (BOOL)needBigTitleView{
    return YES;
}

- (void)initUI
{
    self.title = ZooLocalizedString(@"App信息");

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, self.view.zoo_height-self.bigTitleView.zoo_bottom) style:UITableViewStyleGrouped];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        self.tableView.backgroundColor = [UIColor systemBackgroundColor];
    } else {
#endif
        self.tableView.backgroundColor = [UIColor whiteColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    }
#endif
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0.;
    self.tableView.estimatedSectionFooterHeight = 0.;
    self.tableView.estimatedSectionHeaderHeight = 0.;
    [self.view addSubview:self.tableView];
}

#pragma mark - default data

- (void)initData
{
    // 获取设备名称
    NSString *iphoneName = [ZooAppInfoUtil iphoneName];
    
    // 获取当前系统版本号
    NSString *iphoneSystemVersion = [ZooAppInfoUtil iphoneSystemVersion];
    
    //获取手机型号
    NSString *iphoneType = [ZooAppInfoUtil iphoneType];
    
    //获取手机屏幕大小
    NSString *iphoneSize = [NSString stringWithFormat:@"%.0f * %.0f",ZooScreenWidth,ZooScreenHeight];
    
    //获取手机ipv4地址
    NSString *ipv4String = [ZooAppInfoUtil getIPAddress:YES];
    
    //获取手机ipv6地址
    NSString *ipv6String = [ZooAppInfoUtil getIPAddress:NO];
    
    //获取手机mac地址
    
    
    //获取bundle id
    NSString *bundleIdentifier = [ZooAppInfoUtil bundleIdentifier];
    
    //获取App版本号
    NSString *bundleVersion = [ZooAppInfoUtil bundleVersion];
    
    //获取App版本Code
    NSString *bundleShortVersionString = [ZooAppInfoUtil bundleShortVersionString];
    
    //获取手机是否有地理位置权限
    NSString *locationAuthority = [ZooAppInfoUtil locationAuthority];
    
    //获取网络权限
    if (@available(iOS 9.0, *)) {
        _cellularData = [[CTCellularData alloc]init];
        __weak typeof(self) weakSelf = self;
        _cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            if (state == kCTCellularDataRestricted) {
                weakSelf.authority = @"Restricted";
            }else if(state == kCTCellularDataNotRestricted){
                weakSelf.authority = @"NotRestricted";
            }else{
                weakSelf.authority = @"Unknown";
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
            
        };
    }
    
    //获取push权限
    NSString *pushAuthority = [ZooAppInfoUtil pushAuthority];
    
    //获取拍照权限
    NSString *cameraAuthority = [ZooAppInfoUtil cameraAuthority];
    
    //获取麦克风权限
    NSString *audioAuthority = [ZooAppInfoUtil audioAuthority];
    
    //获取相册权限
    NSString *photoAuthority = [ZooAppInfoUtil photoAuthority];
    
    //获取通讯录权限
    NSString *addressAuthority = [ZooAppInfoUtil addressAuthority];
    
    //获取日历权限
    NSString *calendarAuthority = [ZooAppInfoUtil calendarAuthority];
    
    //获取提醒事项权限
    NSString *remindAuthority = [ZooAppInfoUtil remindAuthority];
    
    //可自定义的App信息
    NSMutableArray *appInfos = @[@{@"title":@"Bundle ID",
                            @"value":bundleIdentifier},
                          @{@"title":@"Version",
                            @"value":bundleVersion},
                          @{@"title":@"VersionCode",
                            @"value":bundleShortVersionString}].mutableCopy;
    if (ZooAppInfoViewController.customAppInfoBlock) {
        ZooAppInfoViewController.customAppInfoBlock(appInfos);
    }
    
    
    NSArray *dataArray = @[
                           @{
                               @"title":ZooLocalizedString(@"手机信息"),
                               @"array":@[
                                       @{
                                           @"title":ZooLocalizedString(@"设备名称"),
                                           @"value":iphoneName
                                           },
                                       @{
                                           @"title":ZooLocalizedString(@"手机型号"),
                                           @"value":iphoneType
                                           },
                                       @{
                                           @"title":ZooLocalizedString(@"系统版本"),
                                           @"value":iphoneSystemVersion
                                           },
                                       @{
                                           @"title":ZooLocalizedString(@"手机屏幕"),
                                           @"value":iphoneSize
                                            },
                                       @{
                                           @"title":@"ipV4",
                                           @"value":STRING_NOT_NULL(ipv4String)
                                            },
                                       @{
                                           @"title":@"ipV6",
                                           @"value":STRING_NOT_NULL(ipv6String)
                                            }
                                       ]
                               },
                           @{
                               @"title":ZooLocalizedString(@"App信息"),
                               @"array":appInfos
                               },
                           @{
                               @"title":ZooLocalizedString(@"权限信息"),
                               @"array":@[@{
                                              @"title":ZooLocalizedString(@"地理位置权限"),
                                              @"value":locationAuthority
                                              },
                                          @{
                                              @"title":ZooLocalizedString(@"网络权限"),
                                              @"value":@"Unknown"
                                              },
                                          @{
                                              @"title":ZooLocalizedString(@"推送权限"),
                                              @"value":pushAuthority
                                              },
                                          @{
                                              @"title":ZooLocalizedString(@"相机权限"),
                                              @"value":cameraAuthority
                                              },
                                          @{
                                              @"title":ZooLocalizedString(@"麦克风权限"),
                                              @"value":audioAuthority
                                              },
                                          @{
                                              @"title":ZooLocalizedString(@"相册权限"),
                                              @"value":photoAuthority
                                              },
                                          @{
                                              @"title":ZooLocalizedString(@"通讯录权限"),
                                              @"value":addressAuthority
                                              },
                                          @{
                                              @"title":ZooLocalizedString(@"日历权限"),
                                              @"value":calendarAuthority
                                              },
                                          @{
                                              @"title":ZooLocalizedString(@"提醒事项权限"),
                                              @"value":remindAuthority
                                              }
                                          ]
                               }
                           ];
    _dataArray = dataArray;
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = _dataArray[section][@"array"];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZooAppInfoCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kZooSizeFrom750_Landscape(120);
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.zoo_width, kZooSizeFrom750_Landscape(120))];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kZooSizeFrom750_Landscape(32), 0, ZooScreenWidth-kZooSizeFrom750_Landscape(32), kZooSizeFrom750_Landscape(120))];
    NSDictionary *dic = _dataArray[section];
    titleLabel.text = dic[@"title"];
    titleLabel.font = [UIFont systemFontOfSize:kZooSizeFrom750_Landscape(28)];
    titleLabel.textColor = [UIColor zoo_black_3];
    [sectionView addSubview:titleLabel];
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"httpcell";
    ZooAppInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[ZooAppInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    NSArray *array = _dataArray[indexPath.section][@"array"];
    NSDictionary *item = array[indexPath.row];
    if (indexPath.section == 2 && indexPath.row == 1 && self.authority) {
        NSMutableDictionary *tempItem = [item mutableCopy];
        [tempItem setValue:self.authority forKey:@"value"];
        [cell renderUIWithData:tempItem];
    }else{
       [cell renderUIWithData:item];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2){
        [ZooUtil openAppSetting];
    } else {
        [UIPasteboard generalPasteboard].string = self.dataArray[indexPath.section][@"array"][indexPath.row][@"value"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:ZooLocalizedString(@"复制")  handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString *value = weakSelf.dataArray[indexPath.section][@"array"][indexPath.row][@"value"];
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = value;
    }];
    
    return @[action0];
}


@end
