//
//  PushRequest.h
//  PushNotice
//
//  Created by Golden on 2018/12/27.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RequestSucess)(id json);
typedef void(^RequestFailed)(NSError *error);

@interface PushRequest : NSObject
#pragma mark - 获取新闻，公告，通知列表及详情
//获取新闻列表
+ (void)requestNewsList:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//获取公告列表
+ (void)requestNoticeList:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//获取通知列表
+ (void)requestPublicNoticeList:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
#pragma mark -  上传图片
//上传图片
+ (void)requestUploadFile:(NSDictionary *)param imageDicArray:(NSArray *)imageDicArray imageKeyName:(NSString *)keyName success:(RequestSucess)success failed:(RequestFailed)failed;
#pragma mark -  新闻，公告，通知发布
//获取新闻类型
+ (void)requestNewstype:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//获取第一层部门列表
+ (void)requestDepartlist:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//查询某部门下的子部门以及人员列表
+ (void)requestDepartuserlist:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
#pragma mark - 新闻，公告，通知操作
//添加新闻
+ (void)requestNewsAdd:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//修改新闻
+ (void)requestNewsChange:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//删除新闻
+ (void)requestNewsDel:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//发布新闻
+ (void)requestNewsPush:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;

//添加公告
+ (void)requestNoticeAdd:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//修改公告
+ (void)requestNoticeChange:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//删除公告
+ (void)requestNoticeDel:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//发布公告
+ (void)requestNoticePush:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;

//添加通知
+ (void)requestMessageAdd:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//修改通知
+ (void)requestMessageChange:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//发布通知
+ (void)requestMessagePush:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//取消发布(发布后十分钟内可以取消发布)
+ (void)requestMessageCancel:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
//发送人删除
+ (void)requestMessagesendDel:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed;
@end
