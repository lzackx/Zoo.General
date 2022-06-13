//
//  ZooRouterPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooRouterPlugin.h"
#import "ZooRouterViewController.h"
#import <Zoo/ZooHomeWindow.h>

@implementation ZooRouterPlugin

- (void)pluginDidLoad{
    ZooRouterViewController *vc = [[ZooRouterViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
