//
//  ZooDBTableViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooDBTableViewController.h"
#import "ZooDBManager.h"
#import "ZooDBRowView.h"
#import "ZooDBCell.h"
#import "ZooDBShowView.h"

@interface ZooDBTableViewController ()<UITableViewDelegate , UITableViewDataSource , ZooDBRowViewTypeDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataAtTable;
@property (nonatomic, strong) ZooDBShowView *showView;


@end

@implementation ZooDBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [ZooDBManager shareManager].tableName;
    
    NSArray *dataAtTable = [[ZooDBManager shareManager] dataAtTable];
    self.dataAtTable = dataAtTable;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
//    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.bounces  = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.scrollView addSubview:tableView];
    self.tableView = tableView;
    
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    
    if (self.dataAtTable.count) {
        NSDictionary *dict = self.dataAtTable.firstObject;
        NSUInteger num = [dict allKeys].count;
        self.tableView.frame = CGRectMake(0, 0, num * 200, self.scrollView.frame.size.height);
        self.scrollView.contentSize = CGSizeMake(self.tableView.frame.size.width, self.tableView.bounds.size.height);
    }
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataAtTable.count == 0 ? 0 : 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ZooDBRowView *headerView = nil;
    if (headerView == nil) {
        headerView = [[ZooDBRowView alloc] init];
    }
    
    NSDictionary *dict = self.dataAtTable.firstObject;
    headerView.dataArray = [dict allKeys];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataAtTable.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"db_data";
    ZooDBCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[ZooDBCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rowView.delegate = self;
    }
    
    cell.rowView.type = (indexPath.row % 2 == 0) ? ZooDBRowViewTypeForOne : ZooDBRowViewTypeForTwo;
    NSDictionary *dict = self.dataAtTable[indexPath.row];
    [cell renderCellWithArray:[dict allValues]];
    
    return cell;
}

#pragma mark -- ZooDBRowViewTypeDelegate
- (void)rowView:(ZooDBRowView *)rowView didLabelTaped:(UILabel *)label{
    NSString *content = label.text;
    [self showText:content];
}

#pragma mark -- 显示弹出文案
- (void)showText:(NSString *)content{
    if (self.showView) {
        [self.showView removeFromSuperview];
    }
    self.showView = [[ZooDBShowView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.showView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    self.showView.userInteractionEnabled = YES;
    [self.showView addGestureRecognizer:tap];
    
    [self.showView showText:content];
}

- (void)dismissView{
    if (self.showView) {
        [self.showView removeFromSuperview];
    }
}


@end
