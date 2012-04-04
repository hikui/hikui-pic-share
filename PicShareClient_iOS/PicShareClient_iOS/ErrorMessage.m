//
//  ErrorMessage.m
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-4-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "ErrorMessage.h"

@implementation ErrorMessage
@synthesize ret,errorMsg,errorcode;
- (void)dealloc
{
    [errorMsg release];
    [super dealloc];
}

-(id)initWithJSONDict:(NSDictionary *)data
{
    if (data == nil || (NSNull *)data == [NSNull null]) {
        [self release];
        return nil;
    }
    self = [super init];
    if (self) {
        errorMsg = [[data objectForKey:@"msg"]copy];
        ret = [[data objectForKey:@"ret"]integerValue];
        errorcode = [[data objectForKey:@"errorcode"]integerValue];
    }
    return self;
}


-(NSString *)description
{
    NSString *str = [[[NSString alloc]initWithFormat:@"ErrorMessage:\nret:%d,errorcode:%d\nerrormsg:%@",ret,errorcode,errorMsg]autorelease];
    return str;
}

@end
