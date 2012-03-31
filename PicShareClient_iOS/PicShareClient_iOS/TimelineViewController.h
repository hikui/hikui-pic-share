//
//  TimelineViewController.h
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-3-28.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"
#import "ASIHTTPRequest.h"

@interface TimelineViewController : PullRefreshTableViewController

@property (nonatomic,retain) NSMutableArray *timeline; //it's full with picture statuses
@property (readwrite) BOOL hasnext;
@property (readwrite) NSInteger currentPage;
@property (nonatomic,retain) NSMutableArray *pictures;
@property (nonatomic,retain) NSMutableArray *progressViews;
@property (nonatomic,retain) NSMutableArray *aliveRequest;

@end
