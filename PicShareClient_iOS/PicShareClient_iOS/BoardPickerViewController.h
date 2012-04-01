//
//  PictureInfoEditBoardsListViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-25.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicShareEngine.h"
#import "PullRefreshTableViewController.h"

@protocol BoardPickerDelegate <NSObject>

- (void)boardDidSelect:(Board *)aBoard;

@end

@interface BoardPickerViewController : PullRefreshTableViewController

@property (nonatomic,retain) NSArray *boardsArray;
@property (nonatomic,assign) id<BoardPickerDelegate> delegate;
@property (nonatomic,retain) PicShareEngine *engine;
@property (nonatomic,retain) NSIndexPath *indexSelected;

@end
