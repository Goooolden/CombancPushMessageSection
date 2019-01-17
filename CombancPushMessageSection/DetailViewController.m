//
//  DetailViewController.m
//  PushNotice
//
//  Created by Golden on 2019/1/3.
//  Copyright © 2019年 Combanc. All rights reserved.
//

#import "DetailViewController.h"
#import "NewsPushDefine.h"
#import "PushNewViewController.h"
#import "PushNoticeViewController.h"
#import "PushMessageViewController.h"
#import "PushManager.h"
#import "PushRequest.h"
#import "MJExtension.h"
#import "PushModel.h"
#import "Masonry.h"
#import "CombancHUD.h"

@interface DetailViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) PushManager *manager;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.manager = [PushManager sharePushManagerInstance];
    [self configUI];
    [self reloadData];
    self.title = @"详情";
}

- (void)configUI {
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
            make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.edges.equalTo(self.view);
        }
    }];
    [self.webView loadHTMLString:[self.model.content stringByReplacingOccurrencesOfString:@"\n" withString:@""] baseURL:nil];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    [rightButton setImage:[UIImage imageWithContentsOfFile:ImageResources(@"icon_三点.png")] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];;
}

- (void)reloadData {
    NSString *htmlString = [self.model.content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSArray *headHtml = [htmlString componentsSeparatedByString:@"<body>"];
    NSArray *bodyHtml = [[headHtml lastObject] componentsSeparatedByString:@"</body>"];
    
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"CombancNewsDetail.css" withExtension:nil]];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendString:[self combineDetailWithBody:[bodyHtml firstObject]]];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    [self.webView loadHTMLString:html baseURL:nil];
}

- (NSString *)combineDetailWithBody:(NSString *)bodyHtml {
    NSMutableString *body = [NSMutableString string];
    //添加标题和作者
    [body appendFormat:@"<div class=\"title\">%@</div>",self.model.title];
    NSString *time = [NSString stringWithFormat:@"发布时间：%@",self.model.publishTime];
    NSString *author = [NSString stringWithFormat:@"发布人：%@",self.model.userName];
    [body appendFormat:@"<div class=\"time\"> %@ &nbsp %@</div>",author,time];
    //添加主题内容
    bodyHtml = [bodyHtml stringByReplacingOccurrencesOfString:@"src=\".." withString:[NSString stringWithFormat:@"src=\"%@",[BASE_URL stringByReplacingOccurrencesOfString:@"/micro/oa" withString:@""]]];
    [body appendFormat:@"<div class=\"contentText\">%@</div>", bodyHtml];
    //添加图片
    NSString *onload = @"this.onclick = function() {"
    "  window.location.href = 'combanc:src=' +this.src;"
    "};";
    for (NoticeFileImgModel *model in self.model.imgs) {
        NSString *imagePath = [NSString stringWithFormat:@"%@%@", PushImageURL, model.path];
        NSString *imageStr = [NSString stringWithFormat:@"<img src=\"%@\" onload=\"%@\" style= height=\"250px\"; width=\"100%%\"", imagePath,onload];
        [body appendFormat:@"<div class=\"imageList\"><br>%@</div>",imageStr];
    }
    //添加附件
    for (NoticeFileImgModel *model in self.model.files) {
        NSString *filePath = [NSString stringWithFormat:@"%@%@", PushImageURL, model.path];
        [body appendFormat:@"<a href= %@> %@ </a> <br />",filePath,model.name];
    }
    return body;
}


