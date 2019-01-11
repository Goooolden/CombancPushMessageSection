//
//  PushNoticeViewController.h
//  PushNotice
//
//  Created by Golden on 2018/12/26.
//  Copyright © 2018年 Combanc. All rights reserved.
//  发布公告界面

#import <UIKit/UIKit.h>

@interface PushNoticeViewController : UIViewController

@property (nonatomic, copy  ) NSArray  *vcmodelArray;
@property (nonatomic, copy  ) NSString *notieID;
@property (nonatomic, copy  ) NSString *titleString;
@property (nonatomic, copy  ) NSString *contentString;
@property (nonatomic, strong) NSMutableDictionary *configImageDic;

@end
