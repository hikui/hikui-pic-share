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
@property (nonatomic,copy) NSMutableArray *pictureStatuses;
@property (nonatomic,copy) NSString *name;
@property (readwrite) NSInteger picturesCount;
@property (readwrite) NSInteger categoryId;//所属的category

-(id)initWithJSONDict:(NSDictionary *)data;

@end
