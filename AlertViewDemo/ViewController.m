//
//  ViewController.m
//  AlertViewDemo
//
//  Created by XZY on 2018/9/5.
//  Copyright © 2018年 xiezongyuan. All rights reserved.
//

#import "ViewController.h"
#import "XHGAlertView.h"
#import "ShortcutFuction.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)allShow:(UIButton *)sender {
    XHGAlertAction * cancleAction = [XHGAlertAction actionWithTitle:@"取消" style:XHGAlertActionStyleGray handler:nil];
    XHGAlertAction * confirmAction = [XHGAlertAction actionWithTitle:@"确认" style:XHGAlertActionStyleHighlight handler:nil];
    XHGAlertAction * menu1 = [XHGAlertAction actionWithTitle:@"1" style:XHGAlertActionStyleHighlight handler:nil];
    XHGAlertAction * menu2 = [XHGAlertAction actionWithTitle:@"2" style:XHGAlertActionStyleHighlight handler:nil];
    XHGAlertView * alert = [XHGAlertView alertWithTopImage:[UIImage imageNamed:@"default_wifi"] title:@"全样式弹窗" message:@"超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试超长内容测试" menus:@[menu1,menu2] actions:@[cancleAction,confirmAction]];
    [alert show];
    
}

- (IBAction)muchAlertShow:(UIButton *)sender {
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
    button.frame = CGRectMake(0, 0, 200, 300);
    [button addTarget:self action:@selector(customViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    XHGAlertView * alert = [XHGAlertView alertWithCustomView:button];
    alert.dismissByTapSpace = YES;
    [alert show];
}

- (void)customViewButtonClick:(UIButton *)button{
    button.backgroundColor = colorRGBA(arc4random()%256, arc4random()%256, arc4random()%256, 1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
