//
//  User.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize avatar,userId,location,nickname,username,avatarUrl,isFollowing,introduction,picturesCount,followersCount,followingCount;

-(id)initWithJSONDict:(NSDictionary *)data
{
    if (data == nil || (NSNull *)data == [NSNull null]) {
        [self release];
        return nil;
    }
    self = [super init];
    if(self){
        if ([data objectForKey:@"avatar"]!=[NSNull null]) {
            avatarUrl = [[data objectForKey:@"avatar"]copy];
        }
        userId = [[data objectForKey:@"user_id"]intValue];
        if ([data objectForKey:@"location"]!=[NSNull null]) {
            location = [[data objectForKey:@"location"]copy];
        }else {
            location = @"未知";
        }
        nickname = [[data objectForKey:@"nick"]copy];
        username = [[data objectForKey:@"username"]copy];
        isFollowing = [[data objectForKey:@"is_following"]boolValue];
        introduction = [[data objectForKey:@"introduction"]copy];
        followersCount = [[data objectForKey:@"followers_count"]intValue];
        followingCount = [[data objectForKey:@"following_count"]intValue];
        picturesCount = [[data objectForKey:@"pictures_count"]intValue];
    }
    return self;
}

- (void)dealloc
{
    [avatar release];
    [avatarUrl release];
    [username release];
    [introduction release];
    [nickname release];
    [location release];
    [super dealloc];
}

@end
