//
//  UsersListViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-18.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum UsersListType
{
    followersList,
    followingList
} UsersListType;

@interface UsersListViewController : UITableViewController
{
    UIView *tempView;
    UIView *loadingView;
    UIActivityIndicatorView *loadingIndicator;
    BOOL hasnext;
}

@property (readwrite) UsersListType usersListType;
@property (readwrite) NSInteger userId;
@property (nonatomic,retain) NSMutableArray *usersArray;

- (id)initWithUserId:(NSInteger)aUserId usersListType:(UsersListType)aType tableViewStyle:(UITableViewStyle)style;

@end
