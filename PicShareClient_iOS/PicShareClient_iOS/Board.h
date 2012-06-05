//
//  Board.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface Board : NSObject

@property (readonly) NSInteger boardId;
@property (nonatomic,retain) User *owner;
@property (nonatomic,copy) NSMutableArray *pictureStatuses; //!<图片集
@property (nonatomic,copy) NSString *name;
@property (readwrite) NSInteger picturesCount; //!<相册拥有的图片数
@property (readwrite) NSInteger categoryId;//!<所属的category
@property BOOL isFollowing; //!<当前用户是否关注此相册

-(id)initWithJSONDict:(NSDictionary *)data;

@end
