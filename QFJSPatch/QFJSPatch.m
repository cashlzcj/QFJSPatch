//
//  QFJSPatch.m
//  QFFramework
//
//  Created by junge on 16/5/30.
//  Copyright © 2016年 junge. All rights reserved.
//

#import "QFJSPatch.h"
#import "JPEngine.h"
#import "CocoaSecurity.h"
#import "QFCrashManager.h"
#import "RSA.h"

#define AES_KEY                      @"patch"
#define VERSION                      @"version"
#define APPNAME                      @"appName"
#define POST                         @"POST"
#define CONTENTTYPE                  @"Content-Type"
#define CONTENTTYPE_VALUE            @"application/json; charset=UTF-8"
#define VERIFY                       @"verify"
#define DATA                         @"data"
#define CODE                         @"code"
#define PUBLICKEY                    @"public_key"
#define PEM                          @"pem"
#define PATCHFOLDER                  @"patch"
#define SHORTVERSION                 [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];

@interface QFJSPatch ()

@property (nonatomic, strong) NSString *jsPath;

@end

@implementation QFJSPatch

- (instancetype)init
{
    if (self = [super init]) {
        _jsPath = [self jsPatchPath];
        NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    }
    
    [self clearCrashAndJS];
    
    return self;
}

+ (void)requestJSWithUrl:(NSString *)url appName:(NSString *)appName
{
    [[QFJSPatch sharedInstance] requestJSWithUrl:url appName:appName];
}

// 执行js
+ (void)execJS
{
    [[QFJSPatch sharedInstance] execJS];
}

- (void)requestJSWithUrl:(NSString *)url appName:(NSString *)appName
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    NSDictionary *dicBody = [NSMutableDictionary dictionary];
    [dicBody setValue:[self version] forKey:VERSION];
    [dicBody setValue:appName forKey:APPNAME];
    
    if ([NSJSONSerialization isValidJSONObject:dicBody])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicBody options:NSJSONWritingPrettyPrinted error:&error];
        [request setHTTPMethod:POST];
        [request addValue:CONTENTTYPE_VALUE forHTTPHeaderField:CONTENTTYPE];
        [request setHTTPBody:jsonData];
        [self requestWithMutableURLRequest:request];
    }
}

- (void)requestWithMutableURLRequest:(NSMutableURLRequest *)request
{
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = httpResponse.statusCode;
        if(200 == statusCode)
        {
            NSError *error;
            NSDictionary *dicObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSString *verify = dicObj[VERIFY];
            NSString *script = dicObj[DATA];
            NSInteger code = [dicObj[CODE] integerValue];
            
            if (-1 == code)
            {
                [self rmLocalJS];
            }
            else if ( 0 == code && [self verify:verify script:script] )
            {
                NSData *jsData = [[CocoaSecurity aesEncrypt:script key:AES_KEY].base64 dataUsingEncoding:NSUTF8StringEncoding];
                [jsData writeToFile:self.jsPath atomically:YES];
                [self execJS];
            }
        }
    }];
}

- (void)clearCrashAndJS
{
   if([QFCrashManager hasCrash])
   {
       [self rmLocalJS];
       [QFCrashManager clearCrash];
   }
}

// 校验js是否被篡改
- (BOOL)verify:(NSString *)verify script:(NSString *)script
{
    NSString *cdMd5 = [RSA decryptString:verify publicKey:[self publicKey]];
    NSString *jsMd5 = [CocoaSecurity md5:script].hexLower;
    
    if (![cdMd5 isEqualToString:jsMd5]) {
        //        NSLog(@"js被篡改了");
        return NO;
    }
    
    return YES;
}

- (NSString *)publicKey
{
    NSString *publicKeyPath = [[NSBundle mainBundle] pathForResource:PUBLICKEY ofType:PEM];
    return [[NSString stringWithContentsOfFile:publicKeyPath encoding:NSUTF8StringEncoding error:nil] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)execJS
{
    [self execJS:[self loadJS]];
}

- (void)execJS:(NSString *)script
{
    if (nil != script) {
        [JPEngine startEngine];
        [JPEngine evaluateScript:script];
    }
}

- (NSString *)loadJS
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:self.jsPath])
    {
        return nil;
    }
    
    NSString *script = [CocoaSecurity aesDecryptWithBase64:[NSString stringWithContentsOfFile:self.jsPath encoding:NSUTF8StringEncoding error:nil] key:AES_KEY].utf8String ;
    return script;
}

- (void)rmLocalJS
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:self.jsPath])
    {
        [fileManager removeItemAtPath:self.jsPath error:nil];
    }
}

- (NSString *)version
{
    return SHORTVERSION;
}

- (NSString *)jsPatchPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths[0] stringByAppendingPathComponent:[PATCHFOLDER stringByAppendingString:[self version]]];
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id __singleton__;
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } );
    return __singleton__;
}

@end
