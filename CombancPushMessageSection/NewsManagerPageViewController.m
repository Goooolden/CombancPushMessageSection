//
//  NewsManagerPageViewController.m
//  PushNotice
//
//  Created by Golden on 2018/12/25.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import "NewsManagerPageViewController.h"
#import "NewsManagerViewController.h"
#import "UIColor+NewsPushCategory.h"
#import "NewsPushDefine.h"
#import "PushManager.h"
#import "PushNoticeViewController.h"
#import "PushNewViewController.h"
#import "PushMessageViewController.h"
#import "PushModel.h"
#import "MJExtension.h"

#define BottomHeight

@interface NewsManagerPageViewController ()

@property (nonatomic, strong) NSMutableArray *contentArray;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) UILabel *cancelLabel;
@property (nonatomic, assign) CGFloat bottomHeight;
@property (nonatomic, strong) UIVisualEffectView *HUDView;

@end

@implementation NewsManagerPageViewController

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithCapacity:10];
        [_imageArray addObject:[UIImage imageWithContentsOfFile:ImageResources(@"icon_发布通知.png")]];
        [_imageArray addObject:[UIImage imageWithContentsOfFile:ImageResources(@"icon_发布公告.png")]];
        [_imageArray addObject:[UIImage imageWithContentsOfFile:ImageResources(@"icon_发布新闻.png")]];
    }
    return _imageArray;
}

- (NSMutableArray *)contentArray {
    if (!_contentArray) {
        _contentArray = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < self.imageArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(K_SCREEN_WIDTH - 67, K_SCREEN_HEIGHT - 67 - self.bottomHeight, 50, 50);
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:self.imageArray[i] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 25;
            btn.alpha = 0;
            btn.tag = i;
            [btn addTarget:self action:@selector(pushBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
            [_contentArray addObject:btn];
        }
    }
    return _contentArray;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithCapacity:10];
        NSArray *nameArray = @[@"通知",@"公告",@"新闻"];
        for (int i = 0; i < self.imageArray.count; i++) {
            UILabel *lable = [[UILabel alloc]init];
            lable.frame = CGRectMake(K_SCREEN_WIDTH - 67 - 25, K_SCREEN_HEIGHT - 67 - 10 - self.bottomHeight, 50, 70);
            lable.text = nameArray[i];
            lable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
            lable.alpha = 0;
            [self.view addSubview:lable];
            [_titleArray addObject:lable];
        }
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)init {
    if (self = [super init]) {
        self.bottomHeight = KIsiPhoneX ? 20 : 0;
        self.pageAnimatable = NO;
        self.titleSizeSelected = 16;
        self.titleSizeNormal = 16;
        self.menuViewStyle = WMMenuViewStyleFlood;
        self.titleColorSelected = [UIColor whiteColor];
        self.titleColorNormal = [UIColor colorWithHex:@"#38383d"];
        self.titleFontName = @"PingFangSC-Medium";
        self.menuHeight = 44.0f;
        self.menuItemWidth = K_SCREEN_WIDTH/3;
        self.progressColor = [UIColor colorWithHex:@"#007aff"];
        [self configAddButton];
    }
    return self;
}

