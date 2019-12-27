//
//  XHGMenuAlertView.m
//  recycling2b
//
//  Created by XZY on 2018/8/28.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import "XHGAlertView.h"
#import "UIButton+TouchUpInsideBlock.h"
#import "Masonry.h"



// 屏幕宽度
#define KDECEIVE_WIDTH ([UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define KDECEIVE_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define xhg_highlightColor [UIColor colorWithRed:(0xff/255.0) green:(0xbf/255.0) blue:(0x00/255.0) alpha:1]
#define xhg_grayColor [UIColor colorWithRed:(0x99/255.0) green:(0x99/255.0) blue:(0x99/255.0) alpha:1]
#define xhg_oceanColor [UIColor colorWithRed:(0x57/255.0) green:(0x6b/255.0) blue:(0x95/255.0) alpha:1]
#define xhg_blackColor [UIColor colorWithRed:(0x30/255.0) green:(0x30/255.0) blue:(0x30/255.0) alpha:1]
#define xhg_redColor [UIColor colorWithRed:(0xFE/255.0) green:(0x3B/255.0) blue:(0x30/255.0) alpha:1]


@class  XHGAlertView;


/// window必须被持有保存才能正常显示
static NSMutableDictionary<NSString*,UIWindow*> *_widowsDic;
/// alertView 堆，用于多个alertView 弹出时，隐藏上一个弹窗。当前弹窗结束后，显示上一个弹窗
static NSMutableArray<XHGAlertView *> *_alertArray;


@interface XHGAlertViewOrientationVC : UIViewController
@end
@implementation XHGAlertViewOrientationVC
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (BOOL)shouldAutorotate {
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end


/****************************************************************************************************/

/**
 按钮配置器
 */
@interface XHGAlertAction()


@end

@implementation XHGAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(XHGAlertActionStyle)style handler:(void (^ __nullable)(XHGAlertAction *action,XHGAlertView * alertView))handler{
    XHGAlertAction * action = [[XHGAlertAction alloc] init];
    if (action) {
        action->_title = title;
        action->_style = style;
        action->_handler = handler;
    }
    return action;
}

@end



/****************************************************************************************************/


/**
 弹窗控件
 */
@interface XHGAlertView (){
    XHGAlertAction * _selectedMenuAction;
}
@property (nonatomic,weak)   UIWindow * alertBgWindow;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) UIView * scrollContentView;
@property (nonatomic,strong) UIView * bottomView;

/// 消息动画正在进行
@property (nonatomic,assign) BOOL dismissing;

@property (nonatomic,weak) UIView *inputView;
@end


@implementation XHGAlertView
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;
@synthesize topImageView = _topImageView;
@synthesize actionButtons = _actionButtons;

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@">>>>>alert dealloc");
}

+ (instancetype)alertTitle:(nullable NSString *)title
                   message:(nullable NSString *)message
                cancelText:(nullable NSString *)cancelText
               confirmText:(nonnull NSString *)confirmText
               cancelClick:(void(^)(void))cancelClick
              confirmClick:(void(^)(void))confirmClick{
    XHGAlertAction * cancelAction = [XHGAlertAction actionWithTitle:cancelText style:XHGAlertActionStyleGray handler:^(XHGAlertAction *action, XHGAlertView *alertView) {
        if (cancelClick) {
            cancelClick();
        }
    }];
    XHGAlertAction * confirmAction = [XHGAlertAction actionWithTitle:confirmText style:XHGAlertActionStyleHighlight handler:^(XHGAlertAction *action, XHGAlertView *alertView) {
        if (confirmClick) {
            confirmClick();
        }
    }];
    NSMutableArray * actions = [NSMutableArray arrayWithCapacity:2];
    if (cancelText) {
        [actions addObject:cancelAction];
        [actions addObject:confirmAction];
    }else{
        [actions addObject:confirmAction];
    }
    XHGAlertView * alert = [XHGAlertView alertWithTitle:title message:message actions:actions];
    return alert;
}


