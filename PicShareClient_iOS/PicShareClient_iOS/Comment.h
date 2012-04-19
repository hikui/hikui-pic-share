//
//  Comment.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface Comment : NSObject
@property (nonatomic) NSInteger commentId;
@property (nonatomic,retain) User *by;
@property (nonatomic,copy) NSString *text;
-(id)initWithJSONDict:(NSDictionary *)data;
@end
