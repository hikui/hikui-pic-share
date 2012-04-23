//
//  PSMessage.m
//  PicShareClient_iOS
//
//  Created by Hakon Miao on 12-4-23.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "PSMessage.h"

@implementation PSMessage
@synthesize by,text,type,extra,psmsgId,isRead;

- (void)dealloc {
    [by release];
    [text release];
    [extra release];
    [super dealloc];
}

-(id)initWithJSONDict:(NSDictionary *)data
{
    if (data == nil || (NSNull *)data == [NSNull null]) {
        [self release];
        return nil;
    }
    if ([data objectForKey:@"psmsg_id"]== nil) {
        [self release];
        return nil;
    }
    self = [super init];
    if (self) {
        psmsgId = [[data objectForKey:@"psmsg_id"]intValue];
        type = [[data objectForKey:@"type"]intValue];
        extra = [[data objectForKey:@"extra"]copy];
        text = [[data objectForKey:@"text"]copy];
        int iisRead = [[data objectForKey:@"mark_read"]intValue];
        if (iisRead==0) {
            isRead = NO; 
        }else{
            isRead = YES;
        }
        by = [[User alloc]initWithJSONDict:[data objectForKey:@"by"]];
    }
    return self;
}

-(NSString *)description
{
    NSString *str = [[[NSString alloc]initWithFormat:@"%@",self.text]autorelease];
    return str;
}

@end
