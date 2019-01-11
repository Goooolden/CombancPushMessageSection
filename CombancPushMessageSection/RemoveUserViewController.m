//
//  RemoveUserViewController.m
//  PushNotice
//
//  Created by Golden on 2019/1/7.
//  Copyright © 2019年 Combanc. All rights reserved.
//

#import "RemoveUserViewController.h"
#import "NewsPushDefine.h"
#import "PushManager.h"
#import "Masonry.h"

static NSString *const REMOVE_CELLID = @"remove_cellid";

@interface RemoveUserViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) PushManager *manager;
@property (nonatomic, strong) UIButton *numberButton;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation RemoveUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选中人员";
    self.manager = [PushManager sharePushManagerInstance];
    self.dataArray = [NSMutableArray arrayWithArray:self.manager.selectUserDictionary.allKeys];
    [self configUI];
}

- (void)configUI {
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 150;
    self.myTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(44);
        }else {
            make.left.right.top.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(44);
        }
    }];
    
    //底部视图
    UIView *footerView = [[UIView alloc]init];
    footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_offset(44);
    }];
    
    self.numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.numberButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:15];
    [self.numberButton setTitle:[NSString stringWithFormat:@"已选择：%lu人",(unsigned long)self.dataArray.count] forState:UIControlStateNormal];
    [self.numberButton setTitleColor:RGBA(0, 156, 255, 1) forState:UIControlStateNormal];
    [footerView addSubview:self.numberButton];
    [self.numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(footerView);
        make.left.equalTo(footerView).offset(20);
    }];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    submitButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    [submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [submitButton setTitleColor:RGBA(255, 255, 255, 1) forState:UIControlStateNormal];
    [submitButton setBackgroundColor:RGBA(0, 165, 255, 1)];
    [footerView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(footerView);
        make.width.mas_offset(90);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:REMOVE_CELLID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:REMOVE_CELLID];
        UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        removeBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
        [removeBtn setTitle:@"移除" forState:UIControlStateNormal];
        [removeBtn setTitleColor:RGBA(255, 76, 121, 1) forState:UIControlStateNormal];
        removeBtn.layer.masksToBounds = YES;
        removeBtn.layer.cornerRadius = 7;
        removeBtn.layer.borderWidth = 1;
        removeBtn.layer.borderColor = RGBA(255, 76, 121, 1).CGColor;
        removeBtn.tag = indexPath.row;
        [removeBtn addTarget:self action:@selector(removeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:removeBtn];
        [removeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-20);
            make.width.mas_offset(54);
            make.height.mas_offset(24);
        }];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [self.manager.selectUserDictionary objectForKey:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - DoAction
- (void)removeBtnClicked:(UIButton *)sender {
    NSString *userID = self.dataArray[sender.tag];
    [self.manager.selectUserDictionary removeObjectForKey:userID];
    [self.dataArray removeObjectAtIndex:sender.tag];
    [self.myTableView reloadData];
    [self.numberButton setTitle:[NSString stringWithFormat:@"已选择：%lu人",(unsigned long)self.dataArray.count] forState:UIControlStateNormal];
}

@end
