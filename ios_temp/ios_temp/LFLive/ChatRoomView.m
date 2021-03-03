//
//  ChatRoomView.m
//  ios_temp
//
//  Created by W E on 2020/7/21.
//  Copyright © 2020 W E. All rights reserved.
//

#import "ChatRoomView.h"

@interface ChatRoomView()<UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property (strong , nonatomic) NSMutableArray * dataArray;
@end

@implementation ChatRoomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
    }
    return self;
}

//这个方法相当于vc中的viewDidLoad
- (void)didMoveToWindow {
    if (self.window) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveBarrageMsg:) name:@"barrageNoti" object:nil];
    }
}

//从当前window删除 相当于-viewDidUnload
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow == nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)mockReceiveMsg:(NSString *)msg {
    [self.dataArray addObject:msg];
    [self.tableView reloadData];
    
    if (self.dataArray.count > 20) {
        [self.dataArray removeObjectsInRange:NSMakeRange(0, 15)];
        [self.tableView reloadData];
        return;
    }
    
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.tableView reloadData];
//    });
}

#pragma mark 接收信息的代理
-(void)receiveBarrageMsg:(NSNotification *)noti {
    [self.dataArray addObject:noti.object];
    [self.tableView reloadData];
    
    if (self.dataArray.count > 20) {
        [self.dataArray removeObjectsInRange:NSMakeRange(0, 15)];
        [self.tableView reloadData];
        return;
    }
    
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count -1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"chatCell"];
//    }
//    cell.textLabel.text = self.dataArray[indexPath.row];
////    cell.textLabel.font = [UIFont systemFontOfSize:14];
//    cell.textLabel.textColor = [UIColor whiteColor];
//    cell.backgroundColor = [self randomColor];
//    cell.titleLabel.text = self.dataArray[indexPath.row];
    cell.content = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = 40;
        [_tableView registerClass:[ChatCell class] forCellReuseIdentifier:@"chatCell"];
        _tableView.transform = CGAffineTransformMakeScale (1,-1);
    }
    return _tableView;
}

@end

@implementation ChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.transform = CGAffineTransformMakeScale (1,-1);
        self.backgroundColor = [UIColor clearColor];
//        self.contentView.layer.cornerRadius = 20;
//        self.contentView.layer.masksToBounds = true;
        
        //CGRectMake(8, 8, self.bounds.size.width-16, self.bounds.size.height-16)
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor redColor];
        label.backgroundColor = [self randomColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.titleLabel = label;
        
        label.layer.cornerRadius = 10;
        label.layer.masksToBounds = true;
        
    }
    return self;
}

- (void)setContent:(NSString *)content {
    _content = content;
    _titleLabel.text = content;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],};
    CGSize textSize = [content boundingRectWithSize:CGSizeMake(100, 40) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    CGRect f = self.bounds;
    f.size.width = textSize.width + 30;
    f.size.height -= 10;
    _titleLabel.frame = f;
}

//- (void)setFrame:(CGRect)frame {
//    frame.size.height -= 10;
//    [super setFrame:frame];
//}

//- (void)setFrame:(CGRect)frame {
//    self.titleLabel.frame = self.bounds;
//    [super setFrame:frame];
//}

//- (void)setFrame:(CGRect)frame{
////    self.titleLabel.frame = self.bounds;
//    CGRect f = frame;
//    //距离左边框的距离
//    f.origin.x = 5;
//    //距离右边框的距离
//
//    f.size.width = frame.size.width - 10;
//    [super setFrame:f];
////半径
//     self.layer.cornerRadius = 10.0;
//
//}

- (UIColor *)randomColor {
    CGFloat r = arc4random()%254/256.0;
    CGFloat g = arc4random()%254/256.0;
    CGFloat b = arc4random()%254/256.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

@end
