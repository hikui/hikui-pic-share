//
//  PicShareEngine.m
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "PicShareEngine.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "PSMessage.h"

#define UPLOAD_IMAGE 0

NSString *picshareDomain = @"http://192.168.31.3:8000/";

@interface PicShareEngine ()

- (void)addAuthHeaderForRequest:(ASIHTTPRequest *) request;
- (void)uploadImageDidFinish:(ASIFormDataRequest *)request;
- (void)uploadImageError:(ASIFormDataRequest *)request;

@end


@implementation PicShareEngine

@synthesize password = _password;
@synthesize username = _username;
@synthesize uploadQ = _uploadQ;
@synthesize userId = _userId;

static PicShareEngine *instance = NULL;


-(void)dealloc{
    [_password release];
    [_username release];
    [_uploadQ release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _uploadQ = [[NSOperationQueue alloc]init];
        _uploadQ.maxConcurrentOperationCount = 2;
    }
    return self;
}

+(id)sharedEngine{
    @synchronized(self)
    {
        if (instance == NULL) {
            instance = [[PicShareEngine alloc]init];
            instance.username = @"user1";
            instance.password = @"user1";
            instance.userId = 1;
        }
        return instance;
    }
}

- (void)addAuthHeaderForRequest:(ASIHTTPRequest *) request
{
    if (self.username != nil && self.password !=nil) {
        [request addBasicAuthenticationHeaderWithUsername:self.username andPassword:self.password];
    }
    [request setTimeOutSeconds:60];
}

-(NSArray *)getAllCategories
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingFormat:@"api/category/get_all.json"]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        NSLog(@"error! %d",request.responseStatusCode);
        //do something in ui
        //use notification center???
#warning not implement yet
        return nil;
    }
    if (response != nil) {
        NSDictionary *dictFromJson = [response objectFromJSONString]; 
        NSArray *categoryDataArray = [dictFromJson objectForKey:@"categories"];
        NSMutableArray *resultArray = [[[NSMutableArray alloc]init]autorelease];
        for(NSDictionary *aCategoryData in categoryDataArray){
            Category *c = [[Category alloc]initWithJSONDict:aCategoryData];
            if (c != nil) {
                [resultArray addObject:c];
            }
            [c release];
        }
        return resultArray;
    }
    return nil;
}

-(NSArray *)getBoardsOfCategoryId:(NSInteger)categoryId
{
    return [self getBoardsOfCategoryId:categoryId page:1];
}

-(NSArray *)getBoardsOfCategoryId:(NSInteger)categoryId page:(NSInteger)page
{
    return [self getBoardsOfCategoryId:categoryId page:page countPerPage:5];
}

/**
 返回第一个元素为hasnext
 */
-(NSArray *)getBoardsOfCategoryId:(NSInteger)categoryId page:(NSInteger)page countPerPage:(NSInteger)count
{
    
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingFormat:@"api/board/get_category_boards.json?page=%d&count=%d&category_id=%d",page,count,categoryId]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error && [request responseStatusCode]==200) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dictFromJson = [response objectFromJSONString];
        NSNumber *hasnext = [dictFromJson objectForKey:@"hasnext"];
        NSArray *boardsDataArray = [dictFromJson objectForKey:@"boards"];
        NSMutableArray *resultArray = [[[NSMutableArray alloc]init]autorelease];
        [resultArray addObject:hasnext];
        for (NSDictionary *aBoardData in boardsDataArray) {
            Board *b = [[Board alloc]initWithJSONDict:aBoardData];
            if (b != nil) {
                [resultArray addObject:b];
            }
            [b release];
        }
        return resultArray;
    }
    return nil;
}

-(NSArray *)getBoardsOfUserId:(NSInteger)userId
{
    return [self getBoardsOfUserId:userId page:1];
}

-(NSArray *)getBoardsOfUserId:(NSInteger)userId page:(NSInteger)page
{
    return [self getBoardsOfUserId:userId page:page countPerPage:5];
}

