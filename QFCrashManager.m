//
//  QFCrashManager.m
//  QFFramework
//
//  Created by junge on 16/6/27.
//  Copyright © 2016年 junge. All rights reserved.
//

#define crashLogPath [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"/microFinanceCrashError.txt"]

#import "QFCrashManager.h"

@implementation QFCrashManager

#pragma mark - 捕捉Crash
void uncaughtExceptionHandler(NSException *exception)
{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    NSString *reason = [exception reason];
    
    // 异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    
    NSMutableArray *tmpArr = [NSMutableArray arrayWithArray:stackArray];
    
    [tmpArr insertObject:reason atIndex:0];
    
    [exceptionInfo writeToFile:[NSString stringWithFormat:@"%@/Documents/microFinanceCrashError.txt",NSHomeDirectory()]  atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (void)clearCrash
{
    [[QFCrashManager sharedInstance] clearCrash];
}

+ (BOOL)hasCrash
{
    return [[QFCrashManager sharedInstance] hasCrash];
}


- (void)clearCrash
{
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    [fileManager removeItemAtPath:crashLogPath error:nil];
}


- (BOOL)hasCrash
{
    NSError *error;
    NSString *textFileContents = [NSString stringWithContentsOfFile:crashLogPath encoding:NSUTF8StringEncoding error:&error];
    if ([self checkConvertNull:textFileContents])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)checkConvertNull:(NSString *)object
{
    if ([object isEqual:[NSNull null]] || [object isKindOfClass:[NSNull class]] ||object==nil || [object isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}

@end
