//
//  PushNewViewController.m
//  PushNotice
//
//  Created by Golden on 2019/1/2.
//  Copyright © 2019年 Combanc. All rights reserved.
//

#import "PushNewViewController.h"
#import "NewsManagerPageViewController.h"
#import "Masonry.h"
#import "PushModel.h"
#import "PushManager.h"
#import "PushRequest.h"
#import "NewsPushDefine.h"
#import "CombancHUD.h"
#import "UIColor+NewsPushCategory.h"

#import "PickerSelectView.h"
#import "ChoiceTableViewCell.h"
#import "TextfieldTableViewCell.h"
#import "TextViewTableViewCell.h"
#import "SelectImageTableViewCell.h"

static NSString *const CHOICE_CELLID    = @"CHOICE_CELLID";
static NSString *const TEXTFIELD_CELLID = @"TEXTFIELD_CELLID";
static NSString *const TEXTVIEW_CELLID  = @"TEXTVIEW_CELLID";
static NSString *const IMAGE_CELLID     = @"IMAGE_CELLID";

@interface PushNewViewController ()<
UITableViewDelegate,
UITableViewDataSource,
ImageSelectViewDelegate>

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *newtypeArray;

@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, assign) BOOL reloadImageView;

@end

@implementation PushNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.sectionArray = [PushManager sectionNumberOfPushViewWithInfo:self.vcmodelArray];
    [self requestNewType];
    [self configBase];
    [self configUI];
}

- (void)configBase {
    self.imageArray = [[NSMutableArray alloc]init];
    if (![PushManager sharePushManagerInstance].isEdite) {
        self.typeID      = @"0";
        self.typeName    = @"不限";
        self.content     = @"";
        self.titleString = @"";
    }else {
        self.reloadImageView = YES;
    }
}

- (void)configUI {
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.myTableView.showsHorizontalScrollIndicator = NO;
    self.myTableView.estimatedRowHeight = 150;
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-44);
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

#pragma mark - TableViewDelegate&&DataSource
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.isRequired = YES;
        cell.nameLabel.text = model.name;
        cell.infoLabel.text = self.typeName;
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
            [self.myTableView beginUpdates];
            [self.myTableView endUpdates];
        } withDidEndEditingBlock:^(NSString *string) {
            self.titleString = string;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
            [self.myTableView beginUpdates];
            [self.myTableView endUpdates];
        } withDidEndEditingBlock:^(NSString *string) {
            self.content = string;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.myTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }];
        cell.infoTextView.text = self.content;
        return cell;
    }else if ([model.type isEqualToString:@"5"]) {
        //uploadImage
        SelectImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IMAGE_CELLID];
        if (!cell) {
            cell = [[SelectImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IMAGE_CELLID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selectView.navDelegate = self;
        __weak typeof(self)weakSelf = self;
        [cell.selectView imageSelectViewDidSelected:^(NSArray *images) {
            weakSelf.reloadImageView = NO;
            NSInteger lines = images.count == 9 ? 3 : ((images.count + 1)%3 == 0 ? 0 : 1) + (images.count + 1)/3;
            cell.selectView.frame = CGRectMake(10, 40, [UIScreen mainScreen].bounds.size.width - 20, getHeight(120) * lines);
            [cell.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.contentView.mas_bottom).offset(- getHeight(120) * lines - 20);
            }];
            self.imageArray = images;
            [self.myTableView reloadData];
        }];
//        cell.isRequired = YES;
        cell.nameLabel.text = model.name;
        /*
         首次进入编辑界面加载图片
         图片进行添加删除操作之后，在selectView的回调中刷新界面，不需要再次加载图片
         */
        if (self.reloadImageView) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[self.configImageDic allKeys]];
            [cell.selectView reloadImageSelectViewWith:array];
        }
        return cell;
    }else if ([model.type isEqualToString:@"6"]) {
        //状态按钮
        ChoiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CHOICE_CELLID];
        if (!cell) {
            cell = [[ChoiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CHOICE_CELLID];
        }
        cell.nameLabel.text = model.name;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PushVCListModel *model = self.sectionArray[indexPath.section][indexPath.row];
    if ([model.key isEqualToString:@"type"]) {
        NSMutableArray *infoArray = [NSMutableArray arrayWithCapacity:10];
        for (NewtypeModel *model in self.newtypeArray) {
            [infoArray addObject:model.name];
        }
        [PickerSelectView showPickerSelecterWithTitle:@"新闻类型" selectInfo:@[infoArray] resultBlock:^(NSArray *selectValue) {
            for (NewtypeModel *model in self.newtypeArray) {
                if ([model.name isEqualToString:selectValue.firstObject]) {
                    self.typeName = selectValue.firstObject;
                    self.typeID = model.id;
                    [self.myTableView reloadData];
                }
            }
        }];
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
        //编辑页面
        [self requestNewChange];
    }else {
        //提交页面
        [self requestNewAdd];
    }
}

#pragma mark - Request
- (void)requestNewType {
    //类型：不限-0
    [PushRequest requestNewstype:newsTypeParam(@"news-type") success:^(id json) {
        NewtypeModel *model = [[NewtypeModel alloc]init];
        model.name = @"不限";
        model.id = @"0";
        self.newtypeArray = (NSMutableArray *)json;
        [self.newtypeArray insertObject:model atIndex:0];
    } failed:^(NSError *error) {
        
    }];
}

- (void)requestNewAdd {
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
                    [PushRequest requestNewsAdd:addNewsParam(self.titleString, self.content, self.typeID, uploadImageIds, [NSArray new], [NSArray new]) success:^(id json) {
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
        [PushRequest requestNewsAdd:addNewsParam(self.titleString, self.content, self.typeID, [NSArray new], [NSArray new], [NSArray new]) success:^(id json) {
            [self requestSuccess];
        } failed:^(NSError *error) {
            [CombancHUD showErrorMessage:@"操作失败"];
        }];
    }
}

- (void)requestNewChange {
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
                    [PushRequest requestNewsChange:updateNewsParam(self.newsID, self.titleString, self.content, self.typeID, uploadImageIds, [NSArray new], removeImageIds) success:^(id json) {
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
        [PushRequest requestNewsChange:updateNewsParam(self.newsID, self.titleString, self.content, self.typeID, uploadImageIds, [NSArray new], removeImageIds) success:^(id json) {
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
