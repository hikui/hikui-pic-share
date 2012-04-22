//
//  CommentLabel.h
//  PicShareClient_iOS
//
//  Created by Hakon Miao on 12-4-19.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentLabel : UILabel

@property (nonatomic,copy) NSString *username;
@property (nonatomic,retain) UIButton *usernameButton;
@property (nonatomic,copy) NSString *content;

+ (CGFloat)calculateHeightWithUsername:(NSString *)aUserName content:(NSString *)aContent constrainedToSize:(CGSize)theSize;

@end
