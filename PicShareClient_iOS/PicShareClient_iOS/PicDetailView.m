//
//  PicDetailView.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-15.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "PicDetailView.h"
#import "UIImageView+AsyncImageContainer.h"
#import "UIImageView+Resize.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "UIImageView+Resize.h"
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface PicDetailView()

- (void)downloadMainImage;

@end

@implementation PicDetailView

@synthesize avatarImageView,usernameButton,boardNameButton,picDescriptionLabel,mainImageView,repinButton,commentTextField,pictureStatus,viaButton,progressView;

- (void)dealloc
{
    [avatarImageView release];
    [usernameButton release];
    [boardNameButton release];
    [picDescriptionLabel release];
    [mainImageView release];
    [repinButton release];
    [commentTextField release];
    [viaButton release];
    [progressView release];
    [tempImage release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        avatarImageView = [[UIImageView alloc]init];
        usernameButton = [[UIButton buttonWithType:UIButtonTypeCustom]retain];
        boardNameButton = [[UIButton buttonWithType:UIButtonTypeCustom]retain];
        picDescriptionLabel = [[UILabel alloc]init];
        mainImageView = [[UIImageView alloc]init];
        repinButton = [[UIButton buttonWithType:UIButtonTypeCustom]retain];
        commentTextField = [[UITextField alloc]init];
        viaButton = [[UIButton buttonWithType:UIButtonTypeCustom]retain];
        loadImgComplete = NO;
        progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
        [self addSubview:avatarImageView];
        [self addSubview:usernameButton];
        [self addSubview:boardNameButton];
        [self addSubview:picDescriptionLabel];
        [self addSubview:mainImageView];
        [self addSubview:repinButton];
    }
    return self;
}

- (id)initWithPictureStatus:(PictureStatus *)aPictureStatus
{
    self = [self init];
    if (self) {
        pictureStatus = aPictureStatus;
        [self updateView];
    }
    return self;
}

-(void)updateView
{
    
    if (self.pictureStatus != nil) {
        NSLog(@"updateview");
        avatarImageView.frame = CGRectMake(10, 20, 30, 30);
        [avatarImageView setImageWithUrl:[NSURL URLWithString:pictureStatus.owner.avatarUrl] placeholderImage:[UIImage imageNamed:@"anonymous.png"]];

        
        
        CGSize nameButtonSize = [pictureStatus.owner.username sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(147, 18) lineBreakMode:UILineBreakModeTailTruncation];
        CGRect nameButtonFrame = CGRectMake(48, 32, nameButtonSize.width, nameButtonSize.height);
        usernameButton.frame = nameButtonFrame;
        [usernameButton setTitle:pictureStatus.owner.username forState:UIControlStateNormal];
        [usernameButton setTitleColor:RGBA(66, 66, 66, 1) forState:UIControlStateNormal];
        usernameButton.titleLabel.font = [UIFont systemFontOfSize:14];
        usernameButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [usernameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

        
        CGSize boardNameButtonSize = [pictureStatus.boardName sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(97, 18) lineBreakMode:UILineBreakModeTailTruncation];
        CGRect boardNameButtonFrame = CGRectMake(nameButtonFrame.origin.x+nameButtonSize.width+8, nameButtonFrame.origin.y, boardNameButtonSize.width, boardNameButtonSize.height);
        boardNameButton.frame = boardNameButtonFrame;
        [boardNameButton setTitle:pictureStatus.boardName forState:UIControlStateNormal];
        [boardNameButton setTitleColor:RGBA(130, 131, 146, 1) forState:UIControlStateNormal];
        boardNameButton.titleLabel.font = [UIFont systemFontOfSize:14];
        boardNameButton.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
        [boardNameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];

        
        CGRect viaButtonFrame = CGRectMake(0, 0, 0, 0);
        if (pictureStatus.via !=nil) {
            UILabel *viaLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameButtonFrame.origin.x, nameButtonFrame.origin.y+nameButtonSize.height, 35, 18)];
            viaLabel.text = @"转自";
            [self addSubview:viaLabel];
            
            CGSize viaButtonSize = [pictureStatus.via.username sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320-8-(viaLabel.frame.origin.x+viaLabel.frame.size.width), 18) lineBreakMode:UILineBreakModeTailTruncation];
            viaButtonFrame = CGRectMake(viaLabel.frame.origin.x+viaLabel.frame.size.width+8, 18, viaButtonSize.width, viaButtonSize.height);
            viaButton.frame = viaButtonFrame;
            [viaButton setTitle:pictureStatus.via.username forState:UIControlStateNormal];
            [viaButton setTitleColor:RGBA(93, 145, 166, 1) forState:UIControlStateNormal];
            [viaButton setContentVerticalAlignment:UIControlContentHorizontalAlignmentLeft];

        }
        
        CGSize picDescriptionLabelSize = [pictureStatus.description sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 2000) lineBreakMode:UILineBreakModeWordWrap];
        CGRect picDescriptionLabelFrame = CGRectMake(10, nameButtonFrame.origin.y+nameButtonFrame.size.height+viaButtonFrame.size.height+8, picDescriptionLabelSize.width, picDescriptionLabelSize.height);
        picDescriptionLabel.frame = picDescriptionLabelFrame;
        picDescriptionLabel.text = pictureStatus.description;
        picDescriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
        picDescriptionLabel.font = [UIFont systemFontOfSize:14];

        
        
        CGSize mainImageViewSize = CGSizeMake(300, 260);
        if (loadImgComplete) {
            mainImageViewSize = CGSizeMake(300, [UIImageView heightWithSpecificWidth:300 ofAnImage:tempImage]);
            mainImageView.image = tempImage;
        }
        CGRect mainImageViewFrame = CGRectMake(picDescriptionLabelFrame.origin.x, picDescriptionLabelFrame.origin.y+picDescriptionLabelSize.height+8, mainImageViewSize.width, mainImageViewSize.height);
        mainImageView.frame = mainImageViewFrame;
        progressView.frame = CGRectMake((mainImageViewSize.width-150)/2, (mainImageViewSize.height-11)/2, 150, 11);
        if (!loadImgComplete) {
            [mainImageView addSubview:progressView];
            [self downloadMainImage];
        }
        
        // to be continued
        self.contentSize = CGSizeMake(320, mainImageView.frame.origin.y+mainImageView.frame.size.height);
        
    }
}

-(void)downloadMainImage
{
    request = [[ASIHTTPRequest alloc]initWithURL:[NSURL URLWithString:@"http://pp.a.5d6d.com/userdirs/0/8/mtm/attachments/day_100718/1007181733521bb23ef358cdec.jpg"]];
    [request setDelegate:self];
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    [request setDownloadProgressDelegate:self.progressView];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    tempImage = [[UIImage imageWithData:[aRequest responseData]]retain];
    [self.progressView removeFromSuperview];
    loadImgComplete = YES;
    [self updateView];
}



@end
