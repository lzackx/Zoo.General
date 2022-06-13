//
//  ZooAppInfoPlugin.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooAppInfoPlugin.h"
#import <Zoo/ZooHomeWindow.h>
#import "ZooAppInfoViewController.h"

@implementation ZooAppInfoPlugin

- (void)pluginDidLoad{
    ZooAppInfoViewController *vc = [[ZooAppInfoViewController alloc] init];
    [ZooHomeWindow openPlugin:vc];
}

@end
