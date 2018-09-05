//
//  ShortcutFuction.h
//  AlertViewDemo
//
//  Created by XZY on 2018/9/5.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#ifndef ShortcutFuction_h
#define ShortcutFuction_h

#import <UIKit/UIKit.h>


// 屏幕宽度
#define KDECEIVE_WIDTH ([UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define KDECEIVE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//页面比例计算值
#define WIDTH_RADIUS (KDECEIVE_WIDTH/375.0)

//获取屏幕适合的尺寸
#define getScaleWidth(x)  round(x * WIDTH_RADIUS)
#define getScaleHeight(x) round(x * WIDTH_RADIUS)



/**
 UIFont
 @param fontsize fontsize
 @return UIFont
 */
CG_INLINE UIFont *fontSize(CGFloat fontsize){
    return [UIFont systemFontOfSize:fontsize];
}


/**
 根据HEX值取得颜色
 @param rgbValue 0xfffff
 @return UIColor
 */
CG_INLINE UIColor *colorHex(NSInteger rgbValue) {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                           green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                            blue:((float)(rgbValue & 0xFF))/255.0 \
                           alpha:1.0];
}

/**
 根据RGBA值换得颜色
 @param R {0,255}
 @param G {0,255}
 @param B {0,255}
 @param A 0≤A≤1
 @return UIColor
 */
CG_INLINE UIColor *colorRGBA(NSInteger R,NSInteger G,NSInteger B,CGFloat A) {
    return [UIColor colorWithRed:(float)(R/255.0f) green:(float)(G / 255.0f) blue:(float)(B / 255.0f) alpha:A];
}


#endif /* ShortcutFuction_h */
