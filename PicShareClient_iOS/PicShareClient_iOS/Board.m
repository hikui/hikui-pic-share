//
//  Board.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "Board.h"
#import "User.h"
#import "PictureStatus.h"

@implementation Board

@synthesize name,owner,boardId,categoryId,picturesCount,pictureStatuses,isFollowing;

-(id)initWithJSONDict:(NSDictionary *)data
{
    if (data == nil || (NSNull *)data == [NSNull null]) {
        [self release];
        return nil;
    }
    if ([data objectForKey:@"board_id"]== nil) {
        [self release];
        return nil;
    }
    self = [super init];
    if(self){
        name = [[data objectForKey:@"board_name"]retain];
        owner = [[User alloc]initWithJSONDict:[data objectForKey:@"owner"]];
        boardId = [[data objectForKey:@"board_id"]intValue];
        categoryId = [[data objectForKey:@"category_id"]intValue];
        picturesCount = [[data objectForKey:@"pictures_count"]intValue];
        isFollowing = [[data objectForKey:@"is_following"]boolValue];
        NSArray *psDataArray = [data objectForKey:@"pictures"];
        NSMutableArray *pss = [[NSMutableArray alloc]init];
        for (NSDictionary *aPsData in psDataArray) {
            PictureStatus *ps = [[PictureStatus alloc]initWithJSONDict:aPsData];
            if (ps!=nil) {
                [pss addObject:ps];
            }
            [ps release];
        }
        pictureStatuses = pss;
    }
    return self;
}

- (void)dealloc
{
    [name release];
    [owner release];
    [pictureStatuses release];
    [super dealloc];
}

-(NSString *)description
{
    NSString *str = [[[NSString alloc]initWithFormat:@"Board:%@\nPictures:%@",self.name,self.pictureStatuses]autorelease];
    return str;
}

@end