/**
 返回第一个元素为hasnext
 */
-(NSArray *)getBoardsOfUserId:(NSInteger)userId page:(NSInteger)page countPerPage:(NSInteger)count
{
    
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingFormat:@"api/board/get_user_boards.json?page=%d&count=%d&user_id=%d",page,count,userId]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error && [request responseStatusCode]==200) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dictFromJson = [response objectFromJSONString];
        NSNumber *hasnext = [dictFromJson objectForKey:@"hasnext"];
        NSArray *boardsDataArray = [dictFromJson objectForKey:@"boards"];
        NSMutableArray *resultArray = [[[NSMutableArray alloc]init]autorelease];
        [resultArray addObject:hasnext];
        for (NSDictionary *aBoardData in boardsDataArray) {
            Board *b = [[Board alloc]initWithJSONDict:aBoardData];
            if (b != nil) {
                [resultArray addObject:b];
            }
            [b release];
        }
        return resultArray;
    }
    return nil;
}

-(PictureStatus *)getPictureStatus:(NSInteger)psId
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingFormat:@"api/picture/get.json?ps_id=%d",psId]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error && [request responseStatusCode]==200) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dictFromJson = [response objectFromJSONString];
        PictureStatus *pictureStatus = [[[PictureStatus alloc]initWithJSONDict:dictFromJson]autorelease];
        return pictureStatus;
    }
    return nil;
}

-(NSArray *)getFollowers:(NSInteger)userId
{
    return [self getFollowers:userId page:1];
}
-(NSArray *)getFollowers:(NSInteger)userId page:(NSInteger)page
{
    return [self getFollowers:userId page:page countPerPage:20];
}
-(NSArray *)getFollowers:(NSInteger)userId page:(NSInteger)page countPerPage:(NSInteger)count
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingFormat:@"api/relationship/followers.json?user_id=%d&page=%d&count=%d",userId,page,count]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error && [request responseStatusCode]==200) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dictFromJson = [response objectFromJSONString];
        NSNumber *hasnext = [dictFromJson objectForKey:@"hasnext"];
        NSArray *usersDataArray = [dictFromJson objectForKey:@"followers"];
        NSMutableArray *resultArray = [[[NSMutableArray alloc]init]autorelease];
        [resultArray addObject:hasnext];
        for (NSDictionary *aUserData in usersDataArray) {
            User *u = [[User alloc]initWithJSONDict:aUserData];
            if (u!= nil) {
                [resultArray addObject:u];
            }
            [u release];
        }
        return resultArray;
    }
    return nil;
}

-(NSArray *)getFollowing:(NSInteger)userId
{
    return [self getFollowing:userId page:1];
}
-(NSArray *)getFollowing:(NSInteger)userId page:(NSInteger)page
{
    return [self getFollowing:userId page:page countPerPage:20];
}
-(NSArray *)getFollowing:(NSInteger)userId page:(NSInteger)page countPerPage:(NSInteger)count
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingFormat:@"api/relationship/following.json?user_id=%d&page=%d&count=%d",userId,page,count]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error && [request responseStatusCode]==200) {
        response = [request responseString];
    }
    else {
        return nil;
    }
    if (response != nil) {
        NSDictionary *dictFromJson = [response objectFromJSONString];
        NSNumber *hasnext = [dictFromJson objectForKey:@"hasnext"];
        NSArray *usersDataArray = [dictFromJson objectForKey:@"following"];
        NSMutableArray *resultArray = [[[NSMutableArray alloc]init]autorelease];
        [resultArray addObject:hasnext];
        for (NSDictionary *aUserData in usersDataArray) {
            User *u = [[User alloc]initWithJSONDict:aUserData];
            if (u!= nil) {
                [resultArray addObject:u];
            }
            [u release];
        }
        return resultArray;
    }
    return nil;
}

