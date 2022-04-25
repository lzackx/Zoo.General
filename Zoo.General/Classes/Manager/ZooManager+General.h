//
//  ZooManager+General.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Zoo/ZooManager.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^ZooURLBlock)(NSString *);
typedef UIImage * _Nullable (^ZooWebpHandleBlock)(NSString *filePath);

@interface ZooManager (General)

@property (nonatomic, copy) ZooURLBlock routerBlock;

@property (nonatomic, copy) ZooURLBlock webviewBlock;

@property (nonatomic, copy) ZooWebpHandleBlock webpHandleBlock;

- (void)addWebpHandleBlock:(ZooWebpHandleBlock)block;

// MARK: - General
- (void)addGeneralPlugins;

- (void)setupGeneralPlugins;

@end

NS_ASSUME_NONNULL_END
