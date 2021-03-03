//
//  CameraTest.m
//  Runner
//
//  Created by W E on 2020/8/10.
//
/*
 AVCaptureStillImageOutput 区别？都是单张静态？
 AVCapturePhotoOutput
 
 视频
 AVCaptureVideoDataOutput
 */
#import "CameraTest.h"

@interface CameraTest()
@property (strong ,nonatomic) AVCaptureSession *captureSession;
@property (strong ,nonatomic) AVCaptureDeviceInput *captureDeviceInput;
//@property (strong ,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;
@property (strong ,nonatomic) AVCaptureVideoDataOutput *videoOutput;
@end

@implementation CameraTest

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initCaptureSession];
    }
    return self;
}

- (void)initCaptureSession {
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPresetHigh]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPresetHigh;
    }
    
    //获得输入设备,后置摄像头
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
    }
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
    }
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
    
//    _captureStillImageOutput=[[AVCaptureStillImageOutput alloc]init];
//    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
//    [_captureStillImageOutput setOutputSettings:outputSettings];//输出设置
//    
//    //添加拍照输出
//    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
//        [_captureSession addOutput:_captureStillImageOutput];
//    }
    
    _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    FourCharCode const videoFormat = kCVPixelFormatType_32BGRA;
    _videoOutput.videoSettings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey : @(videoFormat)};
    [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    [_videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    //添加视频输出
    if ([_captureSession canAddOutput:_videoOutput]) {
        [_captureSession addOutput:_videoOutput];
    }
    
    AVCaptureConnection *videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    // 设置采集图像的方向,如果不设置，采集回来的图形会是旋转90度的
    videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    if ([_captureSession canAddConnection:videoConnection]) {
        [_captureSession addConnection:videoConnection];
    }
}

-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

- (void)startCapture {
    [self.captureSession startRunning];
}

- (void)stopCapture {
    [self.captureSession stopRunning];
}

#pragma mark 拍照
- (void)takeButtonClick:(UIButton *)sender {
//    //根据设备输出获得连接
//    AVCaptureConnection *captureConnection=[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
//    //根据连接取得设备输出的数据
//    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
//        if (imageDataSampleBuffer) {
//            NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//            UIImage *image=[UIImage imageWithData:imageData];
//
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
//        }
//
//    }];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CVPixelBufferRef newBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFRetain(newBuffer);
    CVPixelBufferRef old = _latestPixelBuffer;
    while (!OSAtomicCompareAndSwapPtrBarrier(old, newBuffer, (void **)&_latestPixelBuffer)) {
      old = _latestPixelBuffer;
    }
    if (old != nil) {
      CFRelease(old);
    }
    if (_onFrameAvailable) {
      _onFrameAvailable();
    }
}

#pragma mark - FlutterTextureDelegate

- (CVPixelBufferRef _Nullable)copyPixelBuffer {
    CVPixelBufferRef pixelBuffer = _latestPixelBuffer;
    while (!OSAtomicCompareAndSwapPtrBarrier(pixelBuffer, nil, (void **)&_latestPixelBuffer)) {
      pixelBuffer = _latestPixelBuffer;
    }
    return pixelBuffer;
}

@end
