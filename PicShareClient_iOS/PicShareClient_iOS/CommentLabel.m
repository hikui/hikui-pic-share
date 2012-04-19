//
//  CommentLabel.m
//  PicShareClient_iOS
//
//  Created by zoom on 12-4-19.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "CommentLabel.h"


@implementation CommentLabel
@synthesize username,text,usernameButton;

- (void)dealloc {
    [usernameButton release];
    [username release];
    [text release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame username:(NSString *)aUsername text:(NSString *)theText
{
    self = [super initWithFrame:frame];
    if (self) {
        username = [aUsername copy];
        text = [theText copy];
        usernameButton = [[UIButton alloc]init];
        
        return  self;
    }
    return nil;
}

-(void)layoutIfNeeded
{
    [super layoutIfNeeded];
}

@end
