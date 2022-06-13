//
//  ZooAppSettingPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooAppSettingPlugin.h"
#import <Zoo/ZooUtil.h>
#import <Zoo/ZooHomeWindow.h>

@implementation ZooAppSettingPlugin

- (void)pluginDidLoad {
    [ZooUtil openAppSetting];
    [[ZooHomeWindow shareInstance] hide];
}

@end
