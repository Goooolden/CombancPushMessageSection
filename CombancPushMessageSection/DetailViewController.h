//
//  DetailViewController.h
//  PushNotice
//
//  Created by Golden on 2019/1/3.
//  Copyright © 2019年 Combanc. All rights reserved.
//  新闻，通知，消息详情信息

#import <UIKit/UIKit.h>
@class NoticelistModel;

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NoticelistModel *model;

@end
