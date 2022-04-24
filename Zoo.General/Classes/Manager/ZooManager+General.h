//
//  ZooManager+General.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Zoo/ZooManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZooManager (General)

@property (nonatomic, copy) ZooURLBlock routerBlock;

@property (nonatomic, copy) ZooURLBlock webviewBlock;

// MARK: - General
- (void)addGeneralPlugins;

- (void)setupGeneralPlugins;

@end

NS_ASSUME_NONNULL_END
