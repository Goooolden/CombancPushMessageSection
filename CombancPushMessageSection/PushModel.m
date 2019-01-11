//
//  PushModel.m
//  PushNotice
//
//  Created by Golden on 2018/12/27.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import "PushModel.h"
#import "MJExtension.h"

@implementation PushModel

@end

@implementation PushVCListModel

@end

@implementation NewsListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"files":@"NoticeFileImgModel",
             @"imgs":@"NoticeFileImgModel"
             };
}

@end

@implementation NoticeListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"files":@"NoticeFileImgModel",
             @"imgs":@"NoticeFileImgModel",
             @"users":@"MessageUsersModel"
             };
}

@end

@implementation MessageUsersModel

@end

@implementation NoticeFileImgModel

@end

@implementation NewtypeModel

@end

@implementation DepartlistModel

@end
