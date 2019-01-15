//
//  PushStateTableViewCell.m
//  PushNotice
//
//  Created by Golden on 2018/12/27.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import "PushStateTableViewCell.h"
#import "NewsPushDefine.h"
#import "Masonry.h"
#import "UIColor+NewsPushCategory.h"

@interface PushStateTableViewCell ()

@property (nonatomic, strong) UIImageView *leftImageView;

@end

@implementation PushStateTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    _leftImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.height.mas_equalTo(6);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    self.nameLabel.textColor = [UIColor colorWithHex:@"#38383d"];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(25);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.top.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    self.firstStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.firstStateBtn setTitle:@"提交存为草稿" forState:UIControlStateNormal];
    [self.firstStateBtn setTitleColor:RGBA(136, 136, 136, 1) forState:UIControlStateNormal];
    self.firstStateBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [self.firstStateBtn setImage:[UIImage imageNamed:@"PushMessageResource.bundle/approval_assign_rb_true.png"] forState:UIControlStateNormal];
    self.firstStateBtn.selected = YES;
    [self.firstStateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
    [self.firstStateBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.firstStateBtn];
    
    self.secondStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.secondStateBtn setTitle:@"提交后发送" forState:UIControlStateNormal];
    [self.secondStateBtn setTitleColor:RGBA(136, 136, 136, 1) forState:UIControlStateNormal];
    self.secondStateBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:13];
    [self.secondStateBtn setImage:[UIImage imageNamed:@"PushMessageResource.bundle/approval_assign_rb_false.png"] forState:UIControlStateNormal];
    [self.secondStateBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -3, 0, 3)];
    [self.secondStateBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.secondStateBtn];
    [self.secondStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [self.firstStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.secondStateBtn.mas_left).offset(-20);
    }];
}

- (void)setIsRequired:(BOOL)isRequired {
    _leftImageView.image = isRequired == YES ? [UIImage imageNamed:@"PushMessageResource.bundle/stars.png"] : nil;
}

- (void)buttonClicked:(UIButton *)sender {
    if (sender == self.firstStateBtn) {
        self.firstStateBtn.selected = !self.firstStateBtn.selected;
        if (self.firstStateBtn.selected) {
            [self.firstStateBtn setImage:[UIImage imageNamed:@"PushMessageResource.bundle/approval_assign_rb_true.png"] forState:UIControlStateNormal];
            [self.secondStateBtn setImage:[UIImage imageNamed:@"PushMessageResource.bundle/approval_assign_rb_false.png"] forState:UIControlStateNormal];
            self.secondStateBtn.selected = NO;
            if (self.stateSelectedBlock) {
                self.stateSelectedBlock(@"0");
            }
        }
    }else if (sender == self.secondStateBtn) {
        self.secondStateBtn.selected = !self.secondStateBtn.selected;
        if (self.secondStateBtn.selected) {
            [self.secondStateBtn setImage:[UIImage imageNamed:@"PushMessageResource.bundle/approval_assign_rb_true.png"] forState:UIControlStateNormal];
            [self.firstStateBtn setImage:[UIImage imageNamed:@"PushMessageResource.bundle/approval_assign_rb_false.png"] forState:UIControlStateNormal];
            self.firstStateBtn.selected = NO;
            if (self.stateSelectedBlock) {
                self.stateSelectedBlock(@"1");
            }
        }
    }
}

@end
