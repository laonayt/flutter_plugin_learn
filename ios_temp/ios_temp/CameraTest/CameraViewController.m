//
//  CameraTest.m
//  Runner
//
//  Created by W E on 2020/8/10.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface CameraViewController()<AVCaptureVideoDataOutputSampleBufferDelegate>
@property (strong,nonatomic) AVCaptureSession *captureSession;
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;
@property (strong ,nonatomic) AVCaptureVideoDataOutput *videoOutput;
//@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (strong,nonatomic) UIImageView *imageV;
@end

@implementation CameraViewController

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    [self.captureSession startRunning];
//}
//
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [self.captureSession stopRunning];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:imageV];
    self.imageV = imageV;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 45)];
    [btn setTitle:@"拍照" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(takeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self initCamera];
}

- (void)initCamera {
    _captureSession = [[AVCaptureSession alloc] init];
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
        _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
    }
    
    [self addDeviceInput];
    [self addVideoOutput];
    [self addImageOutput];
    
    AVCaptureConnection *videoConnection = [self.videoOutput connectionWithMediaType:AVMediaTypeVideo];
    // 设置采集图像的方向,如果不设置，采集回来的图形会是旋转90度的
    videoConnection.videoOrientation = AVCaptureVideoOrientationPortrait;
    
    if ([_captureSession canAddConnection:videoConnection]) {
        [_captureSession addConnection:videoConnection];
    }
    
    [_captureSession startRunning];
    
//    //创建视频预览层，用于实时展示摄像头状态
//    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
//    _captureVideoPreviewLayer.frame=self.view.bounds;
//    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspect;
//    [self.view.layer addSublayer:_captureVideoPreviewLayer];
}

- (void)addDeviceInput {
    //获得输入设备,后置摄像头
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
    }
}

- (void)addVideoOutput {
    _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    [_videoOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    [_videoOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    if ([_captureSession canAddOutput:_videoOutput]) {
        [_captureSession addOutput:_videoOutput];
    }
}

- (void)addImageOutput {
//    //初始化设备输出对象，用于获得输出数据
//    _captureStillImageOutput=[[AVCaptureStillImageOutput alloc]init];
//    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
//    [_captureStillImageOutput setOutputSettings:outputSettings];//输出设置
//
//    //将设备输出添加到会话中
//    if ([_captureSession canAddOutput:_captureStillImageOutput]) {
//        [_captureSession addOutput:_captureStillImageOutput];
//    }
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
    _imageV.image = [self imageFromSampleBuffer:sampleBuffer];
}

- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CIImage *ciImage = [CIImage imageWithCVPixelBuffer:imageBuffer];
    CIContext *temporaryContext = [CIContext contextWithOptions:nil];
    CGImageRef videoImage = [temporaryContext createCGImage:ciImage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(imageBuffer), CVPixelBufferGetHeight(imageBuffer))];
    
    UIImage *image = [[UIImage alloc] initWithCGImage:videoImage];
    CGImageRelease(videoImage);
    return image;
}

@end
