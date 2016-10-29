//
//  QFJSPatch.h
//  QFFramework
//
//  Created by junge on 16/5/30.
//  Copyright © 2016年 junge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFJSPatch : NSObject

// 请求js
+ (void)requestJSWithUrl:(NSString *)url appName:(NSString *)appName;

// 执行js
+ (void)execJS;

@end
