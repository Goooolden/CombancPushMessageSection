//
//  PushMessageViewController.m
//  PushNotice
//
//  Created by Golden on 2019/1/3.
//  Copyright © 2019年 Combanc. All rights reserved.
//

#import "PushMessageViewController.h"
#import "SelectDepartmentViewController.h"
#import "SelectPeopleViewController.h"
#import "NewsManagerPageViewController.h"
#import "CombancHUD.h"
#import "NewsPushDefine.h"
#import "PushRequest.h"
#import "PushManager.h"
#import "PushModel.h"
#import "Masonry.h"

#import "ChoiceTableViewCell.h"
#import "TextfieldTableViewCell.h"
#import "TextViewTableViewCell.h"
#import "SelectImageTableViewCell.h"
#import "PushStateTableViewCell.h"

static NSString *const CHOICE_CELLID    = @"CHOICE_CELLID";
static NSString *const TEXTFIELD_CELLID = @"TEXTFIELD_CELLID";
static NSString *const TEXTVIEW_CELLID  = @"TEXTVIEW_CELLID";
static NSString *const IMAGE_CELLID     = @"IMAGE_CELLID";
static NSString *const STATE_CELLID     = @"STATE_CELLID";

@interface PushMessageViewController ()<
UITableViewDelegate,
UITableViewDataSource,
ImageSelectViewDelegate>

@property (nonatomic, strong) UITableView *mytableView;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, assign) BOOL reloadImageView;

@end

@implementation PushMessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([PushManager sharePushManagerInstance].selectUserDictionary.allValues.count > 0) {
        [self.mytableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configBase];
    [self configUI];
}

- (void)configBase {
    self.view.backgroundColor = [UIColor whiteColor];
    self.sectionArray = [PushManager sectionNumberOfPushViewWithInfo:self.vcmodelArray];
    self.imageArray = [[NSMutableArray alloc]init];
    if (![PushManager sharePushManagerInstance].isEdite) {
        self.titleString = @"";
        self.state = @"0";
        self.contentString = @"";
    }else {
        self.reloadImageView = YES;
    }
}

- (void)configUI {
    self.mytableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.mytableView.delegate = self;
    self.mytableView.dataSource = self;
    self.mytableView.showsVerticalScrollIndicator = NO;
    self.mytableView.showsHorizontalScrollIndicator = NO;
    self.mytableView.estimatedRowHeight = 150;
    self.mytableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.mytableView];
    [self.mytableView mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    submitButton.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton setTitleColor:RGBA(0, 156, 255, 1) forState:UIControlStateNormal];
    [submitButton setBackgroundColor:[UIColor whiteColor]];
    [submitButton addTarget:self action:@selector(submitClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
}

#pragma mark - UITableViewDelegate&&DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PushVCListModel *model = self.sectionArray[indexPath.section][indexPath.row];
    return [self createCellWithTableView:tableView pushVClistModel:model];
}

