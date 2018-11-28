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
+ (instancetype)alertMenusViewWithTitles:(NSArray<NSString*> *)titles textViewPlaceholder:(NSString *)placeholder;
@end

NS_ASSUME_NONNULL_END
