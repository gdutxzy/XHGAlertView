//
//  XHGMenusView.m
//  XHGAlertView
//
//  Created by XZY on 2018/11/28.
//

#import "XHGAlertMenusView.h"
#import "Masonry.h"
#import "XHGAlertView.h"

/**
 选项按钮
 */
@interface XHGAlertMenuButton : UIButton

@end

@implementation XHGAlertMenuButton
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rect = [super titleRectForContentRect:contentRect];
    rect.origin.x = 25;
    return rect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rect = [super imageRectForContentRect:contentRect];
    rect.origin.x = contentRect.size.width - 49;
    return rect;
}
@end





@interface XHGAlertMenusView ()<UITextViewDelegate>{
    XHGTextView *_textView;
}
@property (nonatomic, assign) BOOL showTextView;
@end

@implementation XHGAlertMenusView
+ (instancetype)alertMenusViewWithTitles:(NSArray<NSString*> *)titles {
    XHGAlertMenusView * menusView = [[XHGAlertMenusView alloc] init];
    if (menusView) {
        menusView->_titles = titles;
        menusView->_showTextView = NO;
        [menusView setupView];
    }
    return menusView;
}

+ (instancetype)alertMenusViewWithTitles:(NSArray<NSString*> *)titles textViewPlaceholder:(NSString *)placeholder{
    XHGAlertMenusView * menusView = [[XHGAlertMenusView alloc] init];
    if (menusView) {
        menusView->_titles = titles;
        menusView->_showTextView = YES;
        menusView.textView.placeholder = placeholder;
        [menusView setupView];
    }
    return menusView;
}

- (void)setupView{
    NSMutableArray * buttons = [NSMutableArray arrayWithCapacity:self.titles.count];
    UIButton * lastButton = nil;
    NSBundle *bundle = [NSBundle bundleForClass:[XHGAlertView class]];
    NSBundle *imageBundle = [NSBundle bundleWithPath:[[bundle resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.bundle",[XHGAlertView class]]]];
    
    for (NSInteger i = 0; i<self.titles.count; i++) {
        NSString * title = self.titles[i];
        // 生成
        XHGAlertMenuButton * button = [XHGAlertMenuButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [button setTitleColor:[UIColor colorWithRed:(0x99/255.0) green:(0x99/255.0) blue:(0x99/255.0) alpha:1] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"orange_circle_normal" inBundle:imageBundle compatibleWithTraitCollection:nil] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"orange_circle_select" inBundle:imageBundle compatibleWithTraitCollection:nil] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(menuButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [buttons addObject:button];
       
        
        // 布局
        if (lastButton){
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(lastButton.mas_bottom).offset(0);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(44);
            }];
        }else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(10);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(44);
            }];
        }
        lastButton = button;
    }
    if (_showTextView) {
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lastButton.mas_bottom).offset(0);
            make.left.mas_equalTo(25);
            make.right.mas_equalTo(-25);
            make.height.mas_equalTo(77);
            make.bottom.mas_equalTo(-22);
        }];
    }else{
        [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-22);
        }];
    }
    
    self->_buttons = buttons;
    // 默认选中第一项
    self.selectedIndex = 0;
}


- (void)menuButtonAction:(UIButton *)sender{
    self.selectedIndex = sender.tag;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    for (XHGAlertMenuButton * button in self.buttons) {
        if (selectedIndex == button.tag) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    if (_showTextView) {
        [UIView animateWithDuration:0.3 animations:^{
            if (self.selectedIndex == self.titles.count-1) {
                [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(77);
                }];
            }else{
                [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(0);
                }];
            }
            [self.superview.superview.superview layoutIfNeeded];
        }];
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString * str = [textView.text stringByReplacingCharactersInRange:range withString:text];
  
    return str.length <= 30;
}


- (XHGTextView *)textView{
    if (!_textView) {
        _textView = [[XHGTextView alloc] init];
        _textView.placeholderColor = [UIColor colorWithRed:(0xbb/255.0) green:(0xbb/255.0) blue:(0xbb/255.0) alpha:1];
        _textView.textColor = [UIColor colorWithRed:(0x99/255.0) green:(0x99/255.0) blue:(0x99/255.0) alpha:1];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.layer.cornerRadius = 3;
        _textView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        _textView.layer.borderColor = [UIColor colorWithRed:(0xe5/255.0) green:(0xe5/255.0) blue:(0xe5/255.0) alpha:1].CGColor;
        _textView.textContainerInset = UIEdgeInsetsMake(15, 8, 8, 6);
        _textView.delegate = self;
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = 6;
        NSDictionary *attributes = @{
                                     NSForegroundColorAttributeName:_textView.textColor,
                                     NSFontAttributeName:[UIFont systemFontOfSize:14],
                                     NSParagraphStyleAttributeName:paragraphStyle
                                     };
        _textView.typingAttributes = attributes;
    }
    return _textView;
}

@end

