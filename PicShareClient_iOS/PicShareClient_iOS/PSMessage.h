//
//  PSMessage.h
//  PicShareClient_iOS
//
//  Created by zoom on 12-4-23.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

typedef enum {
    FollowingMessage = 1,
    CommentMessage = 2,
    MentionMessage = 3
} PSMessageType;

@interface PSMessage : NSObject

@property (nonatomic) NSInteger psmsgId;
@property (nonatomic,retain) User *by;
@property (nonatomic,retain) NSString *text;
@property (nonatomic,retain) NSString *extra;
@property (nonatomic) PSMessageType type;
@property (nonatomic) BOOL isRead;

-(id)initWithJSONDict:(NSDictionary *)data;

@end
