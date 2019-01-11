//
//  PushStateTableViewCell.h
//  PushNotice
//
//  Created by Golden on 2018/12/27.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^StateSelectedBlcok)(NSString *state);

@interface PushStateTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL isRequired;
@property (nonatomic, strong) UIButton *firstStateBtn;
@property (nonatomic, strong) UIButton *secondStateBtn;
@property (nonatomic, strong) UILabel  *nameLabel;
@property (nonatomic, copy  ) StateSelectedBlcok stateSelectedBlock;

@end
