//
//  PSThumbnailImageView.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-12.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "_PSThumbnailImageView.h"
#import "UIImageView+AsyncImageContainer.h"
#import <QuartzCore/QuartzCore.h>

@implementation _PSThumbnailImageView

@synthesize innerImageView = _innerImageView;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _innerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        [_innerImageView setUserInteractionEnabled:YES];
//        [_innerImageView.layer setMasksToBounds:YES];
//        [_innerImageView.layer setCornerRadius:5];
//        self.clipsToBounds = NO;
//        self.layer.shadowColor = [UIColor grayColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(1, 1);
//        self.layer.shadowOpacity = 1;
//        self.layer.shadowRadius = 1;
        self.userInteractionEnabled = YES;
        [self addSubview:_innerImageView];
    }
    return self;
}

- (void)dealloc
{
    [_innerImageView release];
    [super dealloc];
}

- (void)setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [_innerImageView setImageWithUrl:url placeholderImage:placeholder];
}

- (void)setImageWithUrl:(NSURL *)url
{
    [_innerImageView setImageWithUrl:url];
}

- (void)clearImage
{
    _innerImageView.image = nil;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    NSLog(@"Touches Ended");
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

@end
