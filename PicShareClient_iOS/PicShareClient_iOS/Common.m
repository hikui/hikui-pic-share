//
//  Common.m
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-3-26.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import "Common.h"

@implementation Common
@synthesize globalDownloadImageQ,thumbnailCache;

static Common *instance = NULL;

+(id)sharedCommon{
    @synchronized(self)
    {
        if (instance == NULL) {
            instance = [[Common alloc]init];
            instance.globalDownloadImageQ = [[[NSOperationQueue alloc]init]autorelease];
            instance.globalDownloadImageQ.maxConcurrentOperationCount = 5;
            instance.thumbnailCache = [[[NSMutableDictionary alloc]init]autorelease];
        }
        return instance;
    }
}

-(void)clearDownloadImageQ
{
    [self.globalDownloadImageQ cancelAllOperations];
}

- (void)clearThumbnailCache
{
    [self.thumbnailCache removeAllObjects];
}

- (void)dealloc
{
    [globalDownloadImageQ release];
    [thumbnailCache release];
    [super dealloc];
}

- (void)receiveMemoryWarning
{
    [self.thumbnailCache removeAllObjects];
}

@end
