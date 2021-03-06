//
//  SelectDepartmentViewController.m
//  PushNotice
//
//  Created by Golden on 2018/12/27.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import "SelectDepartmentViewController.h"
#import "RemoveUserViewController.h"
#import "PushMessageViewController.h"
#import "UIColor+NewsPushCategory.h"
#import "NewsPushDefine.h"
#import "PushRequest.h"
#import "PushManager.h"
#import "PushModel.h"
#import "Masonry.h"

static NSString *const DEPART_CELLID = @"depart_cellID";
static NSString *const USER_CELLID   = @"user_cellID";

@interface SelectDepartmentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) PushManager *manager;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) UIButton *numberButton;
@property (nonatomic, strong) UIButton *selectallBtn;
@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation SelectDepartmentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.numberButton) {
        [self.numberButton setTitle:[NSString stringWithFormat:@"已选择：%lu人",(unsigned long)self.manager.selectUserDictionary.allKeys.count] forState:UIControlStateNormal];
    }
    [self.myTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) {
        if (self.manager.departMentArray.count > 1) {
            [self.manager.departMentArray removeLastObject];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择部门人员";
    [self configBase];
    [self configUI];
}

- (void)configBase {
    //记录选择的人员
    self.selectArray = [[NSMutableArray alloc]init];
    //单例，记录选择的人员
    self.manager = [PushManager sharePushManagerInstance];
    /*
     每次进入页面后，判断上个页面是否是本页面，
     如果是，则根据部门ID请求部门人员
     否则，则请求部门列表(第一次进入)
    */
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [array removeLastObject];
    if (![array.lastObject isKindOfClass:[SelectDepartmentViewController class]]) {
        [self requestDepartment];
    }else {
        [self addSelectAllButton];
        if ([[self.manager.selectDepartDictionary objectForKey:self.departmentID] count] == self.dataArray.count) {
            self.selectallBtn.selected = YES;
            [self.selectallBtn setTitle:@"取消全选" forState:UIControlStateNormal];
        }
    }
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
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(44);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-44);
        }else {
            make.top.equalTo(self.view).offset(44);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-44);
        }
    }];
    
    //顶部视图
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_offset(44);
    }];
    
    self.headerLabel = [[UILabel alloc]init];
    self.headerLabel.textColor = [UIColor darkGrayColor];
    self.headerLabel.font = [UIFont systemFontOfSize:14];
    self.headerLabel.text = [NSString stringWithFormat:@"%@ >",[self.manager.departMentArray componentsJoinedByString:@" > "]];
    [headerView addSubview:self.headerLabel];
    [self.headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(20);
        make.centerY.equalTo(headerView.mas_centerY);
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
    [self.numberButton setTitle:[NSString stringWithFormat:@"已选择：%lu人",(unsigned long)self.manager.selectUserDictionary.allKeys.count] forState:UIControlStateNormal];
    [self.numberButton setTitleColor:RGBA(0, 156, 255, 1) forState:UIControlStateNormal];
    [self.numberButton addTarget:self action:@selector(numberBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
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
    [submitButton addTarget:self action:@selector(submitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(footerView);
        make.width.mas_offset(90);
    }];
}

- (void)addSelectAllButton {
    //全选按钮
    self.selectallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectallBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectallBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selectallBtn.frame = CGRectMake(0, 0, 70, 40);
    [self.selectallBtn addTarget:self action:@selector(selectallBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.selectallBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.selectallBtn];
}

#pragma mark - TableViewDelegate&&DataSourse

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DepartlistModel *model = self.dataArray[indexPath.row];
    if ([model.type isEqualToString:@"depart"]) {
        //部门
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DEPART_CELLID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DEPART_CELLID];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSArray *array = [self.manager.selectDepartDictionary objectForKey:model.id];
        if (array.count > 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@（已选%lu人）",model.name,array.count];
        }else {
            cell.textLabel.text = model.name;
        }
        return cell;
    }else if ([model.type isEqualToString:@"user"]) {
        //用户
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:USER_CELLID];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:USER_CELLID];
        }
        cell.textLabel.text = model.name;
        cell.imageView.image = [UIImage imageNamed:@"PushMessageResource.bundle/approval_assign_rb_false.png"];
        if ([self.manager.selectUserDictionary.allKeys containsObject:model.userId]) {
            cell.imageView.image = [UIImage imageNamed:@"PushMessageResource.bundle/approval_assign_rb_true.png"];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DepartlistModel *model = self.dataArray[indexPath.row];
    if ([model.type isEqualToString:@"depart"]) {
        [self requestUserlist:model.id departmentName:model.name];
    }else if ([model.type isEqualToString:@"user"]) {
        if ([self.manager.selectUserDictionary.allKeys containsObject:model.userId]) {
            [self.manager.selectUserDictionary removeObjectForKey:model.userId];
            [self.selectArray removeObject:model.userId];
        }else {
            [self.manager.selectUserDictionary setObject:model.name forKey:model.userId];
            [self.selectArray addObject:model.userId];
        }
        [self.manager.selectDepartDictionary setObject:self.selectArray forKey:self.departmentID];
        [self.myTableView reloadData];
    }
    [self.numberButton setTitle:[NSString stringWithFormat:@"已选择：%lu人",(unsigned long)self.manager.selectUserDictionary.allKeys.count] forState:UIControlStateNormal];
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

#pragma mark - DoAction
- (void)numberBtnClicked:(UIButton *)sender {
    RemoveUserViewController *removeUserVC = [[RemoveUserViewController alloc]init];
    [self.navigationController pushViewController:removeUserVC animated:YES];
}

- (void)submitButtonClicked:(UIButton *)sender {
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[PushMessageViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

- (void)selectallBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [sender setTitle:@"取消全选" forState:UIControlStateNormal];
        for (DepartlistModel *model in self.dataArray) {
            [self.manager.selectUserDictionary setObject:model.name forKey:model.userId];
            [self.selectArray addObject:model.userId];
        }
        [self.manager.selectDepartDictionary setObject:self.selectArray forKey:self.departmentID];
    }else {
        [sender setTitle:@"全选" forState:UIControlStateNormal];
        for (DepartlistModel *model in self.dataArray) {
            [self.manager.selectUserDictionary removeObjectForKey:model.userId];
            [self.selectArray removeObject:model.userId];
        }
        [self.manager.selectDepartDictionary removeObjectForKey:self.departmentID];
    }
    [self.myTableView reloadData];
    [self.numberButton setTitle:[NSString stringWithFormat:@"已选择：%lu人",(unsigned long)self.manager.selectUserDictionary.allKeys.count] forState:UIControlStateNormal];
}

#pragma mark - RequestAPI
- (void)requestDepartment {
    [PushRequest requestDepartlist:nil success:^(id json) {
        self.dataArray = json;
        [self.myTableView reloadData];
    } failed:^(NSError *error) {}];
}

- (void)requestUserlist:(NSString *)departID departmentName:(NSString *)departName {
    [PushRequest requestDepartuserlist:departUserlistParameter(departID, @"") success:^(id json) {
        [self.manager.departMentArray addObject:departName];
        SelectDepartmentViewController *selectDepart = [[SelectDepartmentViewController alloc]init];
        selectDepart.dataArray = json;
        selectDepart.departmentID = departID;
        [self.navigationController pushViewController:selectDepart animated:YES];
    } failed:^(NSError *error) {}];
}

@end
