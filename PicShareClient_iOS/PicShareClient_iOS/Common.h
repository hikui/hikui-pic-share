//
//  Common.h
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-3-26.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <Foundation/Foundation.h>
#define IS_RETINA [[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0)
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface Common : NSObject

@property (nonatomic,retain) NSOperationQueue *globalDownloadImageQ;
@property (nonatomic,retain) NSMutableDictionary *thumbnailCache;

+ (id)sharedCommon;
- (void)clearDownloadImageQ;
- (void)clearThumbnailCache;
- (void)receiveMemoryWarning;


@end
