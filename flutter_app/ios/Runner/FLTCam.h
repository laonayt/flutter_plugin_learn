//
//  FLTCam.h
//  Runner
//
//  Created by W E on 2020/8/18.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import "FLTImageStreamHandler.h"
#import "FLTSavePhotoDelegate.h"
#import <CoreMotion/CoreMotion.h>

#import <Accelerate/Accelerate.h>
#import <libkern/OSAtomic.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLTCam : NSObject <FlutterTexture,
AVCaptureVideoDataOutputSampleBufferDelegate,
AVCaptureAudioDataOutputSampleBufferDelegate,
FlutterStreamHandler>
@property(nonatomic, copy) void (^onFrameAvailable)(void);
@property(readonly, nonatomic) CGSize previewSize;
@property(readonly, nonatomic) CGSize captureSize;
@property(nonatomic) FlutterEventChannel *eventChannel;

- (instancetype)initWithCameraName:(NSString *)cameraName
                  resolutionPreset:(NSString *)resolutionPreset
                       enableAudio:(BOOL)enableAudio
                     dispatchQueue:(dispatch_queue_t)dispatchQueue
                             error:(NSError **)error;

- (void)start;
- (void)stop;
- (void)close;
- (void)startVideoRecordingAtPath:(NSString *)path result:(FlutterResult)result;
- (void)stopVideoRecordingWithResult:(FlutterResult)result;
- (void)startImageStreamWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger;
- (void)stopImageStream;
- (void)captureToFile:(NSString *)filename result:(FlutterResult)result;
- (void)setUpCaptureSessionForAudio;
- (void)pauseVideoRecording;
- (void)resumeVideoRecording;
@end

NS_ASSUME_NONNULL_END