-(User *)getUser:(NSInteger)userId
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingFormat:@"api/user/detail.json?user_id=%d",userId]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error && [request responseStatusCode]==200) {
        response = [request responseString];
    }
    else {
        NSLog(@"error:%@",error);
        return nil;
    }
    if (response != nil) {
        NSDictionary *dictFromJson = [response objectFromJSONString];
        NSLog(@"get user:%@",dictFromJson);
        User *user = [[[User alloc]initWithJSONDict:dictFromJson]autorelease];
        return user;
    }
    return nil;
}

-(void)uploadPicture:(UIImage *)picture toBoard:(NSInteger)boardId withLatitude:(float)latitude longitude:(float)longitude description:(NSString *)description
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingFormat:@"api/picture/upload.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    NSData *picData = UIImagePNGRepresentation(picture);
    [request setData:picData withFileName:@"upload.png" andContentType:@"image/png" forKey:@"pic"];
    [request setPostValue:[NSNumber numberWithInteger:boardId] forKey:@"board_id"];
    if (latitude!=-1.0f && longitude != -1.0f) {
        [request setPostValue:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
        [request setPostValue:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];
    }
    [request setPostValue:description forKey:@"description"];
    [request setTag:UPLOAD_IMAGE];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(uploadImageError:)];
    [request setDidFinishSelector:@selector(uploadImageDidFinish:)];
    [self.uploadQ addOperation:request];
}

-(void)uploadImageDidFinish:(ASIFormDataRequest *)request
{
    UIAlertView *successView = [[UIAlertView alloc]initWithTitle:@"" message:@"上传成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [successView show];
    [successView release];
}

-(void)uploadImageError:(ASIFormDataRequest *)request
{
    UIAlertView *successView = [[UIAlertView alloc]initWithTitle:@"" message:@"上传失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [successView show];
    [successView release];
}

-(NSArray *)getHomeTimeline
{
    return [self getHomeTimelineOfPage:1 since:-1 max:-1];
}

-(NSArray *)getHomeTimelineOfPage:(NSInteger)page since:(NSInteger)since_id max:(NSInteger)max_id
{
    return [self getHomeTimelineOfPage:page countPerPage:20 since:since_id max:max_id];
}

-(NSArray *)getHomeTimelineOfPage:(NSInteger)page countPerPage:(NSInteger)count since:(NSInteger)since_id max:(NSInteger)max_id
{
    NSMutableString *urlStr = [[NSMutableString alloc]initWithFormat:@"api/timeline/home_timeline.json?page=%d&count=%d",page,count];
    if (since_id>0) {
        [urlStr appendFormat:@"&since_id=%d",since_id];
    }
    if (max_id>0) {
        [urlStr appendFormat:@"&max_id=%d",max_id];
    }
    
    NSURL *url =[NSURL URLWithString:[picshareDomain stringByAppendingString:urlStr]];
    [urlStr release];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error && [request responseStatusCode]==200) {
        response = [request responseString];
    }
    else {
        return nil;
    }
    if (response != nil) {
        NSDictionary *dictFromJson = [response objectFromJSONString];
        NSNumber *hasnext = [dictFromJson objectForKey:@"hasnext"];
        NSArray *psArray = [dictFromJson objectForKey:@"pictures"];
        NSMutableArray *resultArray = [[[NSMutableArray alloc]init]autorelease];
        [resultArray addObject:hasnext];
        for (NSDictionary *aPSData in psArray) {
            PictureStatus *ps = [[PictureStatus alloc]initWithJSONDict:aPSData];
            if (ps!=nil) {
                [resultArray addObject:ps];
            }
            [ps release];
        }
        return resultArray;
    }
    return nil;
}

-(Board *)getBoard:(NSInteger)boardId
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingFormat:@"api/board/get.json?board_id=%d",boardId]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error && [request responseStatusCode]==200) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        Board *b = [[[Board alloc]initWithJSONDict:dataDict]autorelease];
        return b;
    }
    return  nil;
}
-(ErrorMessage *)followBoard:(NSInteger)boardId
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/relationship/follow.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request setPostValue:[NSNumber numberWithInt:boardId] forKey:@"board_id"];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        ErrorMessage *em = [[[ErrorMessage alloc]initWithJSONDict:dataDict]autorelease];
        NSLog(@"errorMessage:%@",em);
        return em;
    }
    return  nil;
    
}
-(ErrorMessage *)followUser:(NSInteger)userId
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/relationship/follow.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request setPostValue:[NSNumber numberWithInt:userId] forKey:@"user_id"];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        ErrorMessage *em = [[[ErrorMessage alloc]initWithJSONDict:dataDict]autorelease];
        NSLog(@"errorMessage:%@",em);
        return em;
    }
    return  nil;
}
-(ErrorMessage *)unFollowBoard:(NSInteger)boardId
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/relationship/unfollow.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request setPostValue:[NSNumber numberWithInt:boardId] forKey:@"board_id"];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        ErrorMessage *em = [[[ErrorMessage alloc]initWithJSONDict:dataDict]autorelease];
        NSLog(@"errorMessage:%@",em);
        return em;
    }
    return  nil;
}
-(ErrorMessage *)unFollowUser:(NSInteger)userId
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/relationship/unfollow.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request setPostValue:[NSNumber numberWithInt:userId] forKey:@"user_id"];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        ErrorMessage *em = [[[ErrorMessage alloc]initWithJSONDict:dataDict]autorelease];
        NSLog(@"errorMessage:%@",em);
        return em;
    }
    return  nil;
}

