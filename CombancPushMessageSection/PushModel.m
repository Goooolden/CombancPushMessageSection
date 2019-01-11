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

@implementation NewslistModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"files":@"NoticeFileImgsModel",
             @"imgs":@"NoticeFileImgsModel"
             };
}

@end

@implementation NoticelistModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"files":@"NoticeFileImgsModel",
             @"imgs":@"NoticeFileImgsModel",
             @"users":@"MessageUsersModel"
             };
}

@end

@implementation MessageUsersModel

@end

@implementation NoticeFileImgsModel

@end

@implementation NewtypeModel

@end

@implementation DepartlistModel

@end
