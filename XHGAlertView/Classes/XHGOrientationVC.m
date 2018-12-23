//
//  XHGOrientationVC.m
//  XHGAlertView
//
//  Created by xzy on 2018/12/24.
//

#import "XHGOrientationVC.h"

@interface XHGOrientationVC ()

@end

@implementation XHGOrientationVC

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
