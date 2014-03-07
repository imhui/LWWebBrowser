//
//  LWNavigationController.m
//  LWWebBrowser
//
//  Created by LiYonghui on 14-3-7.
//  Copyright (c) 2014年 LiYonghui. All rights reserved.
//

#import "LWNavigationController.h"

@implementation LWNavigationController

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