+ (instancetype)alertWithCustomView:(UIView *)customView{
    XHGAlertView * alert = [[XHGAlertView alloc] init];
    if (alert && customView) {
        [alert addSubview:customView];
        alert->_customView = customView;
        alert.dismissByTapSpace = NO;
        alert.autoDismiss = YES;
        
        [customView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
            if (customView.bounds.size.width > 0) {
                make.width.mas_equalTo(customView.bounds.size.width).priority(MASLayoutPriorityRequired);
            }
            if (customView.bounds.size.height > 0) {
                make.height.mas_equalTo(customView.bounds.size.height).priority(MASLayoutPriorityDefaultLow);
            }
        }];
    }
    return alert;
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message customizeContentView:(UIView *)customView actions:(NSArray<XHGAlertAction *> *)actions{
    return [XHGAlertView alertWithTopImage:nil title:title message:message  customizeContentView:customView actions:actions];
}

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message actions:(NSArray<XHGAlertAction *> *)actions{
    return [XHGAlertView alertWithTopImage:nil title:title message:message customizeContentView:nil actions:actions];
}


+ (instancetype)alertWithTopImage:(UIImage *)topImage title:(NSString *)title message:(NSString *)message actions:(NSArray<XHGAlertAction *> *)actions{
    return [XHGAlertView alertWithTopImage:topImage title:title message:message customizeContentView:nil actions:actions];
}

+ (instancetype)alertWithTopImage:(UIImage *)topImage
                            title:(nullable NSString *)title
                          message:(nullable NSString *)message
                            menus:(nullable NSArray<XHGAlertAction*> *)menus
                          actions:(nonnull NSArray<XHGAlertAction*> *)actions{
    return [XHGAlertView alertWithTopImage:topImage title:title message:message customizeContentView:nil actions:actions];
}

+ (instancetype)alertWithTopImage:(UIImage *)topImage
                            title:(nullable NSString *)title
                          message:(nullable NSString *)message
             customizeContentView:(nullable UIView *)customView
                          actions:(nonnull NSArray<XHGAlertAction*> *)actions{
    XHGAlertView * alert = [[XHGAlertView alloc] init];
    if (alert) {
        alert->_title = title;
        alert->_message = message;
        alert->_actions = actions;
        alert->_topImage = topImage;
        alert->_customView = customView;
        alert.dismissByTapSpace = NO;
        alert.autoDismiss = YES;
        [alert setupView];
    }
    return alert;
}

- (void)showSheet {
    _style = XHGViewStyleSheet;
    _dismissByTapSpace = YES;
    [self show];
}
- (void)show{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self setupBottomView];

    self.dismissing = NO;
    [self.layer removeAllAnimations];
    self.transform = CGAffineTransformIdentity;
    self.alpha = 1;
    
    if (!_alertArray) {
        _alertArray = [NSMutableArray array];
    }
    // 隐藏上一个alert,如果上一个alert正在进行消失动画，则不处理
    XHGAlertView * alertLast = _alertArray.lastObject;
    if (!alertLast.dismissing) {
        alertLast.alertBgWindow.hidden = YES;
        [[NSNotificationCenter defaultCenter] removeObserver:alertLast];//避免键盘通知错误影响当前显示
    }
    // 将当前alert加入到alert堆中
    [_alertArray removeObject:self];
    [_alertArray addObject:self];
    
    
    if (!self.alertBgWindow) {
        UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0,0, KDECEIVE_WIDTH, KDECEIVE_HEIGHT)];
        window.windowLevel = UIWindowLevelAlert;
        window.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [window makeKeyAndVisible];
        XHGAlertViewOrientationVC *vc = [[XHGAlertViewOrientationVC alloc] init];
        window.rootViewController = vc;
        vc.view.backgroundColor = [UIColor clearColor];
        vc.view.userInteractionEnabled = NO;
        [window addSubview:self];

        if (!_widowsDic) {
            _widowsDic = [NSMutableDictionary dictionary];
        }
        [_widowsDic setObject:window forKey:[NSString stringWithFormat:@"%p",self]];
        self.alertBgWindow = window;
    }

    self.alertBgWindow.hidden = NO;
    self.alertBgWindow.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alertBgWindow.alpha = 1;
    }];
    
    if (self.style == XHGViewStyleSheet) {
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_greaterThanOrEqualTo(60);
            make.left.right.bottom.mas_equalTo(0);
        }];
        
        self.layer.cornerRadius = 0;
        self.clipsToBounds = NO;
        [self layoutIfNeeded];
        CAShapeLayer* maskLayer = [CAShapeLayer layer];
        UIBezierPath *b= [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(16, 16)];
        maskLayer.path = b.CGPath;
        self.layer.mask = maskLayer;
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        self.transform = transform;
        [UIView animateWithDuration:0.3 animations:^{
            self.transform = CGAffineTransformIdentity;
        }];
    }else{
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.top.mas_greaterThanOrEqualTo(60);
            make.bottom.mas_lessThanOrEqualTo(-60);
            make.left.mas_equalTo(35).priorityHigh();
            make.right.mas_equalTo(-35).priorityHigh();
        }];
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        animation.values = @[@0.4,@1.1,@0.96,@1.0];
        animation.duration = 0.5;
        animation.calculationMode = kCAAnimationCubic;
        [self.layer addAnimation:animation forKey:nil];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.style == XHGViewStyleSheet) {
        CAShapeLayer* maskLayer = [CAShapeLayer layer];
        UIBezierPath *b= [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(16, 16)];
        maskLayer.path = b.CGPath;
        self.layer.mask = maskLayer;
    }
}

