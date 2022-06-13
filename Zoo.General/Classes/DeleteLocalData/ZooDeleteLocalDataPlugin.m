//
//  ZooDeleteLocalDataPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooDeleteLocalDataPlugin.h"
#import <Zoo/ZooHomeWindow.h>
#import "ZooDeleteLocalDataViewController.h"

@implementation ZooDeleteLocalDataPlugin

- (void)pluginDidLoad{
    ZooDeleteLocalDataViewController *vc = [[ZooDeleteLocalDataViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
