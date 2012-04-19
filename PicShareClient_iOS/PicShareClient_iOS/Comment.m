//
//  Comment.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "Comment.h"
#import "JSONKit.h"

@implementation Comment
@synthesize by,text,commentId;
- (void)dealloc {
    [by release];
    [text release];
    [super dealloc];
}
-(id)initWithJSONDict:(NSDictionary *)data
{
    if (data == nil || (NSNull *)data == [NSNull null]) {
        [self release];
        return nil;
    }
    if ([data objectForKey:@"comment_id"]== nil) {
        [self release];
        return nil;
    }
    self = [super init];
    if(self){
        by = [[User alloc]initWithJSONDict:[data objectForKey:@"by"]];
        text = [[data objectForKey:@"text"]copy];
        commentId = [[data objectForKey:@"comment_id"]intValue];
    }
    return self;
}

-(NSString *)description
{
    NSString *str = [[[NSString alloc]initWithFormat:@"by:%@\ntext:%@",self.by,self.text]autorelease];
    return str;
}
@end