- (void)dismiss{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//避免键盘通知错误影响当前显示
    self.dismissing = YES;
    [self.layer removeAllAnimations];
    self.transform = CGAffineTransformIdentity;
    self.alpha = 1;

    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeScale(0.1,0.1);
        if (self.style == XHGViewStyleSheet) {
            transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
            self.alertBgWindow.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        }else{
            self.alertBgWindow.alpha = 0;
            self.alpha = 0;
        }
//        CGAffineTransformMakeTranslation(0,[UIScreen mainScreen].bounds.size.height/2+30);
//        transform = CGAffineTransformScale(transform,0.1,0.1);
//        transform = CGAffineTransformRotate(transform,3.14);
        self.transform = transform;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alertBgWindow.hidden = YES;
        [_widowsDic removeObjectForKey:[NSString stringWithFormat:@"%p",self]];
        
        // 从alert堆中移除当前弹窗
        [_alertArray removeObject:self];
        // 显示之前被隐藏的弹窗,如果没有被隐藏，则不作处理
        XHGAlertView * alertLast = _alertArray.lastObject;
        if (alertLast.alertBgWindow.hidden) {
            [alertLast show];
        }
    }];
}


- (void)setAttributedTitle:(NSAttributedString *)attributedTitle{
    _attributedTitle = attributedTitle;
    self.titleLabel.attributedText = attributedTitle;
}

- (void)setAttributedMessage:(NSAttributedString *)attributedMessage{
    _attributedMessage = attributedMessage;
    self.messageLabel.attributedText = attributedMessage;
}




- (void)setupView {
    __weak typeof(self) weakself = self;
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollContentView];
    [self addSubview:self.bottomView];
    
    [self setupScrollContentView];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakself) self = weakself;
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(0);
    }];
    [self.scrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        __strong typeof(weakself) self = weakself;
        make.left.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(self.scrollView).priorityLow();
    }];
}

- (void)setupScrollContentView {
    UIView * lastView = nil;
    
    if (self.topImage) {
        self.topImageView.image = _topImage;
        [self.scrollContentView addSubview:self.topImageView];
        if (lastView) {
            [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastView.mas_bottom).offset(15);
                make.centerX.mas_equalTo(self.scrollContentView);
            }];
        }else{
            [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(30);
                make.centerX.mas_equalTo(self.scrollContentView);
            }];
        }
 
        lastView = self.topImageView;
    }
    
    if (self.title) {
        self.titleLabel.text = self.title;
        [self.scrollContentView addSubview:self.titleLabel];
        if (lastView) {
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastView.mas_bottom).offset(15);
                make.left.mas_equalTo(42);
                make.right.mas_equalTo(-42);
            }];
        }else{
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(28);
                make.left.mas_equalTo(42);
                make.right.mas_equalTo(-42);
            }];
        }
  
        lastView = self.titleLabel;
    }
    
    if (self.message) {
        self.messageLabel.text = self.message;
        [self.scrollContentView addSubview:self.messageLabel];
        if (lastView) {
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastView.mas_bottom).offset(8);
                make.left.mas_equalTo(30);
                make.right.mas_equalTo(-30);
            }];
        }else{
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(28);
                make.left.mas_equalTo(30);
                make.right.mas_equalTo(-30);
            }];
        }
        
        lastView = self.messageLabel;
    }
    
    if (self.customView) {
        [self.scrollContentView addSubview:self.customView];
        __weak typeof(self) weakself = self;
        [self.customView mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(weakself) self = weakself;
            if (lastView) {
                make.top.mas_equalTo(lastView.mas_bottom);
            }else{
                make.top.mas_equalTo(0);
            }
            make.centerX.mas_equalTo(0);
            if (self.customView.bounds.size.width > 0) {
                make.width.mas_equalTo(self.customView.bounds.size.width);
            }else{
                make.width.mas_equalTo(self.scrollContentView);
            }
            if (self.customView.bounds.size.height > 0) {
                make.height.mas_equalTo(self.customView.bounds.size.height);
            }
        }];
        lastView = self.customView;
    }
    
    // 处理下边界距离
    if (lastView == self.customView) {  // 自定义内容视图结尾时
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }else { // 文字结尾时
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-30);
        }];
    }
    
}





