//
//  Category.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "Category.h"
#import "JSONKit.h"

@implementation Category

@synthesize boards = _boards;
@synthesize name = _name;
@synthesize categoryId = _categoryId;

-(id)initWithJSONDict:(NSDictionary *)data
{
    if (data == nil || (NSNull *)data == [NSNull null]) {
        [self release];
        return nil;
    }
    self = [super init];
    if (self) {
        self.name = [data objectForKey:@"name"];
        _categoryId = [[data objectForKey:@"category_id"]intValue];
    }
    return self;
}

-(void)dealloc{
    [_name release];
    [_boards release];
    [super dealloc];
}

-(NSString *)description
{
    NSString *str = [[[NSString alloc]initWithFormat:@"<Category id:%d - name:%@>",_categoryId,_name]autorelease];
    return str;
}

@end