-(ErrorMessage *)updateBoard:(Board *)aBoard
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/board/update.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request setPostValue:[NSNumber numberWithInteger:aBoard.boardId] forKey:@"board_id"];
    [request setPostValue:[NSNumber numberWithInteger:aBoard.categoryId] forKey:@"category_id"];
    [request setPostValue:aBoard.name forKey:@"name"];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        ErrorMessage *em = [[[ErrorMessage alloc]initWithJSONDict:dataDict]autorelease];
        NSLog(@"errorMessage:%@",em);
        return em;
    }
    return  nil;
}

-(Board *)createBoard:(Board *)aBoard
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/board/create.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request setPostValue:[NSNumber numberWithInteger:aBoard.categoryId] forKey:@"category_id"];
    [request setPostValue:aBoard.name forKey:@"name"];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        NSLog(@"createBoardReturn:%@",dataDict);
        Board *b = [[[Board alloc]initWithJSONDict:dataDict]autorelease];
        if (b == nil) {
            ErrorMessage *em = [[ErrorMessage alloc]initWithJSONDict:dataDict];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:em.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            [alert release];
        }
        return b;
    }
    return nil;
}

-(PictureStatus *)repin:(NSInteger)ps_id toBoard:(NSInteger)boardId withDescription:(NSString *)theDescription
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/picture/repin.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:[NSNumber numberWithInteger:boardId] forKey:@"board_id"];
    [request setPostValue:[NSNumber numberWithInteger:ps_id] forKey:@"ps_id"];
    [request setPostValue:theDescription forKey:@"description"];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
        NSLog(@"%@",response);
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        PictureStatus *ps = [[[PictureStatus alloc]initWithJSONDict:dataDict]autorelease];
        if (ps!=nil) {
            return ps;
        }else {
            ErrorMessage *em = [[ErrorMessage alloc]initWithJSONDict:dataDict];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:em.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            [alert release];
            [em release];
        }
    }
    return nil;
}

-(User *)updateUser:(User *)user
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/user/update.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:user.nickname forKey:@"nick"];
    [request addPostValue:user.location forKey:@"location"];
    [request addPostValue:user.introduction forKey:@"introduction"];
    if (user.avatar!=nil) {
        NSData *picData = UIImagePNGRepresentation(user.avatar);
        [request setData:picData withFileName:@"avatar.png" andContentType:@"image/png" forKey:@"avatar"];
    }
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        //NSLog(@"update user result:%@",dataDict);
        User *user = [[User alloc]initWithJSONDict:dataDict];
        if (user!=nil) {
            return [user autorelease];
        }else {
            ErrorMessage *em = [[ErrorMessage alloc]initWithJSONDict:dataDict];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:em.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            [alert release];
            [em release];
        }
    }
    return nil;
}

