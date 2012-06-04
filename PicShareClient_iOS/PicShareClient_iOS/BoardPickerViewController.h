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

typedef void (^BoardIsSelectedBlock)(Board *b);

@protocol BoardPickerDelegate <NSObject>

- (void)boardDidSelect:(Board *)aBoard;

@end

/**
 在PictureInfoEdit中使用，用于选择Picture所属的Board。
 */
@interface BoardPickerViewController : PullRefreshTableViewController
{
    BoardIsSelectedBlock isSelectedBlock;
}

@property (nonatomic,retain) NSArray *boardsArray;
@property (nonatomic,assign) id<BoardPickerDelegate> delegate;
@property (nonatomic,retain) PicShareEngine *engine;
@property (nonatomic,retain) NSIndexPath *indexSelected;

/**just ignore it. it's useless.*/
- (void)setBoardIsSelectedBlock:(BoardIsSelectedBlock)_isSelectedBlock;

@end
