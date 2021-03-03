//
//  FLTImageStreamHandler.h
//  Runner
//
//  Created by W E on 2020/8/18.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLTImageStreamHandler : NSObject<FlutterStreamHandler>
@property FlutterEventSink eventSink;
@end

NS_ASSUME_NONNULL_END
