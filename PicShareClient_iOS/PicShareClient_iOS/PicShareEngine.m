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

#define UPLOAD_IMAGE 0

NSString *picshareDomain = @"http://picshare.herkuang.info:8000/";

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
        NSLog(@"error! %@",[error code]);
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
        NSLog(@"error! %@",[error code]);
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
        NSLog(@"error! %@",[error code]);
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
        NSLog(@"error! %@",[error code]);
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
        NSLog(@"error! %@",[error code]);
        return nil;
    }
    if (response != nil) {
        NSDictionary *dictFromJson = [response objectFromJSONString];
        User *user = [[[User alloc]initWithJSONDict:dictFromJson]autorelease];
        return user;
    }
    return nil;
}

-(void)uploadPicture:(UIImage *)picture toBoard:(NSInteger)boardId withLatitude:(float)latitude longitude:(float)longitude description:(NSString *)description
{
    NSURL *url = [NSURL URLWithString:[picshareDomain stringByAppendingFormat:@"api/picture/upload.json"]];
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    NSData *picData = UIImagePNGRepresentation(picture);
    [request setData:picData withFileName:@"upload.png" andContentType:@"image/png" forKey:@"pic"];
    [request setValue:[NSNumber numberWithInteger:boardId] forKey:@"board_id"];
    [request setValue:[NSNumber numberWithFloat:latitude] forKey:@"latitude"];
    [request setValue:[NSNumber numberWithFloat:longitude] forKey:@"longitude"];
    [request setValue:description forKey:@"description"];
    [request setTag:UPLOAD_IMAGE];
    [request setDelegate:self];
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


@end
