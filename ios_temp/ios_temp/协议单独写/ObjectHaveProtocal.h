//
//  ObjectHaveProtocal.h
//  ios_temp
//
//  Created by W E on 2020/7/29.
//  Copyright © 2020 W E. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ObjectProtocal <NSObject>
- (void)sendMsg;

@end

@interface ObjectHaveProtocal : NSObject
@property (nonatomic ,weak)id<ObjectProtocal>delegate;
@end

NS_ASSUME_NONNULL_END
