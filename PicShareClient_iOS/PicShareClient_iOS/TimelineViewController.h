//
//  TimelineViewController.h
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-3-28.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

@interface TimelineViewController : PullRefreshTableViewController

@property (nonatomic,retain) NSMutableArray *timeline; //it's full with picture statuses
@property (readwrite) BOOL hasnext;
@property (readwrite) NSInteger currentPage;

@end
