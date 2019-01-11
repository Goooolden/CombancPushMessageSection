//
//  PushRequest.m
//  PushNotice
//
//  Created by Golden on 2018/12/27.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import "PushRequest.h"
#import "HTTPTool.h"
#import "NewsPushDefine.h"
#import "MJExtension.h"
#import "PushModel.h"

@implementation PushRequest
#pragma mark - 获取新闻，公告，通知列表及详情
+ (void)requestNewsList:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:GetNewslist_URL headers:header(MyToken) params:param success:^(id json) {
        if ([[PushRequest new] isRequestSuccess:json]) {
            NSArray *dataArray = [NoticelistModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            success(dataArray);
        }
    } failure:^(NSError *error) {
        failed(error);
    }];
}

+ (void)requestNoticeList:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:GetNoticelist_URL headers:header(MyToken) params:param success:^(id json) {
        if([[PushRequest new] isRequestSuccess:json]) {
            NSArray *dataArray = [NoticelistModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            success(dataArray);
        }
    } failure:^(NSError *error) {
        failed(error);
    }];
}

+ (void)requestPublicNoticeList:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:GetMessageList_URL headers:header(MyToken) params:param success:^(id json) {
        if([[PushRequest new] isRequestSuccess:json]) {
            NSArray *dataArray = [NoticelistModel mj_objectArrayWithKeyValuesArray:json[@"data"][@"list"]];
            success(dataArray);
        }
    } failure:^(NSError *error) {
        failed(error);
    }];
}

#pragma mark - 上传图片
+ (void)requestUploadFile:(NSDictionary *)param imageDicArray:(NSArray *)imageDicArray imageKeyName:(NSString *)keyName success:(RequestSucess)success failed:(RequestFailed)failed {
    
    [HTTPTool upLoadMutiWithURL:UploadFile_URL headers:header(MyToken) param:param imageDicArray:imageDicArray keyName:keyName success:^(id json) {
        if ([[PushRequest new] isRequestSuccess:json]) {
            success(json[@"data"]);
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -  新闻，公告，通知发布
+ (void)requestNewstype:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:Newstype_URL headers:header(MyToken) params:param success:^(id json) {
        if ([[PushRequest new] isRequestSuccess:json]) {
            NSMutableArray *dataArray = [NewtypeModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            success(dataArray);
        }
    } failure:^(NSError *error) {
        failed(error);
    }];
}

+ (void)requestDepartlist:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:Departlist_URL headers:header(MyToken) params:param success:^(id json) {
        if ([[PushRequest new] isRequestSuccess:json]) {
            NSArray *dataArray = [DepartlistModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            success(dataArray);
        }
    } failure:^(NSError *error) {
        failed(error);
    }];
}

+ (void)requestDepartuserlist:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:DepartUserlist_URL headers:header(MyToken) params:param success:^(id json) {
        if ([[PushRequest new] isRequestSuccess:json]) {
            NSArray *dataArray = [DepartlistModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
            success(dataArray);
        }
    } failure:^(NSError *error) {
        failed(error);
    }];
}
#pragma mark - 新闻，公告，通知操作
+ (void)requestNewsAdd:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:AddNews_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestNewsChange:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:UpdateNews_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestNewsDel:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:DelNews_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestNewsPush:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:PublishNews_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestNoticeAdd:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:AddNotice_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestNoticeChange:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:UpdateNotice_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestNoticeDel:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:DelNotice_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestNoticePush:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:PublishNotice_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestMessageAdd:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:AddMessage_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestMessageChange:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:UpdateMessage_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestMessageCancel:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:CancelMessage_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestMessagePush:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:PublishMessage_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)requestMessagesendDel:(NSDictionary *)param success:(RequestSucess)success failed:(RequestFailed)failed {
    [HTTPTool postWithURL:DelMessage_URL headers:header(MyToken) params:param success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

//请求参数成功检测
- (BOOL)isRequestSuccess:(id)json {
    switch ([json[@"result"] intValue]) {
        case 1:{
            //操作成功
            return YES;
            break;
        }
        case 0:{
            //没有查询到数据
            return NO;
            break;
        }
        case -1:{
            //操作过程中出现异常
            return NO;
            break;
        }
        case -2:{
            //数据重复，一般在新增接口中
            return NO;
            break;
        }
        case -100:{
            //用户会话过期，需重新登陆
            return NO;
            break;
        }
        default:{
            return NO;
            break;
        }
    }
    return NO;
}

@end
