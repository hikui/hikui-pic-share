//
//  BoardsListCell.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-5.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "BoardsListCell.h"
#import <QuartzCore/QuartzCore.h>


#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface BoardsListCell()

- (void)didReceiveTouchEvent:(id)sender;

@end

@implementation BoardsListCell

@synthesize imageCount = _imageCount;
@synthesize boardNameLabel = _boardNameLabel;
@synthesize scrollView = _scrollView;
@synthesize picCountLabel = _picCountLabel;
@synthesize eventDelegate = _eventDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect nameLabelFrame = CGRectMake(16, 6, 170, 20);
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 46, 320, 76)];
        [_scrollView setContentSize:CGSizeMake(84, 76)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _boardNameLabel = [[UILabel alloc]initWithFrame:nameLabelFrame];
        _boardNameLabel.font = [UIFont systemFontOfSize:14];
        _boardNameLabel.textColor = RGBA(80, 80, 80, 1);
        _picCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 24, 100, 15)];
        _picCountLabel.font = [UIFont systemFontOfSize:10];
        _picCountLabel.textColor = RGBA(100, 100, 100, 1);
        _imageCount = 0;
        
        //最多7张图片
        _imageViews = [[NSArray alloc]initWithObjects:
                       [[[PSThumbnailImageView alloc]initWithFrame:CGRectMake(16, 0, 74, 74)]autorelease],
                       [[[PSThumbnailImageView alloc]initWithFrame:CGRectMake(100, 0, 74, 74)]autorelease],
                       [[[PSThumbnailImageView alloc]initWithFrame:CGRectMake(184, 0, 74, 74)]autorelease],
                       [[[PSThumbnailImageView alloc]initWithFrame:CGRectMake(268, 0, 74, 74)]autorelease],
                       [[[PSThumbnailImageView alloc]initWithFrame:CGRectMake(352, 0, 74, 74)]autorelease],
                       [[[PSThumbnailImageView alloc]initWithFrame:CGRectMake(436, 0, 74, 74)]autorelease],
                       [[[PSThumbnailImageView alloc]initWithFrame:CGRectMake(520, 0, 74, 74)]autorelease],
                       [[[PSThumbnailImageView alloc]initWithFrame:CGRectMake(604, 0, 74, 74)]autorelease],
                       nil];
        [self.contentView addSubview:_boardNameLabel];
        [self.contentView addSubview:_picCountLabel];
        [self.contentView addSubview:_scrollView];
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
    PSThumbnailImageView *theThumbnail = [_imageViews objectAtIndex:_imageCount];
    [theThumbnail setImageWithUrl:[NSURL URLWithString:urlStr]];
    [theThumbnail addTarget:self action:@selector(didReceiveTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:theThumbnail];
    CGSize scrollViewContentSize = _scrollView.contentSize;
    scrollViewContentSize.width += 84;
    _scrollView.contentSize = scrollViewContentSize;
    _imageCount++;
}

-(void)clearCurrentPictures
{
    _imageCount = 0;
    _scrollView.contentSize = CGSizeMake(84, 76);
    for (PSThumbnailImageView *aView in _imageViews) {
        [aView clearImage];
        //also clear target-action
        [aView removeTarget:self action:@selector(didReceiveTouchEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (NSInteger) offsetOfaThumbnail:(PSThumbnailImageView *)thumbnailImageView
{
    return [_imageViews indexOfObject:thumbnailImageView];
}

- (void)dealloc
{
    [_boardNameLabel release];
    [_imageViews release];
    [_scrollView release];
    [_eventDelegate release];
    [super dealloc];
}

+ (CGFloat)getBoardsListCellHeight:(Board *)board withSpecifiedOrientation:(UIDeviceOrientation *)orientation
{
    return 128;
}


#pragma mark - delegate methods

/**
 */
- (void)didReceiveTouchEvent:(id)sender
{
    [_eventDelegate didReceiveTouchEvent:sender];
}

@end
