//
//  NewsManagerTableViewCell.m
//  PushNotice
//
//  Created by Golden on 2018/12/25.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import "NewsManagerTableViewCell.h"
#import "Masonry.h"
#import "NewsPushDefine.h"

@interface NewsManagerTableViewCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *lineLabel;

@end

@implementation NewsManagerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    self.contentView.backgroundColor = RGBA(234, 234, 234, 1);
    
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = 7;
    [self.contentView addSubview:self.backView];
    
    self.pushtimeLabel = [[UILabel alloc]init];
    self.pushtimeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.pushtimeLabel.textColor = RGBA(0, 156, 255, 1);
    [self.backView addSubview:self.pushtimeLabel];
    
    self.authorLabel = [[UILabel alloc]init];
    self.authorLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.backView addSubview:self.authorLabel];
    
    self.stickLabel = [[UILabel alloc]init];
    self.stickLabel.layer.masksToBounds = YES;
    self.stickLabel.layer.cornerRadius = 2;
    self.stickLabel.backgroundColor = RGBA(241, 213, 24, 1);
    self.stickLabel.textColor = [UIColor whiteColor];
    self.stickLabel.textAlignment = NSTextAlignmentCenter;
    self.stickLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.backView addSubview:self.stickLabel];
    
    self.pushstateLabel = [[UILabel alloc]init];
    self.pushstateLabel.layer.masksToBounds = YES;
    self.pushstateLabel.layer.cornerRadius = 2;
    self.pushstateLabel.textColor = [UIColor whiteColor];
    self.pushstateLabel.textAlignment = NSTextAlignmentCenter;
    self.pushstateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.backView addSubview:self.pushstateLabel];
    
    self.lineLabel = [[UILabel alloc]init];
    self.lineLabel.backgroundColor = RGBA(234, 234, 234, 1);
    [self.backView addSubview:self.lineLabel];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.backView addSubview:self.titleLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.pushtimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.backView).offset(12);
    }];
    
    [self.authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.top.equalTo(self.backView.mas_top).offset(12);
    }];
    
    [self.pushstateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50);
        make.right.equalTo(self.backView).offset(-10);
        make.top.equalTo(self.backView).offset(12);
    }];
    
    [self.stickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.right.equalTo(self.pushstateLabel.mas_left).offset(-10);
        make.centerY.equalTo(self.pushstateLabel);
    }];
    
    [self.lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backView.mas_left).offset(10);
        make.right.equalTo(self.backView.mas_right).offset(-10);
        make.height.mas_offset(1);
        make.top.equalTo(self.authorLabel.mas_bottom).offset(9);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineLabel.mas_bottom).offset(10);
        make.left.right.equalTo(self.lineLabel);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-15);
    }];
}
@end
