//
//  TestProtocol.m
//  ios_temp
//
//  Created by W E on 2020/7/29.
//  Copyright © 2020 W E. All rights reserved.
//

#import "TestProtocol.h"

@implementation TestProtocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = @"im ok, im fine, thank you";
    return cell;
}

@end
