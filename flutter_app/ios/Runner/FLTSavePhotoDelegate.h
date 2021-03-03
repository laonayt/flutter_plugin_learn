//
//  FLTSavePhotoDelegate.h
//  Runner
//
//  Created by W E on 2020/8/18.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import <CoreMotion/CoreMotion.h>

NS_ASSUME_NONNULL_BEGIN

@interface FLTSavePhotoDelegate : NSObject<AVCapturePhotoCaptureDelegate>

- initWithPath:(NSString *)filename
        result:(FlutterResult)result
 motionManager:(CMMotionManager *)motionManager
cameraPosition:(AVCaptureDevicePosition)cameraPosition;

@end

NS_ASSUME_NONNULL_END
