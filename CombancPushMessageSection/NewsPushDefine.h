//
//  NewsPushDefine.h
//  PushNotice
//
//  Created by Golden on 2018/12/25.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#ifndef NewsPushDefine_h
#define NewsPushDefine_h

#define RGBA(R/*红*/, G/*绿*/, B/*蓝*/, A/*透明*/)\
[UIColor colorWithRed:R/255.f green:G/255.f blue:B/255.f alpha:A]

#define isNilOrNull(obj) (obj == nil || [obj isEqual:[NSNull null]])

#define setObjectForKey(object) \
do { \
[dictionary setObject:object forKey:@#object]; \
} while (0)

#define setObjectForParameter(object) \
do { \
NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil]; \
NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]; \
[paramDic setObject:str forKey:@"param"]; \
} while (0)

#define K_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define K_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//3.5寸 4/4s @2x
#define K_PHONE_4_SCREEN_WIDTH (320.f)
#define K_PHONE_4_SCREEN_HEIGHT (480.f)
//4寸   5/5s/5c @2x
#define K_PHONE_5_SCREEN_WIDTH (320.f)
#define K_PHONE_5_SCREEN_HEIGHT (568.f)
//4.7寸 6/6s/7/8 @2x
#define K_PHONE_6_SCREEN_WIDTH (375.0f)
#define K_PHONE_6_SCREEN_HEIGHT (667.0f)
//5.5寸 6+/6s+/7+/8+ @3x
#define K_PHONE_7p_SCREEN_WIDTH (414.f)
#define K_PHONE_7p_SCREEN_HEIGHT (736.f)
//5.8寸 x @3x
#define K_PHONE_X_SCREEN_WIDTH (375.f)
#define K_PHONE_X_SCREEN_HEIGHT (812.f)

#define K_DEPENDED_SCREEN_WIDTH K_PHONE_6_SCREEN_WIDTH
#define K_DEPENDED_SCREEN_HEIGHT K_PHONE_6_SCREEN_HEIGHT
#define getWidth(w) ((float)w / K_DEPENDED_SCREEN_WIDTH * K_SCREEN_WIDTH)
#define getHeight(h) ((float)h / K_DEPENDED_SCREEN_HEIGHT * K_SCREEN_HEIGHT)

#define rmStatusBarH ([UIApplication sharedApplication].statusBarFrame.size.height)//(44/20)
#define KIsiPhoneX ((rmStatusBarH == 44.0) ? YES : NO)

#define ImageResources(name) \
[[[NSBundle mainBundle] pathForResource:@"PushMessageResources" ofType:@"bundle"] stringByAppendingPathComponent:name]


#define PushToken (@"token")
#define PushBaseUrl (@"PushBaseUrl")
#define PushImageURL ([NSString stringWithFormat:@"%@/file/upload",[[NSUserDefaults standardUserDefaults] objectForKey:PushBaseUrl]])
#define MyToken [[NSUserDefaults standardUserDefaults] objectForKey:PushToken]
#define BASE_URL ([NSString stringWithFormat:@"%@/oa",[[NSUserDefaults standardUserDefaults] objectForKey:PushBaseUrl]])
#define Basis_URL ([NSString stringWithFormat:@"%@/basis",[[NSUserDefaults standardUserDefaults] objectForKey:PushBaseUrl]])

/**
 上传文件参数
 @param module 新闻sys_news_file,通知sys_notice_file,消息sys_news_file
 */
NS_INLINE NSDictionary *uploadFileParam(NSString *module) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(module);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//请求header
NS_INLINE NSDictionary *header(NSString *token) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    setObjectForKey(token);
    return dictionary;
}

#pragma mark - 新闻
//获取新闻列表
#define GetNewslist_URL ([NSString stringWithFormat:@"%@/news/list",BASE_URL])
/**
 获取新闻列表的参数
 @param page 当前页
 @param pageSize 每页条数
 @param sdate 开始时间
 @param edate 结束时间
 @param types news-type
 @param searchStr 搜索内容
 */
NS_INLINE NSDictionary *newslistParam(NSString *page,NSString *pageSize,NSString *sdate,NSString *edate,NSString *types,NSString *searchStr) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(page);
    setObjectForKey(pageSize);
    setObjectForKey(sdate);
    setObjectForKey(edate);
    setObjectForKey(types);
    setObjectForKey(searchStr);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//添加新闻
#define AddNews_URL ([NSString stringWithFormat:@"%@/news/add",BASE_URL])
NS_INLINE NSDictionary *addNewsParam(NSString *title,NSString *content,NSString *type,NSArray *imageIds,NSArray *fileIds,NSArray *removeIds) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(title);
    setObjectForKey(content);
    setObjectForKey(type);
    setObjectForKey(imageIds);
    setObjectForKey(fileIds);
    setObjectForKey(removeIds);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//修改新闻
#define UpdateNews_URL ([NSString stringWithFormat:@"%@/news/update",BASE_URL])
NS_INLINE NSDictionary *updateNewsParam(NSString *id,NSString *title,NSString *content,NSString *type,NSArray *imageIds,NSArray *fileIds,NSArray *removeIds) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(id);
    setObjectForKey(title);
    setObjectForKey(content);
    setObjectForKey(type);
    setObjectForKey(imageIds);
    setObjectForKey(fileIds);
    setObjectForKey(removeIds);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//删除新闻
#define DelNews_URL ([NSString stringWithFormat:@"%@/news/del",BASE_URL])
NS_INLINE NSDictionary *delNewsParam(NSArray *ids) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(ids);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//发布新闻
#define PublishNews_URL ([NSString stringWithFormat:@"%@/news/publish",BASE_URL])
/**
 @param ids 新闻发布数组
 @param state 状态 1发布 0取消发布 2置顶 1取消置顶
 */
