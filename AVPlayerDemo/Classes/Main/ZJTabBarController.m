//
//  ZJTabBarController.m
//  AVPlayerDemo
//
//  Created by 邓志坚 on 2018/10/10.
//  Copyright © 2018 邓志坚. All rights reserved.
//

#import "ZJTabBarController.h"
#import "ZJHomeViewController.h"
#import "ZJNavigationController.h"

@interface ZJTabBarController ()

@end

@implementation ZJTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpChildVC:[[ZJHomeViewController alloc]init] title:@"首页"];
    
}

-(void)setUpChildVC:(UIViewController *)childVc title:(NSString *)title {
    childVc.title = title;
    ZJNavigationController *nav = [[ZJNavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:nav];
}




@end