- (void)configAddButton {
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(K_SCREEN_WIDTH - 67, K_SCREEN_HEIGHT - 67 - self.bottomHeight, 50, 50);
    addButton.layer.cornerRadius = 25;
    [addButton setBackgroundImage:[UIImage imageWithContentsOfFile:ImageResources(@"icon_发布按钮.png")] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    self.cancelLabel = [[UILabel alloc]init];
    self.cancelLabel.frame = CGRectMake(K_SCREEN_WIDTH - 67 - 25, K_SCREEN_HEIGHT - 67 - 10 - self.bottomHeight, 50, 70);
    self.cancelLabel.text = @"取消";
    self.cancelLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    self.cancelLabel.hidden = YES;
    [self.view addSubview:self.cancelLabel];
}

- (NSArray *)titles {
    return @[@"新闻",@"公告",@"通知"];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titles.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return self.titles[index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    NewsManagerViewController *managerVC = [[NewsManagerViewController alloc]init];
    PushManager *manager = [PushManager sharePushManagerInstance];
    switch (index) {
        case 0:{
            manager.pushType = PushNewType;
            break;
        }
        case 1:{
            manager.pushType = PushNoticeType;
            break;
        }
        case 2:{
            manager.pushType = PushMessageType;
            break;
        }
        default:
            break;
    }
    return managerVC;
}

- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    PushManager *manager = [PushManager sharePushManagerInstance];
    switch ([info[@"index"] integerValue]) {
        case 0:{
            manager.pushType = PushNewType;
            break;
        }
        case 1:{
            manager.pushType = PushNoticeType;
            break;
        }
        case 2: {
            manager.pushType = PushMessageType;
            break;
        }
        default:
            break;
    }
}

//点击添加按钮
- (void)addBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    //添加虚化背景
    if (sender.selected) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        self.HUDView = [[UIVisualEffectView alloc] initWithEffect:blur];
        self.HUDView.alpha = 0.9f;
        self.HUDView.frame = CGRectMake(0, 0, K_SCREEN_WIDTH, K_SCREEN_HEIGHT);
        [self.view addSubview:self.HUDView];
        [self.view bringSubviewToFront:sender];
        self.cancelLabel.hidden = NO;
        [self.view bringSubviewToFront:self.cancelLabel];
    }else {
        [self.HUDView removeFromSuperview];
        self.HUDView = nil;
        self.cancelLabel.hidden = YES;
    }
    //添加弹出动画以及旋转动画
    [self.contentArray enumerateObjectsUsingBlock:^(id obj,NSUInteger idx,BOOL*stop) {
        UIButton *btn = obj;
        CGFloat x = btn.frame.origin.x;
        CGFloat y = btn.frame.origin.y;
        CGFloat width = btn.frame.size.width;
        CGFloat height = btn.frame.size.height;
        btn.alpha = 0;
        
        UILabel *label = self.titleArray[idx];
        CGFloat labelx = label.frame.origin.x;
        CGFloat labely = label.frame.origin.y;
        CGFloat labelwidth = label.frame.size.width;
        CGFloat labelheight = label.frame.size.height;
        label.alpha = 0;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(idx*0.03*NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:26 options:UIViewAnimationOptionCurveEaseIn animations:^{
                if (sender.selected) {
                    [self.view bringSubviewToFront:btn];
                    btn.frame = CGRectMake(x, y - 47 - idx * 50, width, height);
                    btn.alpha = 1;
                    [self.view bringSubviewToFront:label];
                    label.frame = CGRectMake(labelx, labely - 47 - idx * 50, labelwidth, labelheight);
                    label.alpha = 1;
                }else {
                    btn.alpha = 0;
                    label.alpha = 0;
                    btn.frame = CGRectMake(x, y + 47 + idx * 50, width, height);
                    label.frame = CGRectMake(labelx, labely + 47 + idx * 50, labelwidth, labelheight);
                }
            } completion:^(BOOL finished) {}];
            
            [UIView animateWithDuration:0.3 animations:^{
                if (sender.selected) {
                    sender.transform = CGAffineTransformMakeRotation(M_PI_4);
                }else {
                    sender.transform = CGAffineTransformIdentity;
                }
            }];
        });
    }];
}

//点击新闻，通知，公告按钮
- (void)pushBtnClick:(UIButton *)sender {
    [PushManager sharePushManagerInstance].isEdite = NO;
    [PushManager sharePushManagerInstance].selectUserDictionary = [[NSMutableDictionary alloc]init];

    if (sender.tag == 0) {
        //发布通知
        PushMessageViewController *messageVC = [[PushMessageViewController alloc]init];
        messageVC.vcmodelArray = [self getData:@"PushMessage"];
        [self.navigationController pushViewController:messageVC animated:YES];
    }else if (sender.tag == 1) {
        //发布公告
        PushNoticeViewController *noticeVC = [[PushNoticeViewController alloc]init];
        noticeVC.vcmodelArray = [self getData:@"PushNotice"];
        [self.navigationController pushViewController:noticeVC animated:YES];
    }else if (sender.tag == 2) {
        //发布新闻
        PushNewViewController *newsVC = [[PushNewViewController alloc]init];
        newsVC.vcmodelArray = [self getData:@"PushNew"];
        [self.navigationController pushViewController:newsVC animated:YES];
    }
}

//获取发布页面布局Model
- (NSArray *)getData:(NSString *)resourceName {
    NSString *path = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return [PushVCListModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
}

@end
