//
//  PicDetailView.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-15.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "PicDetailView.h"

#import "UIImageView+Resize.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "UIImageView+Resize.h"
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface PicDetailView()

- (void)downloadMainImage;

@end

@implementation PicDetailView

@synthesize avatarImageView,usernameButton,boardNameButton,picDescriptionLabel,mainImageView,repinButton,commentTextField,pictureStatus,viaButton,progressView,request;

static bool isRetina()
{
    return [[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
    ([UIScreen mainScreen].scale == 2.0);
}

- (void)dealloc
{
    [request clearDelegatesAndCancel];
    [request release];
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
        repinButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
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
        [self layout];
    }
    return self;
}

- (id)initWithPictureStatus:(PictureStatus *)aPictureStatus
{
    self = [super init];
    if (self) {
        avatarImageView = [[UIImageView alloc]init];
        usernameButton = [[UIButton buttonWithType:UIButtonTypeCustom]retain];
        boardNameButton = [[UIButton buttonWithType:UIButtonTypeCustom]retain];
        picDescriptionLabel = [[UILabel alloc]init];
        mainImageView = [[UIImageView alloc]init];
        repinButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
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
        pictureStatus = aPictureStatus;
        [self layout];
    }
    return self;
}

-(void)layout
{
    
    if (self.pictureStatus != nil) {
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
            UILabel *viaLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameButtonFrame.origin.x, nameButtonFrame.origin.y+nameButtonSize.height+4, 35, 18)];
            viaLabel.text = @"转自";
            [self addSubview:viaLabel];
            [viaLabel release];
            
            CGSize viaButtonSize = [pictureStatus.via.username sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320-8-(viaLabel.frame.origin.x+viaLabel.frame.size.width), 18) lineBreakMode:UILineBreakModeTailTruncation];
            viaButtonFrame = CGRectMake(viaLabel.frame.origin.x+viaLabel.frame.size.width+8, viaLabel.frame.origin.y, viaButtonSize.width, viaButtonSize.height);
            viaButton.frame = viaButtonFrame;
            [viaButton setTitle:pictureStatus.via.username forState:UIControlStateNormal];
            [viaButton setTitleColor:RGBA(93, 145, 166, 1) forState:UIControlStateNormal];
            [viaButton setContentVerticalAlignment:UIControlContentHorizontalAlignmentLeft];

        }
        
               
        CGSize mainImageViewSize = CGSizeMake(300, 260);
        if (loadImgComplete) {
            mainImageViewSize = CGSizeMake(300, [UIImageView heightWithSpecificWidth:300 ofAnImage:tempImage]);
            mainImageView.image = tempImage;
        }
        CGRect mainImageViewFrame = CGRectMake(avatarImageView.frame.origin.x, avatarImageView.frame.origin.y+avatarImageView.frame.size.height+viaButtonFrame.size.height+8, mainImageViewSize.width, mainImageViewSize.height);
        mainImageView.frame = mainImageViewFrame;
        progressView.frame = CGRectMake((mainImageViewSize.width-150)/2, (mainImageViewSize.height-11)/2, 150, 11);
        if (!loadImgComplete) {
            [mainImageView addSubview:progressView];
            [self downloadMainImage];
        }
        
        
        CGSize picDescriptionLabelSize = [pictureStatus.picDescription sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(300, 2000) lineBreakMode:UILineBreakModeWordWrap];
        CGRect picDescriptionLabelFrame = CGRectMake(avatarImageView.frame.origin.x, mainImageViewFrame.origin.y+mainImageViewFrame.size.height+8, picDescriptionLabelSize.width, picDescriptionLabelSize.height);
        picDescriptionLabel.frame = picDescriptionLabelFrame;
        picDescriptionLabel.text = pictureStatus.picDescription;
        picDescriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
        picDescriptionLabel.numberOfLines = 0;
        picDescriptionLabel.font = [UIFont systemFontOfSize:14];
        
        

        
        CGRect repinButtonFrame = CGRectMake(picDescriptionLabelFrame.origin.x, picDescriptionLabelFrame.origin.y+picDescriptionLabelFrame.size.height+8, 80, 30);
        repinButton.frame = repinButtonFrame;
        [repinButton setTitle:@"转发" forState:UIControlStateNormal];
        repinButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        // to be continued
#warning comments
        self.contentSize = CGSizeMake(320, repinButton.frame.origin.y+repinButton.frame.size.height+10);
        
    }
}

-(void)downloadMainImage
{
    NSString *urlStr;
    if (isRetina()) {
        urlStr = [pictureStatus.pictureUrl stringByAppendingString:@"?size=640"];
    }else {
        urlStr = [pictureStatus.pictureUrl stringByAppendingString:@"?size=320"];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    self.request = [ASIHTTPRequest requestWithURL:url];
    [self.request setDelegate:self];
    [self.request setNumberOfTimesToRetryOnTimeout:1];
    [self.request setTimeOutSeconds:10]; // 10 seconds
    [self.request setDownloadCache:[ASIDownloadCache sharedCache]];
    [self.request setCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    [self.request setDownloadProgressDelegate:self.progressView];
    [self.request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)aRequest
{
    [tempImage release];
    tempImage = [[UIImage imageWithData:[aRequest responseData]]retain];
    [self.progressView removeFromSuperview];
    loadImgComplete = YES;
    [self layout];
}



@end
