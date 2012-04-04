//
//  ErrorMessage.h
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-4-4.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorMessage : NSObject

@property (nonatomic,copy) NSString *errorMsg;
@property (nonatomic,readwrite) NSInteger ret;
@property (nonatomic,readwrite) NSInteger errorcode;

-(id)initWithJSONDict:(NSDictionary *)data;

@end
