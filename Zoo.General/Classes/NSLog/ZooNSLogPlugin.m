//
//  ZooNSLogPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNSLogPlugin.h"
#import <Zoo/ZooHomeWindow.h>
#import "ZooNSLogViewController.h"

@implementation ZooNSLogPlugin

- (void)pluginDidLoad{
    ZooNSLogViewController *vc = [[ZooNSLogViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
