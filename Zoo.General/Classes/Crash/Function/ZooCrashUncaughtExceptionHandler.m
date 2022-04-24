//
//  ZooCrashUncaughtExceptionHandler.m
//  Zoo
//
//  Created by lZackx on 2022/4/14.

#import "ZooCrashUncaughtExceptionHandler.h"

#import "ZooCrashTool.h"

// 记录之前的崩溃回调函数
static NSUncaughtExceptionHandler *previousUncaughtExceptionHandler = NULL;

@implementation ZooCrashUncaughtExceptionHandler

#pragma mark - Register

+ (void)registerHandler {
    // Backup original handler
    previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    
    NSSetUncaughtExceptionHandler(&ZooUncaughtExceptionHandler);
}

#pragma mark - Private

// 崩溃时的回调函数
static void ZooUncaughtExceptionHandler(NSException * exception) {
    // 异常的堆栈信息
    NSArray * stackArray = [exception callStackSymbols];
    // 出现异常的原因
    NSString * reason = [exception reason];
    // 异常名称
    NSString * name = [exception name];
    
    NSString * exceptionInfo = [NSString stringWithFormat:@"========uncaughtException异常错误报告========\nname:%@\nreason:\n%@\ncallStackSymbols:\n%@", name, reason, [stackArray componentsJoinedByString:@"\n"]];
    
    // 保存崩溃日志到沙盒cache目录
    [ZooCrashTool saveCrashLog:exceptionInfo fileName:@"Crash(Uncaught)"];
    
    // 调用之前崩溃的回调函数
    if (previousUncaughtExceptionHandler) {
        previousUncaughtExceptionHandler(exception);
    }
    
    // 杀掉程序，这样可以防止同时抛出的SIGABRT被SignalException捕获
    kill(getpid(), SIGKILL);
}

@end
