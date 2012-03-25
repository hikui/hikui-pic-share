//
//  PictureInfoEditBoardsListViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-25.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BoardPickerDelegate <NSObject>

- (void)boardDidSelect:(NSInteger)aBoardId;

@end

@interface BoardPickerViewController : UITableViewController

@property (nonatomic,retain) NSArray *boardsArray;
@property (nonatomic,retain) id<BoardPickerDelegate> delegate;

@end
