//
//  XHGMenuAlertView.h
//  recycling2b
//
//  Created by XZY on 2018/8/28.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//  选项弹窗

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, XHGAlertActionStyle) {
    /// 灰黑色
    XHGAlertActionStyleGray,
    /// 主题黄色
    XHGAlertActionStyleHighlight,
    /// 自定义颜色
    XHGAlertActionStyleCustom,
};

@class XHGAlertView;

@interface XHGAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(XHGAlertActionStyle)style handler:(void (^ __nullable)(XHGAlertAction *action,XHGAlertView * alertView))handler;
@property (nonatomic, assign) NSInteger tag;
@property (nullable, nonatomic, strong, readonly) NSString *title;
@property (nonatomic,assign, readonly) XHGAlertActionStyle style;
@property (nonatomic,strong) UIColor * customTextColor;
@property (nonatomic,copy, readonly) void(^handler)(XHGAlertAction *action,XHGAlertView * alertView);

@end




@interface XHGAlertView : UIView

/**
 快捷生成常用的标题及内容弹窗
 @param title 标题，若不填则没有
 @param message 内容，若不填则没有
 @param cancelText 取消按钮的文案，若不填则没有
 @param confirmText 确认按钮的文案，必须填写
 @param cancelClick 取消按钮按下
 @param confirmClick 确认按钮按下
 */
+ (instancetype)alertTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
                cancelText:(nullable NSString *)cancelText
               confirmText:(nonnull NSString *)confirmText
               cancelClick:(void(^)(void))cancelClick
              confirmClick:(void(^)(void))confirmClick;


/**
 样式完全自定义的弹窗
 @param customView 自定义视图，self.customView = customView
 */
+ (instancetype)alertWithCustomView:(UIView *)customView;


/**
 标题、内容、自定义内容视图 弹窗提示
 
 @param title 标题,如果传nil，则此弹窗不会加载titleLabel，则后续无法设置titleLabel相关属性
 @param message 内容,如果传nil，则此弹窗不会加载messageLabel，则后续无法设置messageLabel相关属性
 @param customView 自定义内容视图，self.customView = customView
 @param actions 操作按钮
 */
+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
          customizeContentView:(nullable UIView *)customView
                       actions:(nonnull NSArray<XHGAlertAction*> *)actions;

/**
 标题、内容 弹窗提示
 @param title 标题,如果传nil，则此弹窗不会加载titleLabel，则后续无法设置titleLabel相关属性
 @param message 内容,如果传nil，则此弹窗不会加载messageLabel，则后续无法设置messageLabel相关属性
 @param actions 操作按钮
 */
+ (instancetype)alertWithTitle:(nullable NSString *)title
                       message:(nullable NSString *)message
                       actions:(nonnull NSArray<XHGAlertAction*> *)actions;


/**
  图片、标题、内容 弹窗提示
 @param topImage 顶部图片
 @param title 标题,如果传nil，则此弹窗不会加载titleLabel，则后续无法设置titleLabel相关属性
 @param message 内容,如果传nil，则此弹窗不会加载messageLabel，则后续无法设置messageLabel相关属性
 @param actions 操作按钮
 */
+ (instancetype)alertWithTopImage:(UIImage *)topImage
                            title:(nullable NSString *)title
                          message:(nullable NSString *)message
                          actions:(nonnull NSArray<XHGAlertAction*> *)actions;


/**
 顶部图片、标题、内容、自定义内容视图、选项 弹窗提示
 @param topImage 顶部图片,如果传nil，则此弹窗不会加载topImageView，则后续无法设置topImageView相关属性
 @param title 标题,如果传nil，则此弹窗不会加载titleLabel，则后续无法设置titleLabel相关属性
 @param message 内容,如果传nil，则此弹窗不会加载messageLabel，则后续无法设置messageLabel相关属性
 @param customView 自定义内容视图，self.customView = customView
 @param actions 操作按钮
 */
+ (instancetype)alertWithTopImage:(UIImage *)topImage
                            title:(nullable NSString *)title
                          message:(nullable NSString *)message
             customizeContentView:(nullable UIView *)customView
                          actions:(nonnull NSArray<XHGAlertAction*> *)actions;




/// 自定义视图
@property (nonatomic, weak, readonly) __kindof UIView *customView;
@property (nonatomic, strong) UIImage *topImage;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong, readonly) NSArray<XHGAlertAction*> *actions;

/// 设置title富文本
@property (nonatomic, strong) NSAttributedString *attributedTitle;
/// 设置message富文本
@property (nonatomic, strong) NSAttributedString *attributedMessage;



/**
 是否允许点击空白处后消失。默认 NO 。
 */
@property (assign,nonatomic) BOOL dismissByTapSpace;

/**
 是否允许主动消失。即点击事件发生后，alertView是否会自动消失。默认 YES 。
 */
@property (assign,nonatomic) BOOL autoDismiss;


/**
 设置内容文字对齐方式
 @param alignment NSTextAlignment
 */
- (void)setMessageTextAlignment:(NSTextAlignment)alignment;



/**
 使显示，必须在主线程执行
 */
- (void)show;


/**
 使消失，必须在主线程执行
 */
- (void)dismiss;

@end
