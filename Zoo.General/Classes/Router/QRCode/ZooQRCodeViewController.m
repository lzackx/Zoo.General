//
//  ZooQRCodeViewController.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooQRCodeViewController.h"
#import <Zoo/ZooDefaultWebViewController.h>
#import <Zoo/ZooDefine.h>
#import "ZooQRScanView.h"


@interface ZooQRCodeViewController ()<ZooQRScanDelegate>

@property (nonatomic, strong) ZooQRScanView *scanView;

@end
@implementation ZooQRCodeViewController

- (void)leftNavBackClick:(id)clickView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
#endif
       self.view.backgroundColor = [UIColor whiteColor];
#if defined(__IPHONE_13_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0)
    }
#endif
    self.title = ZooLocalizedString(@"扫描二维码");
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    ZooQRScanView *scaner = [[ZooQRScanView alloc] initWithFrame:self.view.bounds];
    scaner.delegate = self;
    scaner.showScanLine = YES;
    scaner.showBorderLine = YES;
    scaner.showCornerLine = YES;
    scaner.scanRect = CGRectMake(scaner.zoo_width/2-kZooSizeFrom750(480)/2, kZooSizeFrom750(195), kZooSizeFrom750(480), kZooSizeFrom750(480));
    [self.view addSubview:scaner];
    self.scanView = scaner;
    [scaner startScanning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeScanView];
}

- (void)removeScanView{
    if (self.scanView) {
        [self.scanView stopScanning];
        [self.scanView removeFromSuperview];
        self.scanView = nil;
    }
}


#pragma mark -- ZooQRScanDelegate
- (void)scanView:(ZooQRScanView *)scanView pickUpMessage:(NSString *)message{
    if(message.length>0){
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.QRCodeBlock) {
                self.QRCodeBlock(message);
            }
        }];
    }
}

- (void)scanView:(ZooQRScanView *)scanView aroundBrightness:(NSString *)brightnessValue{
    
}

@end