#pragma mark - DoAction
- (void)rightBtnClicked:(UIButton *)sender {
    // 1发布 0取消发布 2置顶 1取消置顶
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    NSString *pushState   = @"1"; //发布，取消置顶
    NSString *cancelState = @"0"; //取消发布
    NSString *topState    = @"2"; //置顶
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"置顶" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.manager.pushType == PushNewType) {
            [PushRequest requestNewsPush:publishNewsParam(@[self.model.id], topState) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }else if (self.manager.pushType == PushNoticeType) {
            [PushRequest requestNoticePush:publishNoticeParam(@[self.model.id], topState) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }else if (self.manager.pushType == PushMessageType) {
            
        }
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消置顶" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.manager.pushType == PushNewType) {
            [PushRequest requestNewsPush:publishNewsParam(@[self.model.id], pushState) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }else if (self.manager.pushType == PushNoticeType) {
            [PushRequest requestNoticePush:publishNoticeParam(@[self.model.id], pushState) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }else if (self.manager.pushType == PushMessageType) {
            
        }
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.manager.pushType == PushNewType) {
            [PushRequest requestNewsDel:delNewsParam(@[self.model.id]) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }else if (self.manager.pushType == PushNoticeType) {
            [PushRequest requestNoticeDel:delNoticeParam(@[self.model.id]) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }else if (self.manager.pushType == PushMessageType) {
            [PushRequest requestMessagesendDel:delMessageParameter(@[self.model.id]) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.manager.pushType == PushNewType) {
            [PushRequest requestNewsPush:publishNewsParam(@[self.model.id], pushState) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }else if (self.manager.pushType == PushNoticeType) {
            [PushRequest requestNoticePush:publishNoticeParam(@[self.model.id], pushState) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }
    }];
    UIAlertAction *action5 = [UIAlertAction actionWithTitle:@"取消发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.manager.pushType == PushNewType) {
            [PushRequest requestNewsPush:publishNewsParam(@[self.model.id], cancelState) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }else if (self.manager.pushType == PushNoticeType) {
            [PushRequest requestNoticePush:publishNoticeParam(@[self.model.id], cancelState) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }
    }];
    UIAlertAction *action6 = [UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.manager.isEdite = YES;
        NSMutableDictionary *imageDic = [[NSMutableDictionary alloc]init];
        if (self.manager.pushType == PushNewType) {
            PushNewViewController *pushVC = [[PushNewViewController alloc]init];
            pushVC.newsID      = self.model.id;
            pushVC.titleString = self.model.title;
            pushVC.typeName    = self.model.typeStr;
            pushVC.typeID      = self.model.type;
            pushVC.content     = self.model.content;
            for (NoticeFileImgModel *model in self.model.imgs) {
                NSString *imagePath = [NSString stringWithFormat:@"%@%@", PushImageURL, model.path];
                [imageDic setObject:model.fileId forKey:imagePath];
            }
            pushVC.configImageDic = imageDic;
            pushVC.vcmodelArray = [self getData:@"PushNew"];
            pushVC.title = @"编辑新闻";
            [self.navigationController pushViewController:pushVC animated:YES];
        }else if (self.manager.pushType == PushNoticeType) {
            PushNoticeViewController *pushVC = [[PushNoticeViewController alloc]init];
            pushVC.notieID       = self.model.id;
            pushVC.titleString   = self.model.title;
            pushVC.contentString = self.model.content;
            for (NoticeFileImgModel *model in self.model.imgs) {
                NSString *imagePath = [NSString stringWithFormat:@"%@%@", PushImageURL, model.path];
                [imageDic setObject:model.fileId forKey:imagePath];
            }
            pushVC.configImageDic = imageDic;
            pushVC.vcmodelArray = [self getData:@"PushNotice"];
            pushVC.title = @"编辑通知";
            [self.navigationController pushViewController:pushVC animated:YES];
        }else if (self.manager.pushType == PushMessageType) {
            PushMessageViewController *pushVC = [[PushMessageViewController alloc]init];
            pushVC.messageID     = self.model.id;
            pushVC.titleString   = self.model.title;
            pushVC.contentString = self.model.content;
            pushVC.state         = self.model.state;
            for (NoticeFileImgModel *model in self.model.imgs) {
                NSString *imagePath = [NSString stringWithFormat:@"%@%@", PushImageURL, model.path];
                [imageDic setObject:model.fileId forKey:imagePath];
            }
            self.manager.selectUserDictionary = [[NSMutableDictionary alloc]init];
            for (MessageUsersModel *model in self.model.users) {
                [self.manager.selectUserDictionary setObject:model.name forKey:model.id];
            }
            pushVC.configImageDic = imageDic;
            pushVC.vcmodelArray = [self getData:@"EditMessage"];
            pushVC.title = @"编辑消息";
            [self.navigationController pushViewController:pushVC animated:YES];
        }
    }];
    UIAlertAction *action7 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击了取消");
    }];
    
    UIAlertAction *action8 = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.manager.pushType == PushMessageType) {
            [PushRequest requestMessagePush:publishMessageParameter(self.model.id) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }
    }];
    UIAlertAction *action9 = [UIAlertAction actionWithTitle:@"撤销" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.manager.pushType == PushMessageType) {
            [PushRequest requestMessageCancel:cancelMessageParameter(self.model.id) success:^(id json) {
                [CombancHUD showSuccessMessage:@"操作成功"];
            } failed:^(NSError *error) {
                [CombancHUD showErrorMessage:@"操作失败"];
            }];
        }
    }];
    
    //把action添加到actionSheet里
    if (self.manager.pushType == PushNewType || self.manager.pushType == PushNoticeType) {
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [actionSheet addAction:action3];
        [actionSheet addAction:action4];
        [actionSheet addAction:action5];
        [actionSheet addAction:action6];
        [actionSheet addAction:action7];
    }else if (self.manager.pushType == PushMessageType) {
        if ([self.model.state isEqualToString:@"1"]) {
            if (self.model.cancel) {
                //删除 取消发布
                [actionSheet addAction:action3];
                [actionSheet addAction:action9];
                [actionSheet addAction:action7];
            }else {
                //删除
                [actionSheet addAction:action3];
                [actionSheet addAction:action7];
            }
        }else {
            //删除 发布 修改
            [actionSheet addAction:action3];
            [actionSheet addAction:action8];
            [actionSheet addAction:action6];
            [actionSheet addAction:action7];
        }
    }

    //相当于之前的[actionSheet show];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

//获取发布页面布局Model
- (NSArray *)getData:(NSString *)resourceName {
    NSString *path = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return [PushVCListModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
}
@end
