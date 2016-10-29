//
//  QFCrashManager.h
//  QFFramework
//
//  Created by junge on 16/6/27.
//  Copyright © 2016年 junge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFCrashManager : NSObject

void uncaughtExceptionHandler(NSException *exception);

// 是否有crash
+ (BOOL)hasCrash;

// 清除crash log
+ (void)clearCrash;

@end
