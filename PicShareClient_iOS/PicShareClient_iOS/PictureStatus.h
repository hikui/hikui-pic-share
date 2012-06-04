//
//  PictureStatus.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

typedef enum Status_type{
    Original = 1,
    Repin = 2,
    Reported = 3,
    Banned = 4
} Status_type;

@interface PictureStatus : NSObject

@property (readonly) NSInteger psId;
@property (nonatomic,copy) NSString *pictureUrl;
@property (nonatomic,retain) UIImage *picture; //!<未使用
@property (nonatomic,copy) NSString *picDescription;
@property (nonatomic,copy) NSString *location;
@property (readwrite) Status_type statusType;
@property (readwrite) NSInteger boardId;//!<所属的board id
@property (nonatomic,copy) NSString *boardName;
@property (nonatomic,retain) User *owner;
@property (nonatomic,retain) User *via; //!<从谁地方转发，若是原创，为nil
@property (nonatomic,retain) NSDate *timestamp;
@property (nonatomic,copy) NSMutableArray *sampleComments; //!<在timeline中显示的一部分评论
@property (nonatomic) NSInteger commentsCount; //!<评论总数

-(id)initWithJSONDict:(NSDictionary *)data;

@end