- (void)setupBottomView {
    __weak typeof(self) weakself = self;
    if (_actionButtons) {
        return;
    }
    NSMutableArray * buttons = [NSMutableArray arrayWithCapacity:self.actions.count];
    UIButton * lastButton = nil;
    CGFloat height = 0;
    CGFloat sheetButtonHeight = self.style==XHGViewStyleSheet ? 54:44;
    if (self.actionButtonHeight > 0) {
        sheetButtonHeight = self.actionButtonHeight;
    }
    for (NSInteger i = 0; i<self.actions.count; i++) {
        XHGAlertAction * action = self.actions[i];
        if (0 == action.tag) {
            action.tag = i;
        }
        // 生成
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = action.tag;
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [self.bottomView addSubview:button];
        switch (action.style) {
            case XHGAlertActionStyleGray: {
                [button setTitleColor:xhg_grayColor forState:UIControlStateNormal];
            }
                break;
            case XHGAlertActionStyleHighlight: {
                [button setTitleColor:xhg_highlightColor forState:UIControlStateNormal];
            }
                break;
            case XHGAlertActionStyleCustom: {
                [button setTitleColor:action.customTextColor forState:UIControlStateNormal];
            }
                break;
            case XHGAlertActionStyleBoldOcean: {
                [button setTitleColor:xhg_oceanColor forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                _titleLabel.font = [UIFont boldSystemFontOfSize:18];
            }
                break;
            case XHGAlertActionStyleBoldBlack: {
                [button setTitleColor:xhg_blackColor forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
                _titleLabel.font = [UIFont boldSystemFontOfSize:18];
            }
                break;
            case XHGAlertActionStyleBlack: {
                [button setTitleColor:xhg_blackColor forState:UIControlStateNormal];
            }
                break;
            case XHGAlertActionStyleRed: {
                [button setTitleColor:xhg_redColor forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        if (!self.actionButtonFont && self.style == XHGViewStyleSheet) {
            self.actionButtonFont = [UIFont systemFontOfSize:18];
        }
        if (self.actionButtonFont) {
            button.titleLabel.font = self.actionButtonFont;
        }
        [button setTitle:action.title forState:UIControlStateNormal];
        [button setXhg_clickBlock:^(UIButton *button) {
            __strong typeof(weakself) self = weakself;
            if (action.handler) {
                action.handler(action,self);
            }
            if (self.autoDismiss) {
                [self dismiss];
            }
        }];
        [buttons addObject:button];
        
        // 布局
        if (self.style == XHGViewStyleSheet) {
            if (i<self.actions.count-2) {
                UIView * horizontalLine = [[UIView alloc] initWithFrame:CGRectZero];
                horizontalLine.backgroundColor = [UIColor colorWithRed:(0xf2/255.0) green:(0xf2/255.0) blue:(0xf2/255.0) alpha:1];
                [button addSubview:horizontalLine];
                [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.bottom.left.mas_equalTo(0);
                    make.height.mas_equalTo(1);
                }];
            }
            if (i == self.actions.count-1) {
                UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
                lineView.backgroundColor = [UIColor colorWithRed:(0xf2/255.0) green:(0xf2/255.0) blue:(0xf2/255.0) alpha:1];
                [self.bottomView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(height);
                    make.right.left.mas_equalTo(0);
                    make.height.mas_equalTo(8);
                }];
                height +=8;
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(height);
                    make.left.right.mas_equalTo(0);
                    make.height.mas_equalTo(sheetButtonHeight);
                }];
                height += sheetButtonHeight;
                if (@available(iOS 11.0, *)) {
                    CGFloat a =  [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom;
                    height += a*0.5;
                }
            }else{
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(height);
                    make.left.right.mas_equalTo(0);
                    make.height.mas_equalTo(sheetButtonHeight);
                }];
                height += sheetButtonHeight;
            }
            
        }else{  // XHGViewStyleAlert
            if (i != 0) {
                UIView * verticalLine = [[UIView alloc] initWithFrame:CGRectZero];
                verticalLine.backgroundColor = [UIColor colorWithRed:(0xf2/255.0) green:(0xf2/255.0) blue:(0xf2/255.0) alpha:1];
                [button addSubview:verticalLine];
                [verticalLine mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.left.mas_equalTo(0);
                    make.width.mas_equalTo(1);
                }];
            }
            
            if (lastButton) {
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.bottom.mas_equalTo(0);
                    make.left.mas_equalTo(lastButton.mas_right).offset(0);
                    make.width.mas_equalTo(self.bottomView.mas_width).dividedBy(self.actions.count);
                }];
            }else{
                [button mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(self.bottomView.mas_width).dividedBy(self.actions.count);
                }];
            }
            height = sheetButtonHeight;
        }
        
        lastButton = button;
    }
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    _actionButtons = buttons;
}