NS_INLINE NSDictionary *publishNewsParam(NSArray *ids,NSString *state) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(ids);
    setObjectForKey(state);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//获取新闻类型
#define Newstype_URL ([NSString stringWithFormat:@"%@/dic/listByCode",BASE_URL])
/**
 @param code 新闻类型是news-type
 */
NS_INLINE NSDictionary *newsTypeParam(NSString *code) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(code);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

#pragma mark - 通知
//获取通知列表(发送人列表)
#define GetMessageList_URL [NSString stringWithFormat:@"%@/msg/send",BASE_URL]
NS_INLINE NSDictionary *GetMessageListParameter(NSString *page, NSString *pageSize, NSString *sdate, NSString *edate, NSString *searchStr,NSString *searchState) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(page);
    setObjectForKey(pageSize);
    setObjectForKey(sdate);
    setObjectForKey(edate);
    setObjectForKey(searchStr);
    setObjectForKey(searchState);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//新增通知
#define AddMessage_URL [NSString stringWithFormat:@"%@/msg/add",BASE_URL]
NS_INLINE NSDictionary *AddMessageParameter(NSString *title, NSString *state, NSString *content, NSString *id, NSArray *userIds,NSArray *imageIds,NSArray *fileIds,NSArray *removeIds) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(title);
    setObjectForKey(state);
    setObjectForKey(content);
    setObjectForKey(id);
    setObjectForKey(userIds);
    setObjectForKey(imageIds);
    setObjectForKey(fileIds);
    setObjectForKey(removeIds);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//修改通知
#define UpdateMessage_URL [NSString stringWithFormat:@"%@/msg/update",BASE_URL]
NS_INLINE NSDictionary *updateMessageParameter(NSString *id,NSString *state,NSString *title,NSString *content,NSArray *imageIds,NSArray *fileIds,NSArray *removeIds, NSArray *userIds) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(id);
    setObjectForKey(state);
    setObjectForKey(title);
    setObjectForKey(content);
    setObjectForKey(imageIds);
    setObjectForKey(fileIds);
    setObjectForKey(removeIds);
    setObjectForKey(userIds);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//发布通知
#define PublishMessage_URL [NSString stringWithFormat:@"%@/msg/publish",BASE_URL]
NS_INLINE NSDictionary *publishMessageParameter(NSString *id) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(id);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//发送人删除
#define DelMessage_URL [NSString stringWithFormat:@"%@/msg/send/del",BASE_URL]
NS_INLINE NSDictionary *delMessageParameter(NSArray *ids) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(ids);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//取消发布(发送消息十分钟内可以取消发布)
#define CancelMessage_URL [NSString stringWithFormat:@"%@/msg/cancel",BASE_URL]
NS_INLINE NSDictionary *cancelMessageParameter(NSString *id) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(id);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//查询第一层部门列表
#define Departlist_URL [NSString stringWithFormat:@"%@/pub/listDepartLayer1",Basis_URL]

//查询某部门下的子部门及部门成员
#define DepartUserlist_URL [NSString stringWithFormat:@"%@/pub/listDepartUsers1",Basis_URL]
NS_INLINE NSDictionary *departUserlistParameter(NSString *parentId,NSString *name) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(parentId);
    setObjectForKey(name);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

#pragma mark - 公告
//获取公告列表
#define GetNoticelist_URL ([NSString stringWithFormat:@"%@/notice/list",BASE_URL])
/**
 获取公告列表的参数
 @param page 当前页
 @param pageSize 每页条数
 @param sdate 开始时间
 @param edate 结束时间
 @param states [1,2]
 @param searchStr 搜索内容
 */
NS_INLINE NSDictionary *noticelistParam(NSString *page,NSString *pageSize,NSString *sdate,NSString *edate,NSArray *states,NSString *searchStr) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(page);
    setObjectForKey(pageSize);
    setObjectForKey(sdate);
    setObjectForKey(edate);
    setObjectForKey(states);
    setObjectForKey(searchStr);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//添加公告
#define AddNotice_URL ([NSString stringWithFormat:@"%@/notice/add",BASE_URL])
NS_INLINE NSDictionary *addNoticeParam(NSString *title,NSString *content,NSString *id,NSArray *imageIds,NSArray *fileIds,NSArray *removeIds) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(title);
    setObjectForKey(content);
    setObjectForKey(id);
    setObjectForKey(imageIds);
    setObjectForKey(fileIds);
    setObjectForKey(removeIds);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//修改公告
#define UpdateNotice_URL ([NSString stringWithFormat:@"%@/notice/update",BASE_URL])
NS_INLINE NSDictionary *updateNoticeParam(NSString *id,NSString *title,NSString *content,NSArray *imageIds,NSArray *fileIds,NSArray *removeIds) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(id);
    setObjectForKey(title);
    setObjectForKey(content);
    setObjectForKey(imageIds);
    setObjectForKey(fileIds);
    setObjectForKey(removeIds);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//删除公告
#define DelNotice_URL ([NSString stringWithFormat:@"%@/notice/del",BASE_URL])
NS_INLINE NSDictionary *delNoticeParam(NSArray *ids) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(ids);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

//发布公告(状态 1发布 0取消发布 2置顶 1取消置顶)
#define PublishNotice_URL ([NSString stringWithFormat:@"%@/notice/publish",BASE_URL])
NS_INLINE NSDictionary *publishNoticeParam(NSArray *ids,NSString *state) {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    setObjectForKey(ids);
    setObjectForKey(state);
    setObjectForParameter(dictionary.copy);
    return paramDic.copy;
}

#endif /* NewsPushDefine_h */
