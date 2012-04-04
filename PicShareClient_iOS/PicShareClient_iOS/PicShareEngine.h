//
//  PicShareEngine.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "PictureStatus.h"
#import "Board.h"
#import "Category.h"
#import "Comment.h"
#import "ErrorMessage.h"


@interface PicShareEngine : NSObject

@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *password;
@property (readwrite) NSInteger userId;
@property (nonatomic,retain) NSOperationQueue *uploadQ;

+(id)sharedEngine;
-(void)setUsername:(NSString *)username andPassword:(NSString *)password;

//category api
-(NSArray *)getAllCategories;

//board api
-(void)createBoard:(Board *)aBoard;
-(void)deleteBoard:(NSInteger)boardId;
-(void)updateBoard:(Board *)aBoard;
-(Board *)getBoard:(NSInteger)boardId;
-(NSArray *)getBoardsOfCategoryId:(NSInteger)categoryId;
-(NSArray *)getBoardsOfCategoryId:(NSInteger)categoryId page:(NSInteger)page;
-(NSArray *)getBoardsOfCategoryId:(NSInteger)categoryId page:(NSInteger)page countPerPage:(NSInteger)count;

//picture api
-(PictureStatus *)getPictureStatus:(NSInteger)psId;
-(void)uploadPicture:(UIImage *)picture toBoard:(NSInteger)boardId withLatitude:(float)latitude longitude:(float)longitude description:(NSString *)description;
-(void)repin:(NSInteger)ps_id toBoard:(NSInteger)boardId;
-(void)updatePictureStatus:(PictureStatus *)aPictureStatus;
-(void)releasePictureStatus:(NSInteger)psId;
-(NSArray *)getCommentsOfPictureStatus:(NSInteger)psId;
-(NSArray *)getUserPictures:(NSInteger)userId count:(NSInteger)maxPictureCount;

//user api
-(User *)getUser:(NSInteger)userId;
-(ErrorMessage *)updateUser:(User *)user;
-(ErrorMessage *)uploadAvatar:(UIImage *)avatar;
-(ErrorMessage *)regUser:(User *)user;

//relationship api
-(ErrorMessage *)followBoard:(NSInteger)boardId;
-(ErrorMessage *)followUser:(NSInteger)userId;
-(ErrorMessage *)unFollowBoard:(NSInteger)boardId;
-(ErrorMessage *)unFollowUser:(NSInteger)userId;
-(NSArray *)getFollowers:(NSInteger)userId;
-(NSArray *)getFollowers:(NSInteger)userId page:(NSInteger)page;
-(NSArray *)getFollowers:(NSInteger)userId page:(NSInteger)page countPerPage:(NSInteger)count;
-(NSArray *)getFollowing:(NSInteger)userId;
-(NSArray *)getFollowing:(NSInteger)userId page:(NSInteger)page;
-(NSArray *)getFollowing:(NSInteger)userId page:(NSInteger)page countPerPage:(NSInteger)count;

//timeline api
-(NSArray *)getHomeTimeline;
-(NSArray *)getHomeTimelineOfPage:(NSInteger)page since:(NSInteger)since_id max:(NSInteger)max_id;
-(NSArray *)getHomeTimelineOfPage:(NSInteger)page countPerPage:(NSInteger)count since:(NSInteger)since_id max:(NSInteger)max_id;


//comment api


@end
