//
//  XHGMenusView.h
//  XHGAlertView
//
//  Created by XZY on 2018/11/28.
//

#import <UIKit/UIKit.h>
#import "XHGTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface XHGAlertMenusView : UIView
@property (nonatomic,strong,readonly) NSArray<UIButton *> *buttons;
@property (nonatomic,strong,readonly) NSArray<NSString *> *titles;
@property (nonatomic,strong,readonly) XHGTextView *textView;

@property (nonatomic,assign) NSUInteger selectedIndex;

/// 包含titles的按钮列
+ (instancetype)alertMenusViewWithTitles:(NSArray<NSString*> *)titles;

/// 包含titles的按钮列，点击最后一个选项时，展示输入框
+ (instancetype)alertMenusViewWithTitles:(NSArray<NSString*> *)titles textViewPlaceholder:(NSString *)placeholder;
@end

NS_ASSUME_NONNULL_END
