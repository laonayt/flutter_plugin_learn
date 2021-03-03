//
//  CameraTest.h
//  Runner
//
//  Created by W E on 2020/8/10.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>
#import <AVFoundation/AVFoundation.h>

#import <libkern/OSAtomic.h>//干嘛的？

NS_ASSUME_NONNULL_BEGIN

@interface CameraTest : NSObject<FlutterTexture,AVCaptureVideoDataOutputSampleBufferDelegate>
@property(readonly) CVPixelBufferRef volatile latestPixelBuffer;
@property(nonatomic, copy) void (^onFrameAvailable)(void);

- (void)startCapture;

@end

NS_ASSUME_NONNULL_END