-(NSArray *)getCommentsOfPictureStatus:(NSInteger)psId
{
    return [self getCommentsOfPictureStatus:psId page:1];
}
-(NSArray *)getCommentsOfPictureStatus:(NSInteger)psId page:(NSInteger)page
{
    return [self getCommentsOfPictureStatus:psId page:page countPerPage:5];
}
-(NSArray *)getCommentsOfPictureStatus:(NSInteger)psId page:(NSInteger)page countPerPage:(NSInteger)count
{
    
    return [self getCommentsOfPictureStatus:psId page:page countPerPage:count max:-1 since:-1];
}

-(NSArray *)getCommentsOfPictureStatus:(NSInteger)psId page:(NSInteger)page countPerPage:(NSInteger)count max:(NSInteger)maxId since:(NSInteger)sinceId
{
    NSString *urlStr = [picshareDomain stringByAppendingFormat:@"api/picture/get_comments.json?ps_id=%d&page=%d&count=%d",psId,page,count];
    if (maxId>0) {
        urlStr = [urlStr stringByAppendingFormat:@"&max_id=%d",maxId];
    }
    if (sinceId>0) {
        urlStr = [urlStr stringByAppendingFormat:@"&since_id=%d",sinceId];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        NSDictionary *commentsDataArray = [dataDict objectForKey:@"comments"];
        NSValue *hasNext = [dataDict objectForKey:@"hasnext"];
        if (commentsDataArray!=nil) {
            NSMutableArray *resultArray = [[NSMutableArray alloc]init];
            for (NSDictionary *aCommentData in commentsDataArray) {
                Comment *c = [[Comment alloc]initWithJSONDict:aCommentData];
                [resultArray addObject:c];
                [c release];
            }
            [resultArray insertObject:hasNext atIndex:0];
            return [resultArray autorelease];
        }else {
            ErrorMessage *em = [[ErrorMessage alloc]initWithJSONDict:dataDict];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:em.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            [alert release];
            [em release];
        }
    }
    return nil;
}

-(Comment *)createComment:(NSString *)commentText toPicture:(NSInteger)psId
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/comment/create.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:commentText forKey:@"text"];
    [request addPostValue:[NSNumber numberWithInteger:psId] forKey:@"ps_id"];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        Comment *c = [[[Comment alloc]initWithJSONDict:dataDict]autorelease];
        if (c!=nil) {
            return c;
        }else {
            ErrorMessage *em = [[ErrorMessage alloc]initWithJSONDict:dataDict];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:em.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            [alert release];
            [em release];
        }
    }
    return nil;
}

-(ErrorMessage *)deleteCommentById:(NSInteger)commentId
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/comment/delete.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:[NSNumber numberWithInteger:commentId] forKey:@"comment_id"];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        ErrorMessage *em = [[ErrorMessage alloc]initWithJSONDict:dataDict];
        if (request.responseStatusCode != 200) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:em.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            [alert release];
        }
        return [em autorelease];
    }
    return nil;
}

