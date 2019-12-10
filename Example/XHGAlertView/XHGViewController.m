//
//  XHGViewController.m
//  XHGAlertView
//
//  Created by gdutxzy on 11/06/2018.
//  Copyright (c) 2018 gdutxzy. All rights reserved.
//

#import "XHGViewController.h"
#import <XHGAlertView/XHGAlertView.h>
#import <XHGAlertView/XHGTextView.h>
#import <XHGAlertView/XHGAlertMenusView.h>

@interface XHGViewController ()
@property (weak, nonatomic) IBOutlet XHGTextView *textView;

@end

@implementation XHGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView.layer.borderWidth = 1;
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    self.textView.layer.cornerRadius = 3;
    self.textView.placeholder = @"请输入简单的原因";

}


- (IBAction)allShow:(UIButton *)sender {
    NSLog(@">>>>>%@",[UIScreen mainScreen]);
    
    XHGAlertAction * cancleAction = [XHGAlertAction actionWithTitle:@"取消" style:XHGAlertActionStyleBoldBlack handler:nil];
    XHGAlertAction * confirmAction = [XHGAlertAction actionWithTitle:@"确认" style:XHGAlertActionStyleBoldOcean handler:^(XHGAlertAction *action, XHGAlertView *alertView) {
        XHGAlertMenusView *customView = alertView.customView;
        NSLog(@">>>>>>textViewContent:%@",customView.textView.text);
    }];
//    UILabel *customView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 50)];
//    customView.backgroundColor = [UIColor blueColor];
//    customView.text = @"自定义内容视图";
    XHGAlertMenusView *customView = [XHGAlertMenusView alertMenusViewWithTitles:@[@"1.好",@"2.不好"] textViewPlaceholder:@"请输入简单理由"];
    XHGAlertView * alert = [XHGAlertView alertWithTopImage:[UIImage imageNamed:@"default_wifi"] title:@"全样式弹窗" message:@"超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试" customizeContentView:customView actions:@[cancleAction,confirmAction]] ;
    [alert show];
    
    
}

- (IBAction)muchAlertShow:(UIButton *)sender {
    NSLog(@">>>>>1:%@",[UIApplication sharedApplication].windows);
    XHGAlertAction * cancleAction = [XHGAlertAction actionWithTitle:@"取消" style:XHGAlertActionStyleGray handler:nil];
    XHGAlertAction * confirmAction = [XHGAlertAction actionWithTitle:@"确认" style:XHGAlertActionStyleHighlight handler:nil];
    
    
    [[XHGAlertView alertWithTitle:@"1" message:nil actions:@[cancleAction,confirmAction]] show];
    [[XHGAlertView alertWithTitle:@"2" message:nil actions:@[confirmAction,cancleAction]] show];
    [self customViewAlert:nil];
    [[XHGAlertView alertWithTitle:@"3" message:nil actions:@[confirmAction,cancleAction,confirmAction]] show];
    [[XHGAlertView alertWithTitle:@"4" message:nil actions:@[confirmAction,cancleAction]] show];
    [[XHGAlertView alertWithTitle:@"5" message:nil actions:@[cancleAction,confirmAction]] show];
    [self customViewAlert:nil];
    [[XHGAlertView alertWithTitle:@"6" message:nil actions:@[confirmAction,cancleAction]] show];
    [[XHGAlertView alertWithTitle:@"7" message:nil actions:@[confirmAction,cancleAction,confirmAction]] show];
    [self customViewAlert:nil];
    [[XHGAlertView alertWithTitle:@"8" message:nil actions:@[confirmAction,cancleAction]] show];
    [self customViewAlert:nil];
    [[XHGAlertView alertWithTitle:@"9" message:nil actions:@[cancleAction,confirmAction]] show];
    
    NSLog(@">>>>>2:%@",[UIApplication sharedApplication].windows.firstObject);
    
}

- (IBAction)oneByOne:(UIButton *)sender {
    __block NSInteger index = 1;
    XHGAlertAction * confirmAction = [XHGAlertAction actionWithTitle:@"确认" style:XHGAlertActionStyleHighlight handler:^(XHGAlertAction *action, XHGAlertView *alertView) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            index += 1;
            if (index > 10) {
                return ;
            }
            XHGAlertView * alert =[XHGAlertView alertWithTitle:[NSString stringWithFormat:@"%ld",index] message:nil actions:@[action]];
            [alert show];
        });
    }];
    XHGAlertView * alert =[XHGAlertView alertWithTitle:[NSString stringWithFormat:@"%ld",index] message:nil actions:@[confirmAction]];
    [alert show];
    
}

- (IBAction)customViewAlert:(UIButton *)sender {
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"自定义弹窗视图" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    button.frame = CGRectMake(0, 0, 200, 1300);
    [button addTarget:self action:@selector(customViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    XHGAlertView * alert = [XHGAlertView alertWithCustomView:button];
    alert.dismissByTapSpace = YES;
    [alert show];
}

- (void)customViewButtonClick:(UIButton *)button{
    button.backgroundColor = [UIColor colorWithRed:(arc4random()%256/255.0) green:(arc4random()%256/255.0) blue:(arc4random()%256/255.0) alpha:1];
}



- (IBAction)showSheetView:(UIButton *)sender {
    XHGAlertAction * cancleAction = [XHGAlertAction actionWithTitle:@"取消" style:XHGAlertActionStyleBoldBlack handler:nil];
        XHGAlertAction * confirmAction = [XHGAlertAction actionWithTitle:@"确认" style:XHGAlertActionStyleBoldOcean handler:^(XHGAlertAction *action, XHGAlertView *alertView) {
            XHGAlertMenusView *customView = alertView.customView;
            NSLog(@">>>>>>textViewContent:%@",customView.textView.text);
        }];
    //    UILabel *customView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 50)];
    //    customView.backgroundColor = [UIColor blueColor];
    //    customView.text = @"自定义内容视图";
        XHGAlertMenusView *customView = [XHGAlertMenusView alertMenusViewWithTitles:@[@"1.好",@"2.不好"] textViewPlaceholder:@"请输入简单理由"];
        XHGAlertView * alert = [XHGAlertView alertWithTopImage:[UIImage imageNamed:@"default_wifi"] title:@"全样式弹窗" message:@"超长内容测试超长内容测试超长内容" customizeContentView:customView actions:@[cancleAction,cancleAction,confirmAction]] ;
        [alert showSheet];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
