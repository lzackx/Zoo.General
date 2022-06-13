//
//  ZooNSUserDefaultsPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNSUserDefaultsPlugin.h"
#import "ZooNSUserDefaultsViewController.h"
#import <Zoo/ZooHomeWindow.h>

@implementation ZooNSUserDefaultsPlugin
- (void)pluginDidLoad{
    ZooNSUserDefaultsViewController *vc = [[ZooNSUserDefaultsViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
