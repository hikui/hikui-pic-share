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
@property (nonatomic,retain) UIImage *avatar; //!<未用
@property (readwrite) BOOL isFollowing; //!< 某用户是否被当前用户关注
@property (readonly) NSInteger followingCount; //!<该用户关注的人数
@property (readonly) NSInteger followersCount; //!<关注该用户的人数
@property (readonly) NSInteger picturesCount;
@property (nonatomic,copy) NSString *password; //!this property won't exist in json
@property (nonatomic,copy) NSString *email;

/**
 从JSON解析，并生成一个User对象
 */
-(id)initWithJSONDict:(NSDictionary *)data;

@end
