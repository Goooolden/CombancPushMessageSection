//
//  PushMessageViewController.h
//  PushNotice
//
//  Created by Golden on 2019/1/3.
//  Copyright © 2019年 Combanc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PushMessageViewController : UIViewController

@property (nonatomic, copy  ) NSArray *vcmodelArray;

@property (nonatomic, copy  ) NSString *messageID;
@property (nonatomic, copy  ) NSString *titleString;
@property (nonatomic, copy  ) NSString *state;         //0:草稿 1:发送
@property (nonatomic, copy  ) NSString *contentString;
@property (nonatomic, strong) NSMutableDictionary *configImageDic;

@end

