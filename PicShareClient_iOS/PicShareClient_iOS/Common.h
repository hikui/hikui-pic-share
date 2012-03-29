//
//  Common.h
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-3-26.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Common : NSObject

@property (nonatomic,retain) NSOperationQueue *globalDownloadImageQ;
@property (nonatomic,retain) NSMutableDictionary *thumbnailCache;

+ (id)sharedCommon;
- (void)clearDownloadImageQ;
- (void)clearThumbnailCache;
- (void)receiveMemoryWarning;


@end
