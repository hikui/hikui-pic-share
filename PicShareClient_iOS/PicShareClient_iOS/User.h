//
//  User.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User : NSObject

@property (readonly) NSInteger userId;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString *introduction;
@property (nonatomic,copy) NSString *avatarUrl;
@property (nonatomic,retain) UIImage *avatar; //async get
@property (readwrite) BOOL isFollowing;
@property (readonly) NSInteger followingCount;
@property (readonly) NSInteger followersCount;
@property (readonly) NSInteger picturesCount;
@property (nonatomic,copy) NSString *password; //this property won't exist in json

-(id)initWithJSONDict:(NSDictionary *)data;

@end
