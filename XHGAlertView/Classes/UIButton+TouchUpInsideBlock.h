//
//  UIButton+TouchUpInsideBlock.h
//  AlertViewDemo
//
//  Created by XZY on 2018/9/5.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (TouchUpInsideBlock)


/**
 点击事件回调
 */
@property (nonatomic,copy) void(^xhg_clickBlock)(UIButton *button);

@end
