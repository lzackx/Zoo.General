//
//  ZooQRCodeViewController.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>
#import "ZooBaseViewController.h"

@interface ZooQRCodeViewController : ZooBaseViewController
@property (nonatomic, copy) void(^QRCodeBlock)(NSString *QRCodeResult);
@end

