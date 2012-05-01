//
//  CommentsListViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-4-22.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureStatus.h"

@interface CommentsListViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,retain) IBOutlet UITableView *tableView;
@property (nonatomic,retain) IBOutlet UITextField *commentTF;

@property (nonatomic,assign) IBOutlet UITableViewCell *commentCell;

@property (nonatomic,retain) NSMutableArray *comments;
@property (nonatomic) NSInteger psId;
@property (nonatomic,retain) PictureStatus *ps;

@property (nonatomic) BOOL hasNext;
@property (nonatomic) NSInteger currentPage;

@property (nonatomic) NSInteger flagId;
@property (nonatomic) CGFloat tfBarOriginY;
- (id)initWithPsId:(NSInteger)thePsId;

@end
