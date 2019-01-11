//
//  PushModel.h
//  PushNotice
//
//  Created by Golden on 2018/12/27.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushModel : NSObject
/*
 @property (nonatomic, copy) NSString *<#object#>;
 */
@end

@interface PushVCListModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;/*
                                            1 : 单选
                                            2 : selectTime
                                            3 : cellWithTextView
                                            4 : textView
                                            5 : uploadImage
                                            6 : cellWithStateButton
                                            */
@property (nonatomic, copy) NSString *key;
@end

//新闻列表数据模型
@interface NewsListModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *stateStr;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, copy) NSArray  *files;
@property (nonatomic, copy) NSArray  *imgs;
@end

//通知公告数据模型
@interface NoticeListModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *stateStr;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *typeStr;
@property (nonatomic, copy) NSArray  *files;
@property (nonatomic, copy) NSArray  *imgs;
@property (nonatomic, copy) NSArray  *users;
@property (nonatomic, copy) NSString *schoolId;   //通知
@property (nonatomic, copy) NSString *schoolName; //通知
@property (nonatomic, assign) BOOL isDel;         //通知是否删除
@property (nonatomic, assign) BOOL cancel;        //通知是否取消
@end

@interface NoticeFileImgModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *tabledId;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@end

@interface MessageUsersModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *isRead;
@end

//新闻类型数据模型
@interface NewtypeModel : NSObject
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *layer;
@property (nonatomic, copy) NSString *sys;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *isParent;
@property (nonatomic, copy) NSString *pId;
@end

//部门列表以及部门人员
@interface DepartlistModel : NSObject
//部门列表
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *pId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *room;
@property (nonatomic, copy) NSString *discrib;
@property (nonatomic, copy) NSString *layer;
@property (nonatomic, copy) NSString *sortNum;
@property (nonatomic, copy) NSString *type;      //depart || user
//部门人员
//@property (nonatomic, copy) NSString *id;
//@property (nonatomic, copy) NSString *pId;
//@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userId;
//@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *username;
//@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *telePhone;
@end

