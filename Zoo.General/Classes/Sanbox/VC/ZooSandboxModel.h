//
//  ZooSandboxModel.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ZooSandboxFileType) {
    ZooSandboxFileTypeDirectory = 0,//目录
    ZooSandboxFileTypeFile,//文件
    ZooSandboxFileTypeBack,//返回
    ZooSandboxFileTypeRoot,//根目录
};

@interface ZooSandboxModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign) ZooSandboxFileType type;

@end
