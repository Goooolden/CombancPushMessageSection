//
//  SelectDepartmentViewController.h
//  PushNotice
//
//  Created by Golden on 2018/12/27.
//  Copyright © 2018年 Combanc. All rights reserved.
//  选择部门人员

#import <UIKit/UIKit.h>

@interface SelectDepartmentViewController : UIViewController

@property (nonatomic, copy  ) NSString *departmentID;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
