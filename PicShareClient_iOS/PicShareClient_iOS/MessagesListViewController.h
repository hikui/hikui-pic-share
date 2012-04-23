//
//  MessagesListViewController.h
//  PicShareClient_iOS
//
//  Created by zoom on 12-4-23.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface MessagesListViewController : PullRefreshTableViewController

@property (nonatomic,assign) IBOutlet UITableViewCell *commentCell; //reuse comment cell here
@property (nonatomic,retain) NSMutableArray *messages;
@property (nonatomic) BOOL hasNext;
@property (nonatomic) NSInteger currentPage;

@end
