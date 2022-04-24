//
//  ZooNSLogModel.h
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import <Foundation/Foundation.h>

@interface ZooNSLogModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, assign) BOOL expand;

@end
