//
//  ZooManager+General.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooManager+General.h"
#import "ZooCacheManager+General.h"

#import <objc/runtime.h>
#import <Zoo/Zooi18NUtil.h>

#import "ZooCrashUncaughtExceptionHandler.h"
#import "ZooCrashSignalExceptionHandler.h"

#import "ZooNSLogManager.h"


@implementation ZooManager (General)

#pragma mark - General
- (void)addGeneralPlugins {
    [self addPluginWithModel: [self appSettingPluginModel]];
    [self addPluginWithModel: [self appInfoPluginModel]];
    [self addPluginWithModel: [self appSandboxPluginModel]];
    [self addPluginWithModel: [self appRouterPluginModel]];
    [self addPluginWithModel: [self appWebviewPluginModel]];
    [self addPluginWithModel: [self appClearPluginModel]];
    [self addPluginWithModel: [self appNSLogPluginModel]];
    [self addPluginWithModel: [self appUserDefaultsPluginModel]];
    [self addPluginWithModel: [self appCrashPluginModel]];
}

- (void)setupGeneralPlugins {
    
    // Crash
    if ([[ZooCacheManager sharedInstance] crashSwitch]) {
        [ZooCrashUncaughtExceptionHandler registerHandler];
        [ZooCrashSignalExceptionHandler registerHandler];
    }
    
    // NSLog
    if ([[ZooCacheManager sharedInstance] nsLogSwitch]) {
        [[ZooNSLogManager sharedInstance] startNSLogMonitor];
    }
}

#pragma mark - Block
- (ZooURLBlock)routerBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setRouterBlock:(void(^)(NSString *url))routerBlock {
    objc_setAssociatedObject(self, @selector(routerBlock), routerBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ZooURLBlock)webviewBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWebviewBlock:(void(^)(NSString *url))webviewBlock {
    objc_setAssociatedObject(self, @selector(webviewBlock), webviewBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ZooWebpHandleBlock)webpHandleBlock {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setWebpHandleBlock:(UIImage * _Nullable(^)(NSString *filePath))webpHandleBlock {
    objc_setAssociatedObject(self, @selector(webpHandleBlock), webpHandleBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

#pragma mark - Model

- (ZooManagerPluginTypeModel *)appSettingPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"应用设置");
    model.desc = ZooLocalizedString(@"应用设置");
    model.icon = @"zoo_setting";
    model.pluginName = @"ZooAppSettingPlugin";
    model.atModule = ZooLocalizedString(@"General");
    return model;
}

- (ZooManagerPluginTypeModel *)appInfoPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"App信息");
    model.desc = ZooLocalizedString(@"App信息");
    model.icon = @"zoo_app_info";
    model.pluginName = @"ZooAppInfoPlugin";
    model.atModule = ZooLocalizedString(@"General");
    return model;
}

- (ZooManagerPluginTypeModel *)appSandboxPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"Sandbox");
    model.desc = ZooLocalizedString(@"Sandbox");
    model.icon = @"zoo_file";
    model.pluginName = @"ZooSandboxPlugin";
    model.atModule = ZooLocalizedString(@"General");
    return model;
}

- (ZooManagerPluginTypeModel *)appRouterPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"Router");
    model.desc = ZooLocalizedString(@"Router");
    model.icon = @"zoo_view_check";
    model.pluginName = @"ZooRouterPlugin";
    model.atModule = ZooLocalizedString(@"General");
    return model;
}

- (ZooManagerPluginTypeModel *)appWebviewPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"Webview");
    model.desc = ZooLocalizedString(@"Webview");
    model.icon = @"zoo_h5";
    model.pluginName = @"ZooH5Plugin";
    model.atModule = ZooLocalizedString(@"General");
    return model;
}

- (ZooManagerPluginTypeModel *)appClearPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"Clear");
    model.desc = ZooLocalizedString(@"Clear");
    model.icon = @"zoo_clear";
    model.pluginName = @"ZooDeleteLocalDataPlugin";
    model.atModule = ZooLocalizedString(@"General");
    return model;
}

- (ZooManagerPluginTypeModel *)appNSLogPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"NSLog");
    model.desc = ZooLocalizedString(@"NSLog");
    model.icon = @"zoo_nslog";
    model.pluginName = @"ZooNSLogPlugin";
    model.atModule = ZooLocalizedString(@"General");
    return model;
}

- (ZooManagerPluginTypeModel *)appUserDefaultsPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"UserDefaults");
    model.desc = ZooLocalizedString(@"UserDefaults");
    model.icon = @"zoo_database";
    model.pluginName = @"ZooNSUserDefaultsPlugin";
    model.atModule = ZooLocalizedString(@"General");
    return model;
}

- (ZooManagerPluginTypeModel *)appCrashPluginModel {
    ZooManagerPluginTypeModel *model = [ZooManagerPluginTypeModel new];
    model.title = ZooLocalizedString(@"Crash");
    model.desc = ZooLocalizedString(@"Crash");
    model.icon = @"zoo_crash";
    model.pluginName = @"ZooCrashPlugin";
    model.atModule = ZooLocalizedString(@"General");
    return model;
}

@end
