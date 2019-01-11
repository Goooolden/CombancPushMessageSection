//
//  UIColor+NewsPushCategory.h
//  PushNotice
//
//  Created by Golden on 2018/12/25.
//  Copyright © 2018年 Combanc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (NewsPushCategory)

+ (UIColor *)colorWithHex:(NSString *)hexColor;

+ (UIImage *)createImageWithColor:(UIColor *)color;

@end
