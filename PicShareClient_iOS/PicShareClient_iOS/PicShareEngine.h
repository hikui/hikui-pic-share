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
-(Board *)createBoard:(Board *)aBoard;
-(ErrorMessage *)deleteBoard:(NSInteger)boardId;
-(ErrorMessage *)updateBoard:(Board *)aBoard;
-(Board *)getBoard:(NSInteger)boardId;
-(NSArray *)getBoardsOfCategoryId:(NSInteger)categoryId;
-(NSArray *)getBoardsOfCategoryId:(NSInteger)categoryId page:(NSInteger)page;
-(NSArray *)getBoardsOfCategoryId:(NSInteger)categoryId page:(NSInteger)page countPerPage:(NSInteger)count;
-(NSArray *)getBoardsOfUserId:(NSInteger)userId;
-(NSArray *)getBoardsOfUserId:(NSInteger)userId page:(NSInteger)page;
-(NSArray *)getBoardsOfUserId:(NSInteger)userId page:(NSInteger)page countPerPage:(NSInteger)count;

//picture api
-(PictureStatus *)getPictureStatus:(NSInteger)psId;
-(void)uploadPicture:(UIImage *)picture toBoard:(NSInteger)boardId withLatitude:(float)latitude longitude:(float)longitude description:(NSString *)description;
-(PictureStatus *)repin:(NSInteger)ps_id toBoard:(NSInteger)boardId withDescription:(NSString *)theDescription;
-(void)updatePictureStatus:(PictureStatus *)aPictureStatus;
-(ErrorMessage *)deletePictureStatus:(NSInteger)psId;
-(NSArray *)getCommentsOfPictureStatus:(NSInteger)psId;
-(NSArray *)getCommentsOfPictureStatus:(NSInteger)psId page:(NSInteger)page;
-(NSArray *)getCommentsOfPictureStatus:(NSInteger)psId page:(NSInteger)page countPerPage:(NSInteger)count;
-(NSArray *)getCommentsOfPictureStatus:(NSInteger)psId page:(NSInteger)page countPerPage:(NSInteger)count max:(NSInteger)maxId since:(NSInteger)sinceId;
-(ErrorMessage *)reportPictureStatus:(NSInteger)psId;


//user api
-(User *)getUser:(NSInteger)userId;
-(User *)updateUser:(User *)user;
-(User *)regUser:(User *)user;
-(User *)login:(User *)user;

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
-(Comment *)createComment:(NSString *)commentText toPicture:(NSInteger)psId;
-(ErrorMessage *)deleteCommentById:(NSInteger)commentId;

//messages
-(NSArray *)getMessagesToMe;
-(NSArray *)getMessagesToMeWithPage:(NSInteger)page countPerPage:(NSInteger)count since:(NSInteger)sinceId max:(NSInteger)maxId;
-(NSInteger)getUnreadMessagesCount;
-(ErrorMessage *)markMessageRead;

@end
