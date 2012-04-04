//
//  BoardDetailViewController.h
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-3-31.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"


@interface BoardDetailViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) IBOutlet UIButton *avatarButton;
@property (nonatomic,retain) IBOutlet UIButton *followButton;
@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UILabel *boardNameLabel;
@property (nonatomic) NSInteger boardId;
@property (nonatomic,retain) Board *board;

- (IBAction)avatarButtonOnTouch:(id)sender;
- (IBAction)followButtonOnTouch:(id)sender;

@end