- (id)createCellWithTableView:(UITableView *)tableView pushVClistModel:(PushVCListModel *)model {
    //    1 : 单选
    //    2 : selectTime
    //    3 : cellWithTextView
    //    4 : textView
    //    5 : uploadImage
    //    6 : cellWithStateButton
    if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"2"]) {
        //单选
        ChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHOICE_CELLID];
        if (!cell) {
            cell = [[ChoiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CHOICE_CELLID];
        }
        cell.nameLabel.text = model.name;
//        cell.isRequired = YES;
        cell.infoLabel.text = [[PushManager sharePushManagerInstance].selectUserDictionary.allValues componentsJoinedByString:@","];
        return cell;
    }else if ([model.type isEqualToString:@"3"]) {
        //cellWithTextView
        TextfieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXTFIELD_CELLID];
        if (!cell) {
            cell = [[TextfieldTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TEXTFIELD_CELLID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.isRequired = YES;
        [cell textViewDidChange:^{
            [self.mytableView beginUpdates];
            [self.mytableView endUpdates];
        } withDidEndEditingBlock:^(NSString *string) {
            self.titleString = string;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.mytableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }];
        cell.nameLabel.text = model.name;
        cell.infoTextView.text = self.titleString;
        return cell;
    }else if ([model.type isEqualToString:@"4"]) {
        //textView
        TextViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TEXTVIEW_CELLID];
        if (!cell) {
            cell = [[TextViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TEXTVIEW_CELLID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = model.name;
        cell.wordLimt = 500;
        [cell textViewDidChange:^{
            [self.mytableView beginUpdates];
            [self.mytableView endUpdates];
        } withDidEndEditingBlock:^(NSString *string) {
            self.contentString = string;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.mytableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }];
        cell.infoTextView.text = self.contentString;
        return cell;
    }else if ([model.type isEqualToString:@"5"]) {
        //uploadImage
        SelectImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IMAGE_CELLID];
        if (!cell) {
            cell = [[SelectImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IMAGE_CELLID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectView.navDelegate = self;
        __weak typeof(self) weakSelef = self;
        [cell.selectView imageSelectViewDidSelected:^(NSArray *images) {
            weakSelef.reloadImageView = NO;
            NSInteger lines = images.count == 9 ? 3 : ((images.count + 1)%3 == 0 ? 0 : 1) + (images.count + 1)/3;
            cell.selectView.frame = CGRectMake(10, 40, [UIScreen mainScreen].bounds.size.width - 20, getHeight(120) * lines);
            [cell.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.contentView.mas_bottom).offset(- getHeight(120) * lines - 20);
            }];
            self.imageArray = images;
            [self.mytableView reloadData];
        }];
        cell.nameLabel.text = model.name;
        if (self.reloadImageView) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[self.configImageDic allKeys]];
            [cell.selectView reloadImageSelectViewWith:array];
        }
        return cell;
    }else if ([model.type isEqualToString:@"6"]) {
        //状态按钮
        PushStateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:STATE_CELLID];
        if (!cell) {
            cell = [[PushStateTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:STATE_CELLID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nameLabel.text = @"状态";
//        cell.isRequired = YES;
        __weak typeof(self) weakSelf = self;
        [cell setStateSelectedBlock:^(NSString *state) {
            weakSelf.state = state;
        }];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PushVCListModel *model = self.sectionArray[indexPath.section][indexPath.row];
    if ([model.key isEqualToString:@"user"]) {
        SelectDepartmentViewController *selectVC = [[SelectDepartmentViewController alloc]init];
        [self.navigationController pushViewController:selectVC animated:YES];
    }
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
    return 0.001f;
}

#pragma mark - DoAction
- (void)submitClicked:(UIButton *)sender {
    if ([PushManager sharePushManagerInstance].isEdite) {
        [self requestMessageChange];
    }else {
        [self requestMessageAdd];
    }
}

- (void)requestMessageAdd {
    PushManager *manager = [PushManager sharePushManagerInstance];
    NSMutableArray *uploadImageIds = [[NSMutableArray alloc]init];
    NSMutableArray *uploadImage = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.imageArray.count; i++) {
        if ([self.imageArray[i] isKindOfClass:[UIImage class]]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:self.imageArray[i] forKey:@"image"];
            [dic setObject:[NSString stringWithFormat:@"%d.png",i] forKey:@"imageName"];
            [uploadImage addObject:[NSArray arrayWithObject:dic]];
        }
    }
    
    if (uploadImage.count > 0) {
        for (int i = 0; i < uploadImage.count; i++) {
            [PushRequest requestUploadFile:uploadFileParam(@"sys_news_img") imageDicArray:uploadImage[i] imageKeyName:@"file" success:^(id json) {
                [uploadImageIds addObject:json[@"id"]];
                if (uploadImageIds.count == uploadImage.count) {
                    [PushRequest requestMessageAdd:AddMessageParameter(self.titleString, self.state, self.contentString, @"0", manager.selectUserDictionary.allKeys, uploadImageIds, [NSArray new], [NSArray new]) success:^(id json) {
                        [self requestSuccess];
                    } failed:^(NSError *error) {
                        [CombancHUD showErrorMessage:@"操作失败"];
                    }];
                }
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }
    }else {
        [PushRequest requestMessageAdd:AddMessageParameter(self.titleString, self.state, self.contentString, @"0", manager.selectUserDictionary.allKeys, [NSArray new], [NSArray new], [NSArray new]) success:^(id json) {
            [self requestSuccess];
        } failed:^(NSError *error) {
            [CombancHUD showErrorMessage:@"操作失败"];
        }];
    }
}

- (void)requestMessageChange {
    PushManager *manager = [PushManager sharePushManagerInstance];
    //编辑前图片id
    NSArray *configImagePath = [self.configImageDic allKeys];
    //已上传图片的id
    NSMutableArray *uploadImageIds = [[NSMutableArray alloc]init];
    //删除的图片id
    NSMutableArray *removeImageIds = [[NSMutableArray alloc]init];
    //新加需要上传的图片数组
    NSMutableArray *uploadImage = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < self.imageArray.count; i++) {
        for (int j = 0; j < configImagePath.count; j++) {
            if ([self.imageArray[i] isKindOfClass:[NSString class]] &&
                [self.imageArray[i] isEqualToString:configImagePath[j]]) {
                [uploadImageIds addObject:self.configImageDic[configImagePath[j]]];
            }
        }
    }
    
    for (int i = 0; i < configImagePath.count; i++) {
        if (![uploadImageIds containsObject:self.configImageDic[configImagePath[i]]]) {
            [removeImageIds addObject:self.configImageDic[configImagePath[i]]];
        }
    }
    
    for (int i = 0; i < self.imageArray.count; i++) {
        if ([self.imageArray[i] isKindOfClass:[UIImage class]]) {
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:self.imageArray[i] forKey:@"image"];
            [dic setObject:[NSString stringWithFormat:@"%d.png",i] forKey:@"imageName"];
            [uploadImage addObject:[NSArray arrayWithObject:dic]];
        }
    }
    
    if (uploadImage.count > 0) {
        for (int i = 0; i < uploadImage.count; i ++) {
            [PushRequest requestUploadFile:uploadFileParam(@"sys_news_img") imageDicArray:uploadImage[i] imageKeyName:@"file" success:^(id json) {
                [uploadImageIds addObject:json[@"id"]];
                if (uploadImageIds.count == self.imageArray.count) {
                    [PushRequest requestMessageChange:updateMessageParameter(self.messageID, self.state, self.titleString, self.contentString, uploadImageIds, [NSArray new], removeImageIds, [manager.selectUserDictionary allKeys]) success:^(id json) {
                        [self requestSuccess];
                    } failed:^(NSError *error) {
                        [CombancHUD showErrorMessage:@"操作失败"];
                    }];
                }
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }
    }else {
        [PushRequest requestMessageChange:updateMessageParameter(self.messageID, self.state, self.titleString, self.contentString, uploadImageIds, [NSArray new], removeImageIds, [manager.selectUserDictionary allKeys]) success:^(id json) {
            [self requestSuccess];
        } failed:^(NSError *error) {
            [CombancHUD showErrorMessage:@"操作失败"];
        }];
    }
}

- (void)requestSuccess {
    [PushManager sharePushManagerInstance].refreshPageViewController = YES;
    [CombancHUD showSuccessMessage:@"操作成功"];
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isEqual:[NewsManagerPageViewController class]]) {
            [self.navigationController popToViewController:viewController animated:YES];
        }
    }
}

@end
