//
//  ZooCrashPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooCrashPlugin.h"
#import "ZooCrashViewController.h"
#import <Zoo/ZooHomeWindow.h>

@implementation ZooCrashPlugin

- (void)pluginDidLoad{
    ZooCrashViewController *vc = [[ZooCrashViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
