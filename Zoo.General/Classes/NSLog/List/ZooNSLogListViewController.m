//
//  ZooNSLogListViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNSLogListViewController.h"
#import "ZooNSLogManager.h"
#import <Zoo/UIView+Zoo.h>
#import "ZooNSLogListCell.h"
#import "ZooNSLogModel.h"
#import <Zoo/ZooStringSearchView.h>
#import <Zoo/ZooDefine.h>
#import <Zoo/ZooNavBarItemModel.h>

@interface ZooNSLogListViewController ()<UITableViewDelegate,UITableViewDataSource,ZooStringSearchViewDelegate>

@property (nonatomic, strong) ZooStringSearchView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataArray;

@end

@implementation ZooNSLogListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = ZooLocalizedString(@"NSLog日志记录");
    
    ZooNavBarItemModel *model1 = [[ZooNavBarItemModel alloc] initWithText:ZooLocalizedString(@"清除") color:[UIColor zoo_blue] selector:@selector(clear)];
    ZooNavBarItemModel *model2 = [[ZooNavBarItemModel alloc] initWithText:ZooLocalizedString(@"导出") color:[UIColor zoo_blue] selector:@selector(export)];
    [self setRightNavBarItems:@[model1,model2]];
    
    //按照时间倒序排列
    self.dataArray = [[[ZooNSLogManager sharedInstance].dataArray reverseObjectEnumerator] allObjects];
    
  
    _searchView = [[ZooStringSearchView alloc] initWithFrame:CGRectMake(kZooSizeFrom750_Landscape(32), IPHONE_NAVIGATIONBAR_HEIGHT+kZooSizeFrom750_Landscape(32), self.view.zoo_width-2*kZooSizeFrom750_Landscape(32), kZooSizeFrom750_Landscape(100))];
    _searchView.delegate = self;
    [self.view addSubview:_searchView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _searchView.zoo_bottom+kZooSizeFrom750_Landscape(32), self.view.zoo_width, self.view.zoo_height-_searchView.zoo_bottom-kZooSizeFrom750_Landscape(32)) style:UITableViewStylePlain];
//    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)clear {
    [[ZooNSLogManager sharedInstance].dataArray removeAllObjects];
    self.dataArray = [[NSArray alloc] init];
    [self.tableView reloadData];
}

- (void)export {
    NSArray<ZooNSLogModel *> *dataArray = [[ZooNSLogManager sharedInstance].dataArray  copy];
    NSMutableString *log = [[NSMutableString alloc] init];
    for (ZooNSLogModel *model in dataArray) {
        NSString *time = [NSString stringWithFormat:@"[%@]",[ZooUtil dateFormatTimeInterval:model.timeInterval]];
        [log appendString:time];
        [log appendString:@" "];
        [log appendString:model.content];
        [log appendString:@"\n"];
    }
    
    [ZooUtil shareText:log formVC:self];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZooNSLogModel* model = [self.dataArray objectAtIndex:indexPath.row];
    return [ZooNSLogListCell cellHeightWith:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"httpcell";
    ZooNSLogListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[ZooNSLogListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    ZooNSLogModel* model = [self.dataArray objectAtIndex:indexPath.row];
    [cell renderCellWithData:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ZooNSLogModel* model = [self.dataArray objectAtIndex:indexPath.row];
    model.expand = !model.expand;
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZooLocalizedString(@"复制");
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    ZooNSLogModel* model = [self.dataArray objectAtIndex:indexPath.row];
    NSString *content = model.content;
    if (content.length>0) {
        UIPasteboard *pboard = [UIPasteboard generalPasteboard];
        pboard.string = content;
    }
}

#pragma mark - ZooStringSearchViewDelegate
- (void)searchViewInputChange:(NSString *)text{
    if (text.length > 0) {
        NSArray *dataArray = [[[ZooNSLogManager sharedInstance].dataArray reverseObjectEnumerator] allObjects];
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        for(ZooNSLogModel *model in dataArray){
            NSString *content = model.content;
            if ([content containsString:text]) {
                [resultArray addObject:model];
            }
        }
        self.dataArray = [[NSArray alloc] initWithArray:resultArray];
    }else{
        self.dataArray = [[[ZooNSLogManager sharedInstance].dataArray reverseObjectEnumerator] allObjects];
    }

    [self.tableView reloadData];
}


@end
