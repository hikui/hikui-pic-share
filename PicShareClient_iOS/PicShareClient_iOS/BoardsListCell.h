//
//  BoardsListCell.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-5.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"
#import "PSThumbnailImageView.h"




/**
 Cell中的元素有最多7个的image、namelabel，另外还应该有follow/unfo的按钮
 和“更多”按钮。这些属于controller，故在controller中实现。
 这里的imageview使用的是AsyncImageContainer category。
 */
@interface BoardsListCell : UITableViewCell
{
    NSArray *_imageViews;
    NSMutableArray *_frames;
}

@property (readonly) int imageCount;
@property (nonatomic,retain) id<PSThumbnailImageViewEventsDelegate> eventDelegate;
@property (nonatomic,retain) UILabel *boardNameLabel;
@property (nonatomic,retain) UILabel *picCountLabel;
@property (nonatomic,retain) UIScrollView *scrollView;

+ (CGFloat)getBoardsListCellHeight:(Board *)board withSpecifiedOrientation:(UIDeviceOrientation *)orientation;

- (void) addPictureWithUrlStr:(NSString *)urlStr;
- (void) clearCurrentPictures;
- (NSInteger) offsetOfaThumbnail:(PSThumbnailImageView *)thumbnailImageView;
- (void) cancelImageLoading;
- (void) resumeImageLoading;
@end
