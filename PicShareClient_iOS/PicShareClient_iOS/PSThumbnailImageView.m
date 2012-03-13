//
//  PSThumbnailImageView.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-12.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "PSThumbnailImageView.h"
#import "UIImageView+AsyncImageContainer.h"
#import <QuartzCore/QuartzCore.h>

@implementation PSThumbnailImageView

@synthesize delegate = _delegate;
@synthesize innerImageView = _innerImageView;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        _innerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_innerImageView setUserInteractionEnabled:YES];
        [_innerImageView.layer setMasksToBounds:YES];
        [_innerImageView.layer setCornerRadius:5];
        self.clipsToBounds = NO;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 1);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 1;
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch begin");
    NSLog(@"taps%d",[[touches anyObject]tapCount]);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch end");
}

@end
