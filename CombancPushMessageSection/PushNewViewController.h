//
//  PushNewViewController.h
//  PushNotice
//
//  Created by Golden on 2019/1/2.
//  Copyright © 2019年 Combanc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewsManagerPageViewController;

@interface PushNewViewController : UIViewController

@property (nonatomic, copy  ) NSArray  *vcmodelArray;
@property (nonatomic, copy  ) NSString *newsID;
@property (nonatomic, copy  ) NSString *titleString;
@property (nonatomic, copy  ) NSString *typeName;
@property (nonatomic, copy  ) NSString *typeID;
@property (nonatomic, copy  ) NSString *content;
@property (nonatomic, strong) NSMutableDictionary *configImageDic;

@end
