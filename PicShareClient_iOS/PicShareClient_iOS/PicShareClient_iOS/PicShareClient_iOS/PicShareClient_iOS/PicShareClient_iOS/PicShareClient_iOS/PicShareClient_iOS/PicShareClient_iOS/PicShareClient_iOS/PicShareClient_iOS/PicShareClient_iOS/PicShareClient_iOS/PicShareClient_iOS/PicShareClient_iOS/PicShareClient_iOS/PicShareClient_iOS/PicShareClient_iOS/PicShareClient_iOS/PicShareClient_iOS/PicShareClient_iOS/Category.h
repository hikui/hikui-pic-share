//
//  Category.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Category : NSObject

@property (readonly) NSInteger categoryId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSMutableArray *boards;

-(id)initWithJSONDict:(NSDictionary *)data;

@end
