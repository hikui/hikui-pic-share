//
//  BoardsListCell.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-5.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"

@interface BoardsListCell : UITableViewCell

@property (nonatomic,retain) UILabel *boardNameLabel;
@property (nonatomic,assign) NSMutableArray *boardPictures;
@property (nonatomic,retain) UILabel *moreLabel;

+(CGFloat)getBoardsListCellHeight:(Board *)board withSpecifiedOrientation:(UIDeviceOrientation *)orientation;
-(void)updateFrame;
@end
