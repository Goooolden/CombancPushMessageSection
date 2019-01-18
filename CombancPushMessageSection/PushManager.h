//
//  PushManager.h
//  PushNotice
//
//  Created by Golden on 2018/12/27.
//  Copyright © 2018年 Combanc. All rights reserved.
//  新闻通知公告的管理类

#import <Foundation/Foundation.h>
@class PushModel;

typedef enum PushType {
    PushNewType = 0,
    PushNoticeType,
    PushMessageType
}PushType;

@interface PushManager : NSObject
/**
 记录选中的人员ID及名字
 {
 userId:name;
 }
 */
@property (nonatomic, strong) NSMutableDictionary *selectUserDictionary;

/**
 记录部门被选择的人员数目
 */
@property (nonatomic, strong) NSMutableDictionary *selectDepartDictionary;

/**
 发布消息选择部门信息
 */
@property (nonatomic, strong) NSMutableArray *departMentArray;

/**
 记录进入了哪个模块
 */
@property (nonatomic, assign) PushType pushType;

/**
 是否可编辑
 */
@property (nonatomic, assign) BOOL isEdite;

/**
 刷新page页面
 */
@property (nonatomic, assign) BOOL refreshPageViewController;

/**
 返回发布界面的Section数组

 @param modelArray PushNotice.json解析的模型数组
 @return 返回发布界面的section数组
 */
+ (NSMutableArray *)sectionNumberOfPushViewWithInfo:(NSArray<PushModel *> *)modelArray;

+ (instancetype)sharePushManagerInstance;

@end
