//
//  CommentLabel.h
//  PicShareClient_iOS
//
//  Created by zoom on 12-4-19.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentLabel : UILabel

@property (nonatomic,copy) NSString *username;
@property (nonatomic,retain) UIButton *usernameButton;
@property (nonatomic,copy) NSString *text;

-(id)initWithFrame:(CGRect)frame username:(NSString *)aUsername text:(NSString *)theText;
-(id)initWithFrame:(CGRect)frame comment:(Comment *)theComment;

@end
