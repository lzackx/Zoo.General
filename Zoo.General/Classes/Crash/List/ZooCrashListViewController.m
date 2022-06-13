//
//  ZooCrashListViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooCrashListViewController.h"
#import <Zoo/UIView+Zoo.h>
#import "ZooCrashListCell.h"
#import <Zoo/Zooi18NUtil.h>
#import "ZooSanboxDetailViewController.h"
#import <Zoo/ZooSandboxModel.h>
#import "ZooCrashTool.h"
#import <Zoo/ZooDefine.h>

static NSString *const kZooCrashListCellIdentifier = @"kZooCrashListCellIdentifier";

@interface ZooCrashListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<ZooSandboxModel *> *dataArray;

@end

@implementation ZooCrashListViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self commonInit];
    
    [self loadCrashData];
}

- (void)commonInit {
    self.dataArray = [NSArray array];
    
    self.title = ZooLocalizedString(@"Crash日志列表");
    [self.view addSubview:self.tableView];
}

#pragma mark - Layout

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.frame = CGRectMake(0, IPHONE_NAVIGATIONBAR_HEIGHT, self.view.zoo_width, self.view.zoo_height-IPHONE_NAVIGATIONBAR_HEIGHT);
}

#pragma mark - Private

#pragma mark CrashData

- (void)loadCrashData {
    // 获取crash目录
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *crashDirectory = [ZooCrashTool crashDirectory];
    
    if (crashDirectory && [manager fileExistsAtPath:crashDirectory]) {
        [self loadPath:crashDirectory];
    }
}

- (void)loadPath:(NSString *)filePath{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *targetPath = NSHomeDirectory();
    if ([filePath isKindOfClass:[NSString class]] && (filePath.length > 0)) {
        targetPath = filePath;
    }
    
    //该目录下面的内容信息
    NSError *error = nil;
    NSArray *paths = [fm contentsOfDirectoryAtPath:targetPath error:&error];
    
    // 对paths按照创建时间的降序进行排列
    NSArray *sortedPaths = [paths sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 isKindOfClass:[NSString class]] && [obj2 isKindOfClass:[NSString class]]) {
            // 获取文件完整路径
            NSString *firstPath = [targetPath stringByAppendingPathComponent:obj1];
            NSString *secondPath = [targetPath stringByAppendingPathComponent:obj2];
            
            // 获取文件信息
            NSDictionary *firstFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:firstPath error:nil];
            NSDictionary *secondFileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:secondPath error:nil];
            
            // 获取文件创建时间
            id firstData = [firstFileInfo objectForKey:NSFileCreationDate];
            id secondData = [secondFileInfo objectForKey:NSFileCreationDate];
            
            // 按照创建时间降序排列
            return [secondData compare:firstData];
        }
        return NSOrderedSame;
    }];
    
    // 构造数据源
    NSMutableArray *files = [NSMutableArray array];
    [sortedPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *sortedPath = obj;
            
            BOOL isDir = false;
            NSString *fullPath = [targetPath stringByAppendingPathComponent:sortedPath];
            [fm fileExistsAtPath:fullPath isDirectory:&isDir];
            
            ZooSandboxModel *model = [[ZooSandboxModel alloc] init];
            model.path = fullPath;
            if (isDir) {
                model.type = ZooSandboxFileTypeDirectory;
            }else{
                model.type = ZooSandboxFileTypeFile;
            }
            model.name = sortedPath;
            
            [files addObject:model];
        }
    }];
    self.dataArray = files.copy;
    
    [self.tableView reloadData];
}

- (void)deleteByZooSandboxModel:(ZooSandboxModel *)model{
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:model.path error:nil];
    
    [self loadCrashData];
}

#pragma mark HandleFile

- (void)handleFileWithPath:(NSString *)filePath{
    UIAlertControllerStyle style;
    if ([ZooAppInfoUtil isIpad]) {
        style = UIAlertControllerStyleAlert;
    }else{
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

- (void)previewFile:(NSString *)filePath{
    ZooSanboxDetailViewController *detalVc = [[ZooSanboxDetailViewController alloc] init];
    detalVc.filePath = filePath;
    [self.navigationController pushViewController:detalVc animated:YES];
}

- (void)shareFileWithPath:(NSString *)filePath{
    [ZooUtil shareURL:[NSURL fileURLWithPath:filePath] formVC:self];
}

#pragma mark - Delegate

#pragma mark <UITableViewDataSource>

// Default is 1 if not implemented
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZooCrashListCell *cell = [tableView dequeueReusableCellWithIdentifier:kZooCrashListCellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[ZooCrashListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kZooCrashListCellIdentifier];
    }
    
    if (indexPath.row < self.dataArray.count) {
        ZooSandboxModel *model = [self.dataArray objectAtIndex:indexPath.row];
        [cell renderUIWithData:model];
    }
    
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ZooCrashListCell cellHeight];
}

// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArray.count) {
        ZooSandboxModel *model = [self.dataArray objectAtIndex:indexPath.row];
        if (model.type == ZooSandboxFileTypeFile) {
            [self handleFileWithPath:model.path];
        }else if(model.type == ZooSandboxFileTypeDirectory){
            [self loadPath:model.path];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZooLocalizedString(@"删除");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < self.dataArray.count) {
        ZooSandboxModel *model = self.dataArray[indexPath.row];
        [self deleteByZooSandboxModel:model];
    }
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[ZooCrashListCell class] forCellReuseIdentifier:kZooCrashListCellIdentifier];
//        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end
