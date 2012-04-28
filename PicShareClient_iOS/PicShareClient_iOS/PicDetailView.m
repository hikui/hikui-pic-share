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
#import "UIImageView+WebCache.h"
#import "Common.h"
#import "CommentLabel.h"
#import "PicShareEngine.h"
@interface PicDetailView()

- (void)downloadMainImage;

@end

@implementation PicDetailView

@synthesize avatarImageView,usernameButton,boardNameButton,picDescriptionLabel,mainImageView,repinButton,commentTextField,pictureStatus,viaButton,progressView,request,viaLabel,showAllCommentsButton,moreButton;

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
    [viaLabel release];
    [showAllCommentsButton release];
    [moreButton release];
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
        viaLabel = [[UILabel alloc]init];
        loadImgComplete = NO;
        loadCommentsComplete = NO;
        progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
        showAllCommentsButton = [[UIButton alloc]init];
        moreButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
        [self addSubview:avatarImageView];
        [self addSubview:usernameButton];
        [self addSubview:boardNameButton];
        [self addSubview:picDescriptionLabel];
        [self addSubview:mainImageView];
        [self addSubview:repinButton];
        [self addSubview:viaButton];
        [self addSubview:viaLabel];
        [self addSubview:showAllCommentsButton];
        [self addSubview:moreButton];
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
        loadCommentsComplete = NO;
        viaLabel = [[UILabel alloc]init];
        progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleBar];
        showAllCommentsButton = [[UIButton alloc]init];
        moreButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
        [self addSubview:avatarImageView];
        [self addSubview:usernameButton];
        [self addSubview:boardNameButton];
        [self addSubview:picDescriptionLabel];
        [self addSubview:mainImageView];
        [self addSubview:repinButton];
        [self addSubview:viaLabel];
        [self addSubview:viaButton];
        [self addSubview:showAllCommentsButton];
        [self addSubview:moreButton];
        pictureStatus = aPictureStatus;
        [self layout];
    }
    return self;
}

-(void)layout
{
    
    if (self.pictureStatus != nil) {
        avatarImageView.frame = CGRectMake(10, 20, 30, 30);
        NSString *avatarUrl;
        if (IS_RETINA) {
            avatarUrl = [pictureStatus.owner.avatarUrl stringByAppendingString:@"?size=120"];
        }else {
            avatarUrl = [pictureStatus.owner.avatarUrl stringByAppendingString:@"?size=60"];
        }
        [avatarImageView setImageWithURL:[NSURL URLWithString:avatarUrl] placeholderImage:[UIImage imageNamed:@"anonymous.png"]];

        
        
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
            self.viaLabel.frame = CGRectMake(nameButtonFrame.origin.x, nameButtonFrame.origin.y+nameButtonSize.height+4, 35, 18);
            viaLabel.font = [UIFont systemFontOfSize:14];
            viaLabel.text = @"转自";
            [viaLabel setHidden:NO];
            
            CGSize viaButtonSize = [pictureStatus.via.username sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(320-8-(viaLabel.frame.origin.x+viaLabel.frame.size.width), 18) lineBreakMode:UILineBreakModeTailTruncation];
            viaButtonFrame = CGRectMake(viaLabel.frame.origin.x+viaLabel.frame.size.width+8, viaLabel.frame.origin.y, viaButtonSize.width, viaButtonSize.height);
            viaButton.frame = viaButtonFrame;
            NSLog(@"viabutton title :%@",pictureStatus.via.username);
            [viaButton setTitle:pictureStatus.via.username forState:UIControlStateNormal];
            [viaButton setTitleColor:RGBA(93, 145, 166, 1) forState:UIControlStateNormal];
            viaButton.titleLabel.font = [UIFont systemFontOfSize:14];
            [viaButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [viaButton setHidden:NO];
            
        }else {
            [viaButton setHidden:YES];
            [viaLabel setHidden:YES];
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
        
        CGRect moreButtonFrame = CGRectMake(262, repinButtonFrame.origin.y, 47, 30);
        self.moreButton.frame = moreButtonFrame;
        [moreButton setTitle:@"..." forState:UIControlStateNormal];
        
        CGFloat currentY = repinButton.frame.origin.y + repinButton.frame.size.height+8;
        if (loadImgComplete) {
            for (Comment *aComment in self.pictureStatus.sampleComments) {
                NSString *username = aComment.by.username;
                NSString *content = aComment.text;
                CommentLabel *cLabel = [[CommentLabel alloc]initWithFrame:CGRectMake(16, currentY, 320-16-repinButton.frame.origin.x, 0)];
                cLabel.username = username;
                cLabel.content = content;
                //int userId = aComment.by.userId;
                cLabel.usernameButton.tag = aComment.by.userId;
                [cLabel.usernameButton addTarget:self action:@selector(commentUsernameButtonOnTouch:) forControlEvents:UIControlEventTouchUpInside];
                currentY +=(cLabel.frame.size.height);
                [self addSubview:cLabel];
                [cLabel release];
            }
            NSLog(@"commentsCount:%d",pictureStatus.commentsCount);
            if (pictureStatus.sampleComments.count<pictureStatus.commentsCount) {
                [self.showAllCommentsButton setHidden:NO];
                self.showAllCommentsButton.frame = CGRectMake(16, currentY, 288, 20);
                showAllCommentsButton.titleLabel.font = [UIFont systemFontOfSize:12];
                [showAllCommentsButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                
                [showAllCommentsButton setTitle:@"显示全部评论" forState:UIControlStateNormal];
                [showAllCommentsButton setTitleColor:RGBA(174, 174, 174, 1) forState:UIControlStateNormal];
                currentY += 14;
            }else {
                [self.showAllCommentsButton setHidden:YES];
            }
        }
        self.contentSize = CGSizeMake(320, currentY+10);
        
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
