//
//  UIButton+TouchUpInsideBlock.m
//  AlertViewDemo
//
//  Created by XZY on 2018/9/5.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import "UIButton+TouchUpInsideBlock.h"
#import <objc/runtime.h>

@implementation UIButton (TouchUpInsideBlock)

//动态绑定
static char *xhg_actionBlock_bind;
- (void)setXhg_clickBlock:(void (^)(UIButton *))actionBlock {
    [self removeTarget:self action:@selector(xhg_touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(xhg_touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(self, &xhg_actionBlock_bind, actionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIButton *))xhg_clickBlock {
    return objc_getAssociatedObject(self, &xhg_actionBlock_bind);
}


//事件响应
- (void)xhg_touchUpInsideAction:(UIButton *)button {
    !self.xhg_clickBlock ? nil : self.xhg_clickBlock(self);
}
@end
