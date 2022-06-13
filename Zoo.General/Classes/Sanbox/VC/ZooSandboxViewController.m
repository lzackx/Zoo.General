//
//  ZooSandboxViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooSandboxViewController.h"
#import <Zoo/ZooSandboxModel.h>
#import "ZooSanboxDetailViewController.h"
#import <Zoo/ZooNavBarItemModel.h>
#import <Zoo/ZooAppInfoUtil.h>
#import <Zoo/ZooDefine.h>
#import "ZooSandboxCell.h"
#import <Zoo/ZooUtil.h>

@interface ZooSandboxViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZooSandboxModel *currentDirModel;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, copy) NSString *rootPath;

@property (nonatomic, strong) ZooNavBarItemModel *leftModel;

@end

@implementation ZooSandboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadPath:_currentDirModel.path];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    // trait发生了改变
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                self.leftModel.image = [UIImage zoo_xcassetImageNamed:@"zoo_back_dark"];
            } else {
                self.leftModel.image = [UIImage zoo_xcassetImageNamed:@"zoo_back"];
            }
        }
    }
#endif
}

- (BOOL)needBigTitleView {
    return YES;
}

- (void)initData {
    _dataArray = @[];
    _rootPath = NSHomeDirectory();
}

- (void)initUI {
    self.title = ZooLocalizedString(@"沙盒浏览器");
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, self.view.zoo_height-self.bigTitleView.zoo_bottom) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


- (void)loadPath:(NSString *)filePath {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *targetPath = filePath;
    //该目录信息
    ZooSandboxModel *model = [[ZooSandboxModel alloc] init];
    if (!targetPath || [targetPath isEqualToString:_rootPath]) {
        targetPath = _rootPath;
        model.name = ZooLocalizedString(@"根目录");
        model.type = ZooSandboxFileTypeRoot;
        self.tableView.frame = CGRectMake(0, self.bigTitleView.zoo_bottom, self.view.zoo_width, self.view.zoo_height-self.bigTitleView.zoo_bottom);
        self.bigTitleView.hidden = NO;
        self.navigationController.navigationBarHidden = YES;
        [self setLeftNavBarItems:nil];
    }else{
        model.name = ZooLocalizedString(@"返回上一级");
        model.type = ZooSandboxFileTypeBack;
        self.bigTitleView.hidden = YES;
        self.navigationController.navigationBarHidden = NO;
        self.tableView.frame = CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, self.view.zoo_width, self.view.zoo_height-IPHONE_NAVIGATIONBAR_HEIGHT);
        NSString *dirTitle =  [fm displayNameAtPath:targetPath];
        self.title = dirTitle;
        UIImage *image = [UIImage zoo_xcassetImageNamed:@"zoo_back"];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
        if (@available(iOS 13.0, *)) {
            if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                image = [UIImage zoo_xcassetImageNamed:@"zoo_back_dark"];
            }
        }
#endif
        self.leftModel = [[ZooNavBarItemModel alloc] initWithImage:image selector:@selector(leftNavBackClick:)];
        
        [self setLeftNavBarItems:@[self.leftModel]];
    }
    model.path = filePath;
    _currentDirModel = model;
    
    
    //该目录下面的内容信息
    NSMutableArray *files = @[].mutableCopy;
    NSError *error = nil;
    NSArray *paths = [fm contentsOfDirectoryAtPath:targetPath error:&error];
    for (NSString *path in paths) {
        BOOL isDir = false;
        NSString *fullPath = [targetPath stringByAppendingPathComponent:path];
        [fm fileExistsAtPath:fullPath isDirectory:&isDir];
        
        ZooSandboxModel *model = [[ZooSandboxModel alloc] init];
        model.path = fullPath;
        if (isDir) {
            model.type = ZooSandboxFileTypeDirectory;
        }else{
            model.type = ZooSandboxFileTypeFile;
        }
        model.name = path;
        
        [files addObject:model];
    }
    
    //_dataArray = files.copy;
    
    // 按名称排序，并保持文件夹在上
    _dataArray = [files sortedArrayUsingComparator:^NSComparisonResult(ZooSandboxModel * _Nonnull obj1, ZooSandboxModel * _Nonnull obj2) {
        
        BOOL isObj1Directory = (obj1.type == ZooSandboxFileTypeDirectory);
        BOOL isObj2Directory = (obj2.type == ZooSandboxFileTypeDirectory);
        
        // 都是目录 或 都不是目录
        BOOL isSameType = ((isObj1Directory && isObj2Directory) || (!isObj1Directory && !isObj2Directory));
        
        if (isSameType) { // 都是目录 或 都不是目录
            
            // 按名称排序
            return [obj1.name.lowercaseString compare:obj2.name.lowercaseString];
        }
        
        // 以下是一个为目录，一个不为目录的情况
        
        if (isObj1Directory) { // obj1是目录
            
            // 升序，保持文件夹在上
            return NSOrderedAscending;
        }
        
        // obj2是目录，降序
        return NSOrderedDescending;
    }];
    
    [self.tableView reloadData];
}


#pragma mark- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"cellId";
    ZooSandBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ZooSandBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    ZooSandboxModel *model = _dataArray[indexPath.row];
    [cell renderUIWithData:model];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZooLocalizedString(@"删除");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZooSandboxModel *model = _dataArray[indexPath.row];
    [self deleteByZooSandboxModel:model];
}


#pragma mark- UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZooSandBoxCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZooSandboxModel *model = _dataArray[indexPath.row];
    if (model.type == ZooSandboxFileTypeFile) {
        [self handleFileWithPath:model.path];
    } else if (model.type == ZooSandboxFileTypeDirectory) {
        [self loadPath:model.path];
    }
}


- (void)leftNavBackClick:(id)clickView {
    if (_currentDirModel.type == ZooSandboxFileTypeRoot) {
        [super leftNavBackClick:clickView];
    } else {
        [self loadPath:[_currentDirModel.path stringByDeletingLastPathComponent]];
    }
}

- (void)handleFileWithPath:(NSString *)filePath {
    UIAlertControllerStyle style;
    if ([ZooAppInfoUtil isIpad]) {
        style = UIAlertControllerStyleAlert;
    } else {
        style = UIAlertControllerStyleActionSheet;
    }
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:ZooLocalizedString(@"请选择操作方式") message:nil preferredStyle:style];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *previewAction = [UIAlertAction actionWithTitle:ZooLocalizedString(@"本地预览") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf previewFile:filePath];
    }];
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:ZooLocalizedString(@"分享") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf shareFileWithPath:filePath];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:ZooLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVc addAction:previewAction];
    [alertVc addAction:shareAction];
    [alertVc addAction:cancelAction];
    
    [self presentViewController:alertVc animated:YES completion:nil];
}

- (void)previewFile:(NSString *)filePath {
    ZooSanboxDetailViewController *detalVc = [[ZooSanboxDetailViewController alloc] init];
    detalVc.filePath = filePath;
    [self.navigationController pushViewController:detalVc animated:YES];
}


- (void)shareFileWithPath:(NSString *)filePath {
    [ZooUtil shareURL:[NSURL fileURLWithPath:filePath] formVC:self];
}

- (void)deleteByZooSandboxModel:(ZooSandboxModel *)model {
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:model.path error:nil];
    [self loadPath:_currentDirModel.path];
}


@end
