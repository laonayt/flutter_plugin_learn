//
//  ChatRoomView.h
//  ios_temp
//
//  Created by W E on 2020/7/21.
//  Copyright © 2020 W E. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatRoomView : UIView
- (void)mockReceiveMsg:(NSString *)msg;

@end

@interface ChatCell : UITableViewCell
@property(nonatomic ,strong)UILabel *titleLabel;
@property(nonatomic ,copy) NSString *content;
@end

NS_ASSUME_NONNULL_END
