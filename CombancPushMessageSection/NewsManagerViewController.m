//
//  NewsManagerViewController.m
//  PushNotice
//
//  Created by Golden on 2018/12/25.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import "NewsManagerViewController.h"
#import "NewsManagerTableViewCell.h"
#import "DetailViewController.h"
#import "NewsPushDefine.h"
#import "PushManager.h"
#import "PushRequest.h"
#import "PushModel.h"
#import "MJRefresh.h"

#import "Masonry.h"
#import "MJRefresh.h"

static NSString *const CELLID = @"CELLID";

@interface NewsManagerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) PushManager *manager;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation NewsManagerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([PushManager sharePushManagerInstance].refreshPageViewController) {
        [PushManager sharePushManagerInstance].refreshPageViewController = NO;
        [self.myTableView.mj_header beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBase];
    [self configUI];
    [self requestAPI];
    [self creatRefresh];
}

- (void)configBase {
    self.view.backgroundColor = [UIColor whiteColor];
    self.page = 1;
    self.pageSize = 10;
    self.manager = [PushManager sharePushManagerInstance];
}

- (void)creatRefresh {
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pageSize = 10;
        [self requestAPI];
    }];
    
    self.myTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.pageSize += 10;
        [self requestAPI];
    }];
}

- (void)configUI {
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    self.myTableView.tableFooterView = [UIView new];
    self.myTableView.estimatedRowHeight = 150;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.backgroundColor = RGBA(234, 234, 234, 1);
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.equalTo(self.view);
        }
    }];
}

#pragma mark - TableViewDelegate&&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (!cell) {
         cell = [[NewsManagerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configCell:cell indexPath:indexPath];
    return cell;
}

- (void)configCell:(NewsManagerTableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    NoticeListModel *model = self.dataArray[indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    if (self.manager.pushType == PushNewType || self.manager.pushType == PushNoticeType) {
        formatter.dateFormat = @"yyyy/MM/dd";
    }else if (self.manager.pushType == PushMessageType) {
        formatter.dateFormat = @"yyyy/MM/dd HH:mm";
    }
    NSDate *creatDate = [formatter dateFromString:model.createTime];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc]init];
    if (self.manager.pushType == PushNewType || self.manager.pushType == PushNoticeType) {
        formatter2.dateFormat = @"MM-dd";
    }else if (self.manager.pushType == PushMessageType) {
        formatter2.dateFormat = @"MM-dd HH:mm";
    }
    NSString *creatString = [formatter2 stringFromDate:creatDate];
    cell.pushtimeLabel.text = creatString;
    
    cell.authorLabel.text = [NSString stringWithFormat:@"发布人：%@",model.userName];
    cell.titleLabel.text = model.title;
    if ([model.state isEqualToString:@"0"]) {
        //未发布
        cell.stickLabel.hidden = YES;
        cell.pushstateLabel.text = model.stateStr;
        cell.pushstateLabel.backgroundColor = RGBA(255, 76, 121, 1);
    }else if ([model.state isEqualToString:@"1"]) {
        //发布状态
        cell.stickLabel.hidden = YES;
        cell.pushstateLabel.text = @"已发布";
        cell.pushstateLabel.backgroundColor = RGBA(24, 241, 146, 1);
    }else if ([model.state isEqualToString:@"2"]) {
        //置顶状态
        cell.stickLabel.hidden = NO;
        cell.stickLabel.text = model.stateStr;
        cell.pushstateLabel.text = @"已发布";
        cell.pushstateLabel.backgroundColor = RGBA(24, 241, 146, 1);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    detailVC.model = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - 网络请求
- (void)requestAPI {
    if (self.manager.pushType == PushNewType) {
        //新闻
        [PushRequest requestNewsList:newslistParam([@(self.page) description], [@(self.pageSize) description], @"", @"", @"", @"") success:^(id json) {
            self.dataArray = json;
            [self.myTableView reloadData];
            [self.myTableView.mj_header endRefreshing];
            [self.myTableView.mj_footer endRefreshing];
        } failed:^(NSError *error) {
            [self.myTableView.mj_header endRefreshing];
            [self.myTableView.mj_footer endRefreshing];
        }];
    }else if (self.manager.pushType == PushNoticeType) {
        //公告
        [PushRequest requestNoticeList:noticelistParam([@(self.page) description], [@(self.pageSize) description], @"", @"", @[], @"") success:^(id json) {
            self.dataArray = json;
            [self.myTableView reloadData];
            [self.myTableView.mj_header endRefreshing];
            [self.myTableView.mj_footer endRefreshing];
        } failed:^(NSError *error) {
            [self.myTableView.mj_header endRefreshing];
            [self.myTableView.mj_footer endRefreshing];
        }];
    }else if (self.manager.pushType == PushMessageType) {
        //通知
        [PushRequest requestPublicNoticeList:GetMessageListParameter([@(self.page) description], [@(self.pageSize) description], @"", @"", @"",@"-1") success:^(id json) {
            self.dataArray = json;
            [self.myTableView reloadData];
            [self.myTableView.mj_header endRefreshing];
            [self.myTableView.mj_footer endRefreshing];
        } failed:^(NSError *error) {
            [self.myTableView.mj_header endRefreshing];
            [self.myTableView.mj_footer endRefreshing];
        }];
    }
}

@end
