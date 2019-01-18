//
//  PushManager.m
//  PushNotice
//
//  Created by Golden on 2018/12/27.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import "PushManager.h"
#import "PushModel.h"

static PushManager *manager;

@implementation PushManager

+ (instancetype)sharePushManagerInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[PushManager alloc]init];
        manager.selectUserDictionary = [[NSMutableDictionary alloc]init];
        manager.selectDepartDictionary = [[NSMutableDictionary alloc]init];
        manager.departMentArray = [[NSMutableArray alloc]initWithObjects:@"部门", nil];
    });
    return manager;
}

+ (NSMutableArray *)sectionNumberOfPushViewWithInfo:(NSArray<PushVCListModel *> *)modelArray {
    //最后要返回的结果
    NSMutableArray *sectionArray = [[NSMutableArray alloc]init];
    //多行分组和单行分组
    NSMutableArray *mulSection    = [[NSMutableArray alloc]init];
    NSMutableArray *singleSection = [[NSMutableArray alloc]init];
    for (int i = 0; i < modelArray.count; i++) {
        PushVCListModel *model = modelArray[i];
        if ([model.type isEqualToString:@"1"] ||
            [model.type isEqualToString:@"2"] ||
            [model.type isEqualToString:@"3"] ||
            [model.type isEqualToString:@"6"]) {
            [mulSection addObject:model];
        }else {
            [singleSection addObject:model];
        }
    }
    //组合最后要返回的结果
    [sectionArray addObject:mulSection];
    for (int i = 0; i < singleSection.count; i++) {
        [sectionArray addObject:[NSMutableArray arrayWithObject:singleSection[i]]];
    }
    return sectionArray;
}

@end
