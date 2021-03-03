//
//  ObjectHaveProtocal.m
//  ios_temp
//
//  Created by W E on 2020/7/29.
//  Copyright © 2020 W E. All rights reserved.
//

#import "ObjectHaveProtocal.h"

@implementation ObjectHaveProtocal

- (instancetype)init {
    self = [super init];
    if (self) {
        [self performSelector:@selector(delayAction) withObject:nil afterDelay:5];
    }
    return self;
}

- (void)delayAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendMsg)]) {
        [self.delegate sendMsg];
    }
}

@end
