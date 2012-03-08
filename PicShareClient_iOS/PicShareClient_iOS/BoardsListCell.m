//
//  BoardsListCell.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-5.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "BoardsListCell.h"
#import "UIImageView+AsyncImageContainer.h"
@implementation BoardsListCell

@synthesize imageCount = _imageCount;
@synthesize boardNameLabel = _boardNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect nameLabelFrame = CGRectMake(16, 20, 170, 25);
        _boardNameLabel = [[UILabel alloc]initWithFrame:nameLabelFrame];
        _imageCount = 0;
        
        //最多7张图片
        _imageViews = [[NSArray alloc]initWithObjects:
                       [[[UIImageView alloc]initWithFrame:CGRectMake(16, 57, 60, 60)]autorelease],
                       [[[UIImageView alloc]initWithFrame:CGRectMake(92, 57, 60, 60)]autorelease],
                       [[[UIImageView alloc]initWithFrame:CGRectMake(168, 57, 60, 60)]autorelease],
                       [[[UIImageView alloc]initWithFrame:CGRectMake(244, 57, 60, 60)]autorelease],
                       [[[UIImageView alloc]initWithFrame:CGRectMake(16, 125, 60, 60)]autorelease],
                       [[[UIImageView alloc]initWithFrame:CGRectMake(92, 125, 60, 60)]autorelease],
                       [[[UIImageView alloc]initWithFrame:CGRectMake(168, 125, 60, 60)]autorelease],
                       [[[UIImageView alloc]initWithFrame:CGRectMake(244, 125, 60, 60)]autorelease],
                       nil];
        [self addSubview:_boardNameLabel];
        for (UIImageView *aImageView in _imageViews) {
            [self addSubview:aImageView];
        }        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)addPictureWithUrlStr:(NSString *)urlStr
{
    if (_imageCount>=8) {
        [[_imageViews objectAtIndex:7]setImage:nil];//hide last image in order to show "more"
        return;
    }
    UIImageView *theImageView = [_imageViews objectAtIndex:_imageCount++];
    [theImageView setImageWithUrl:[NSURL URLWithString:urlStr]];
}

-(void)clearCurrentPictures
{
    _imageCount = 0;
    for (UIImageView *aView in _imageViews) {
        aView.image = nil;
    }
}

- (void)dealloc
{
    [_boardNameLabel release];
    [_imageViews release];
    [super dealloc];
}

+ (CGFloat)getBoardsListCellHeight:(Board *)board withSpecifiedOrientation:(UIDeviceOrientation *)orientation
{
    if (board.pictureStatuses.count <=4) {
        return 138;
    }
    else {
        return 206;
    }
}

@end
