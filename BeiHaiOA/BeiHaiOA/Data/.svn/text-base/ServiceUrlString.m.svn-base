//
//  ServiceUrlString.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ServiceUrlString.h"
#import "SystemConfigContext.h"
#import "OperateLogHelper.h"

@implementation ServiceUrlString

+ (NSString*)generateUrlByParameters:(NSDictionary*)params
{
    if(params == nil)
    {
        return @"";
    }
    NSArray *aryKeys = [params allKeys];
    if(aryKeys == nil)
    {
        return @"";
    }
    
    NSMutableString *paramsStr = [NSMutableString stringWithCapacity:100];
    for(NSString *str in aryKeys)
    {
        [paramsStr appendFormat:@"&%@=%@",str,[params objectForKey:str]];
    }
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];

    NSString *strUrl = [NSString stringWithFormat:@"http://%@/invoke/?version=%@&imei=%@&clientType=IPAD&userid=%@&password=%@%@",[context getSeviceHeader], [context getAppVersion], [context getDeviceID],[loginUsr objectForKey:@"userId"],[loginUsr objectForKey:@"password"], paramsStr];
    NSString *modifiedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strUrl, nil, nil,kCFStringEncodingUTF8));
    
    OperateLogHelper *helper = [[OperateLogHelper alloc] init];
    [helper saveOperate:[params objectForKey:@"service"] andUserID:[loginUsr objectForKey:@"userId"]];
    
    DLog(@"局请求的服务地址:%@", modifiedUrl);
    return modifiedUrl;
}

+ (NSString*)generateTingUrlByParameters:(NSDictionary*)params
{
    if(params == nil)
    {
        return @"";
    }
    NSArray *aryKeys = [params allKeys];
    if(aryKeys == nil)
    {
        return @"";
    }
    NSMutableString *paramsStr = [NSMutableString stringWithCapacity:100];
    for(NSString *str in aryKeys)
    {
        [paramsStr appendFormat:@"&%@=%@",str,[params objectForKey:str]];
    }
    SystemConfigContext *context = [SystemConfigContext sharedInstance];
    NSDictionary *loginUsr = [context getUserInfo];
    
    //正式使用
    NSString *strUrl = [NSString stringWithFormat:@"https://221.7.135.211/semop/invoke/?version=%@&imei=%@&clientType=IPAD&userid=%@&password=%@%@", [context getAppVersion], [context getDeviceID],[loginUsr objectForKey:@"userId"], [loginUsr objectForKey:@"password"], paramsStr];
    /*if (DEBUG) {
        //测试用 wujianping 28:6A:BA:4F:B3:93 123456
        strUrl = [NSString stringWithFormat:@"https://221.7.135.211/semop/invoke/?version=%@&imei=%@&clientType=IPAD&userid=%@&password=%@%@", [context getAppVersion], @"28:6A:BA:4F:B3:93",@"wujianping", @"123456", paramsStr];
    }*/
    NSString *modifiedUrl = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strUrl, nil, nil,kCFStringEncodingUTF8));
    DLog(@"厅请求的服务地址:%@", modifiedUrl);
    
    OperateLogHelper *helper = [[OperateLogHelper alloc] init];
    [helper saveOperate:[params objectForKey:@"service"] andUserID:[loginUsr objectForKey:@"userId"]];
    
    return modifiedUrl;
}

@end
