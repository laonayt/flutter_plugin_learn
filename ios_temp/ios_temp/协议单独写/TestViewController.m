//
//  TestViewController.m
//  ios_temp
//
//  Created by W E on 2020/7/29.
//  Copyright © 2020 W E. All rights reserved.
//

#import "TestViewController.h"
#import "TestProtocol.h"
#import "TestViewController2.h"
#import "ObjectHaveProtocal.h"

@interface TestViewController ()
@property(nonatomic ,strong)UITableView *tableView;
@property(nonatomic ,strong)TestProtocol *testProtocal;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    backBtn.backgroundColor = [UIColor systemPinkColor];
    [backBtn setTitle:@"跳转" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
}

- (void)btnAction {
    TestViewController2 *test2VC = [[TestViewController2 alloc] init];
    
    ObjectHaveProtocal *obj = [[ObjectHaveProtocal alloc] init];
    obj.delegate = test2VC;
    
    [self presentViewController:test2VC animated:true completion:nil];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.tableFooterView = [UIView new];
        
        TestProtocol *testProtocal = [[TestProtocol alloc] init];
        _tableView.dataSource = testProtocal;//不能用
        self.testProtocal = testProtocal;//能用
        /*
         为什么必须类引用一下才能行? tableView不是已经引用它了吗，而且tableView也没释放
         难道是因为 protocal是weak引用的原因？！！
         */
        
    
    }
    return _tableView;
}

@end