#pragma mark - 键盘通知
- (void)keyboardWillShow:(NSNotification *)noti {
    if (!self.inputView) {
        return;
    }
    NSDictionary *userInfo = noti.userInfo;
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    
    CGRect inputViewRect = self.inputView.frame;
    inputViewRect.size.height = CGRectGetHeight(inputViewRect) > 100 ? 100 : inputViewRect.size.height;// 避免输入视图过大而导致的过分偏移

    [self.scrollView scrollRectToVisible:[self.inputView.superview convertRect:inputViewRect toView:self.scrollView] animated:YES]; // 将输入视图滚动到可视位置
 
    // 计算输入视图与键盘的差值，是否会被键盘覆盖
    NSInteger gap = CGRectGetMaxY([self.inputView.superview convertRect:inputViewRect toView:self.alertBgWindow]) - keyboardRect.origin.y;
    if (gap > 0) {
        CGRect rect = self.alertBgWindow.frame;
        rect.origin.y = -gap;
        [UIView animateWithDuration:0.3 animations:^{
            [self.alertBgWindow setFrame:rect];
        } completion:^(BOOL finished) {
           
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)noti {
    if (!self.inputView) {
        return;
    }
    CGRect rect = self.alertBgWindow.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.alertBgWindow setFrame:rect];
    }];
}

#pragma mark - Getter Setter
- (void)setTopImage:(UIImage *)topImage{
    _topImage = topImage;
    _topImageView.image = topImage;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    _titleLabel.text = title;
}

- (void)setMessage:(NSString *)message{
    _message = message;
    _messageLabel.text = message;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}

- (UIView *)scrollContentView{
    if (nil == _scrollContentView) {
        _scrollContentView = [[UIView alloc] initWithFrame:CGRectZero];
        _scrollContentView.backgroundColor = [UIColor whiteColor];
        _scrollView.bounces = YES;
        
    }
    return _scrollContentView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIView * line = [[UIView alloc] initWithFrame:CGRectZero];
        line.backgroundColor = [UIColor colorWithRed:(0xf2/255.0) green:(0xf2/255.0) blue:(0xf2/255.0) alpha:1];
        [_bottomView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.top.left.right.mas_equalTo(0);
        }];
    }
    return _bottomView;
}


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:(0x33/255.0) green:(0x33/255.0) blue:(0x33/255.0) alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor colorWithRed:(0x99/255.0) green:(0x99/255.0) blue:(0x99/255.0) alpha:1];
        _messageLabel.font = [UIFont systemFontOfSize:16];
        _messageLabel.numberOfLines = 0;
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}


- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _topImageView;
}

- (void)setMessageTextAlignment:(NSTextAlignment)alignment{
    self.messageLabel.textAlignment = alignment;
}


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView * view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UITextField class]]) {
        self.inputView = view;
    }else{
        [self endEditing:YES];
    }
    if (!view && self.dismissByTapSpace && self.autoDismiss) {
        [self dismiss];
    }
    return view;
}
@end




