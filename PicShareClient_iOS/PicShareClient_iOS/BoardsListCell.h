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
@property (nonatomic,assign) id<PSThumbnailImageViewEventsDelegate> eventDelegate;
@property (nonatomic,retain) UILabel *boardNameLabel;
@property (nonatomic,retain) UILabel *picCountLabel;
@property (nonatomic,retain) UIScrollView *scrollView;

//当内容为某board时，cell的高度计算，用于heightForCellAtIndexPath排版
+ (CGFloat)getBoardsListCellHeight:(Board *)board withSpecifiedOrientation:(UIDeviceOrientation *)orientation;

- (void) addPictureWithUrlStr:(NSString *)urlStr;
- (void) clearCurrentPictures;
//计算某个图片相对于本board的序号，用于点击事件中判断图片id
- (NSInteger) offsetOfaThumbnail:(PSThumbnailImageView *)thumbnailImageView;
- (void) cancelImageLoading;
- (void) resumeImageLoading;
@end
