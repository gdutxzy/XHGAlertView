//
//  XHGTextView.m
//  XHGAlertView
//
//  Created by XZY on 2018/11/28.
//

#import "XHGTextView.h"


@interface XHGTextView ()
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) UIColor *contentColor;
@end


@implementation XHGTextView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self setContent:text];
}

- (NSString *)text{
    return self.content;
}

- (void)setTextColor:(UIColor *)textColor{
    [super setTextColor:textColor];
    [self setContentColor:textColor];
}

- (UIColor *)textColor {
    if (!self.contentColor) {
        return [super textColor];
    }
    return self.contentColor;
}


- (void)setPlaceholderStyle:(NSString *)placeholder {
    if (self.content.length == 0) {
        [super setText:placeholder];
        self.textColor = [super textColor];
        [super setTextColor:self.placeholderColor];
    }
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    [self setPlaceholderStyle:placeholder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self];
}


- (UIColor *)placeholderColor{
    if (!_placeholderColor) {
        _placeholderColor = [UIColor colorWithRed:(0xbb/255.0) green:(0xbb/255.0) blue:(0xbb/255.0) alpha:1];
    }
    return _placeholderColor;
}


- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect originalRect = [super caretRectForPosition:position];
    originalRect.size.height = self.font.lineHeight + 2;
    return originalRect;
}

- (void)textDidBeginEditing:(NSNotification *)noti{
    if (self.content.length == 0) {
        [super setText:@""];
        [super setTextColor:self.contentColor];
    }
}

- (void)textDidChange:(NSNotification *)noti{
    [self setContent:[super text]];
}

- (void)textDidEndEditing:(NSNotification *)noti{
    if (self.content.length == 0) {
        [self setPlaceholderStyle:self.placeholder];
    }
}

@end
