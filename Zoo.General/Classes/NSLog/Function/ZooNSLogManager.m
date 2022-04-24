//
//  ZooNSLogManager.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooNSLogManager.h"
#import <Zoo/zoo_fishhook.h>

//函数指针，用来保存原始的函数的地址
static void(*old_nslog)(NSString *format, ...);

//新的NSLog
void zooNSLog(NSString *format, ...){
    
    va_list vl;
    va_start(vl, format);
    NSString* str = [[NSString alloc] initWithFormat:format arguments:vl];
    va_end(vl);
    
    [[ZooNSLogManager sharedInstance] addNSLog:str];
    //再调用原来的nslog
    //old_nslog(str);
    old_nslog(@"%@",str);
}


@implementation ZooNSLogManager

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)startNSLogMonitor{
    zoo_rebind_symbols((struct zoo_rebinding[1]){"NSLog", (void *)zooNSLog, (void **)&old_nslog},1);
}

- (void)stopNSLogMonitor{
    zoo_rebind_symbols((struct zoo_rebinding[1]){"NSLog", (void *)old_nslog, NULL},1);
}

- (void)addNSLog:(NSString *)log{
    ZooNSLogModel *model = [[ZooNSLogModel alloc] init];
    model.content = log;
    model.timeInterval = [[NSDate date] timeIntervalSince1970];
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    [_dataArray addObject:model];
    
//    return;
//    if (@available(iOS 13.0, *)) {
//    }else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[ZooStateBar shareInstance] renderUIWithContent:[NSString stringWithFormat:@"[NSLog] : %@",log] from:ZooStateBarFromNSLog];
//        });
//    }

}

@end
