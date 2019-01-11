//
//  SelectPeopleViewController.m
//  PushNotice
//
//  Created by Golden on 2018/12/27.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import "SelectPeopleViewController.h"
#import "SelectDepartmentViewController.h"
#import "NewsPushDefine.h"
#import "Masonry.h"

static NSString *const CELL_ID = @"cellID";

@interface SelectPeopleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, copy  ) NSArray *sectionArray;

@end

@implementation SelectPeopleViewController

- (NSArray *)sectionArray {
    if (!_sectionArray) {
        _sectionArray = @[@{@"image":@"icon_选择人员_部门",@"name":@"按部门选择"},
                          @{@"image":@"icon_选择人员_年级",@"name":@"按年级选择"},
                          @{@"image":@"icon_选择人员_分组",@"name":@"按分组选择"}];
    }
    return _sectionArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择人员";
    [self configUI];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELL_ID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.sectionArray[indexPath.row][@"name"];
    NSString *imageName = self.sectionArray[indexPath.row][@"image"];
    cell.imageView.image = [UIImage imageWithContentsOfFile:ImageResources(imageName)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SelectDepartmentViewController *departmentVC = [[SelectDepartmentViewController alloc]init];
    [self.navigationController pushViewController:departmentVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001f;
}

@end
