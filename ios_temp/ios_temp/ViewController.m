//
//  ViewController.m
//  ios_temp
//
//  Created by W E on 2020/7/21.
//  Copyright © 2020 W E. All rights reserved.
//

#import "ViewController.h"
#import "LFViewController.h"
#import "CameraViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 60, 45)];
    [btn addTarget:self action:@selector(btnActon) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor systemPinkColor];
    [self.view addSubview:btn];
    
    //oc中的强制类型转换
    NSDictionary *dic = @{@"dd" : @"a"};
    NSInteger dd = [dic[@"dd"] integerValue];
    NSLog(@"dd = %ld",(long)dd);
}

- (void)btnActon {
    CameraViewController *vc = [[CameraViewController alloc] init];
    [self presentViewController:vc animated:true completion:nil];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"barrageNoti" object:@"Hello World"];
}


@end
