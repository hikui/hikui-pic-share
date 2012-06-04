//
//  BoardsListViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-5.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicShareEngine.h"
#import "PullRefreshTableViewController.h"
#import "PSThumbnailImageView.h"

typedef enum TheType{
    categoryDetail,
    userBoards
} TheType;

/**
 本类用于浏览用户的所有Boards或者用于浏览某Category的所有boards
 */
@interface BoardsListViewController : PullRefreshTableViewController
    <PSThumbnailImageViewEventsDelegate>
{
    PicShareEngine *_engine;
    NSOperationQueue *_oprationq;
    UIActivityIndicatorView *_indicator;
    int _currPage;
    BOOL _hasNext;
    BOOL isLoadingData;
}

@property (nonatomic,retain)NSMutableArray *boards;
@property (readwrite) TheType type;
@property (readwrite) NSInteger contentId;

/**
 @param[in] TheType 可能的type，@see TheType
 @param[in] andId 可能是category id 或者是 user id，取决于type
 */
- (id)initWithType:(TheType) aType AndId:(NSInteger)anId;

@end