-(NSArray *)getMessagesToMe
{
    return [self getMessagesToMeWithPage:1 countPerPage:5 since:-1 max:-1];
}
-(NSArray *)getMessagesToMeWithPage:(NSInteger)page countPerPage:(NSInteger)count since:(NSInteger)sinceId max:(NSInteger)maxId
{
    NSString *urlStr = [picshareDomain stringByAppendingFormat:@"api/message/get_mine.json?page=%d&count=%d",page,count];
    if (maxId>0) {
        urlStr = [urlStr stringByAppendingFormat:@"&max_id=%d",maxId];
    }
    if (sinceId>0) {
        urlStr = [urlStr stringByAppendingFormat:@"&since_id=%d",sinceId];
    }
    NSURL *url = [NSURL URLWithString:urlStr];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSLog(@"%@",response);
        NSDictionary *dataDict = [response objectFromJSONString];
        NSLog(@"datadict:%@",dataDict);
        NSArray *messagesDataArray = [dataDict objectForKey:@"messages"];
        NSValue *hasnext = [dataDict objectForKey:@"hasnext"];
        if (messagesDataArray != nil) {
            NSMutableArray *resultArray = [[[NSMutableArray alloc]init]autorelease];
            for (NSDictionary *aMessageDict in messagesDataArray) {
                PSMessage *msg = [[PSMessage alloc]initWithJSONDict:aMessageDict];
                [resultArray addObject:msg];
                [msg release];
            }
            [resultArray insertObject:hasnext atIndex:0];
            return resultArray;
        }else{
            ErrorMessage *em = [[ErrorMessage alloc]initWithJSONDict:dataDict];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:em.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            [alert release];
            [em release];
        }
    }
    return nil;

}
-(NSInteger)getUnreadMessagesCount
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/message/get_unread_messages_count.json"]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return 0;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        NSNumber *nResult = [dataDict objectForKey:@"count"];
        if (nResult != nil) {
            return [nResult integerValue];
        }else{
            ErrorMessage *em = [[ErrorMessage alloc]initWithJSONDict:dataDict];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:em.errorMsg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
            [alert release];
            [em release];
        }
    }
    return 0;
}

-(ErrorMessage *)markMessageRead
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/message/mark_read.json"]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request setTimeOutSeconds:60];
    [request startSynchronous];
    
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return 0;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        ErrorMessage *em = [[[ErrorMessage alloc]initWithJSONDict:dataDict]autorelease];
        return em;
    }
    return nil;
}

-(ErrorMessage *)deletePictureStatus:(NSInteger)psId
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/picture/delete.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:[NSNumber numberWithInt:psId] forKey:@"ps_id"];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil) {
        NSDictionary *dataDict = [response objectFromJSONString];
        ErrorMessage *em = [[ErrorMessage alloc]initWithJSONDict:dataDict];
        return [em autorelease];
    }
    return nil;
}

-(ErrorMessage *)reportPictureStatus:(NSInteger)psId
{
    
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingFormat:@"api/picture/report.json?ps_id=%d",psId]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [self addAuthHeaderForRequest:request];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil && request.responseStatusCode==200) {
        ErrorMessage *em = [[[ErrorMessage alloc]initWithJSONDict:[response objectFromJSONString]]autorelease];
        return em;
    }
    return nil;
}

-(User *)login:(User *)user
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/user/login.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addBasicAuthenticationHeaderWithUsername:user.username andPassword:user.password];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil && request.responseStatusCode==200) {
        NSDictionary *dataDict = [response objectFromJSONString];
        User *u = [[[User alloc]initWithJSONDict:dataDict]autorelease];
        return u;
    }else {
        NSLog(@"%@",response);
        return nil;
    }
}

-(User *)regUser:(User *)user
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingString:@"api/user/reg.json"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addPostValue:user.username forKey:@"username"];
    [request addPostValue:user.password forKey:@"password"];
    [request addPostValue:user.email forKey:@"email"];
    [request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error) {
        response = [request responseString];
    }
    else {
        //do something in ui
        return nil;
    }
    if (response != nil && request.responseStatusCode==200) {
        NSDictionary *dataDict = [response objectFromJSONString];
        User *u = [[[User alloc]initWithJSONDict:dataDict]autorelease];
        return u;
    }else {
        NSDictionary *dataDict = [response objectFromJSONString];
        ErrorMessage *em = [[ErrorMessage alloc]initWithJSONDict:dataDict];
        if (em) {
            return [em autorelease];
        }
    }
    return nil;
}

@end
