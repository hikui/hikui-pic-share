//
//  CommentLabel.m
//  PicShareClient_iOS
//
//  Created by Hakon Miao on 12-4-19.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "CommentLabel.h"
#import "Common.h"

#define NAME_LABEL_FONTSIZE 14.0F
#define TEXT_FONTSIZE 14.0F

@implementation CommentLabel
@synthesize username,usernameButton,content;

- (void)dealloc {
    [usernameButton release];
    [username release];
    [content release];
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        usernameButton = [[UIButton alloc]init];
        usernameButton.titleLabel.font = [UIFont systemFontOfSize:NAME_LABEL_FONTSIZE];
        usernameButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        usernameButton.opaque = YES;
        usernameButton.backgroundColor = [UIColor whiteColor];
        [self addSubview:usernameButton];
        self.font = [UIFont systemFontOfSize:TEXT_FONTSIZE];
        self.lineBreakMode = UILineBreakModeTailTruncation;
        self.numberOfLines = 0;
        [self setUserInteractionEnabled:YES];
        self.textColor = RGBA(117, 117, 117, 1);
        return self;
    }
    return nil;
}

- (void)setUsername:(NSString *)theUsername
{
    [username release];
    username = [theUsername copy];
    [usernameButton setTitle:username forState:UIControlStateNormal];
    [usernameButton setTitleColor:RGBA(59, 91, 137, 1) forState:UIControlStateNormal];
    [self setNeedsLayout];
}

- (void)setContent:(NSString *)theContent
{
    [content release];
    content = [theContent copy];
    
    NSString *fixedContent = [self.username stringByAppendingFormat:@":%@",content];
    self.text = fixedContent;
    
    CGSize contentSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(self.frame.size.width, 9999) lineBreakMode:UILineBreakModeTailTruncation];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, contentSize.width, contentSize.height);
    [self setNeedsLayout];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize nameButtonSize = [username sizeWithFont:usernameButton.titleLabel.font constrainedToSize:CGSizeMake(self.frame.size.width, 16) lineBreakMode:UILineBreakModeTailTruncation];// 只占据第一行
    usernameButton.frame = CGRectMake(0, 0, nameButtonSize.width, nameButtonSize.height);
}

+ (CGFloat)calculateHeightWithUsername:(NSString *)aUserName content:(NSString *)aContent constrainedToSize:(CGSize)theSize
{
    NSString *fixedContent = [aUserName stringByAppendingFormat:@":%@",aContent];
    CGSize contentSize = [fixedContent sizeWithFont:[UIFont systemFontOfSize:NAME_LABEL_FONTSIZE] constrainedToSize:theSize lineBreakMode:UILineBreakModeTailTruncation];
    return contentSize.height;
}

@end
