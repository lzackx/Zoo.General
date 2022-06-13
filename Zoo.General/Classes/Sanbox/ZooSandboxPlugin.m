//
//  ZooSandboxPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooSandboxPlugin.h"
#import "ZooSandboxViewController.h"
#import <Zoo/ZooHomeWindow.h>

@implementation ZooSandboxPlugin

- (void)pluginDidLoad{
    ZooSandboxViewController *vc = [[ZooSandboxViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
