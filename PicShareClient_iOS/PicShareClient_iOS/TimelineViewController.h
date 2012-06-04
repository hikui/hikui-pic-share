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
#import "TimelineCell.h"

@interface TimelineViewController : PullRefreshTableViewController <TimelineCellCommentDelegate>

@property (nonatomic,retain) NSMutableArray *timeline; //!<it's full with picture statuses
@property (readwrite) BOOL hasnext; //!<是否能翻页
@property (readwrite) NSInteger currentPage; //!<当前页数
@property (nonatomic,retain) NSMutableArray *pictures;
@property (nonatomic,retain) NSMutableArray *progressViews; //!<加载时使用的progressView，每个Picture提供一个
@property (nonatomic,retain) NSMutableArray *aliveRequest; //!<保存正在加载的request，如果这个页面被销毁，这些request应该被cancel，并且把delegate置nil。

@end
