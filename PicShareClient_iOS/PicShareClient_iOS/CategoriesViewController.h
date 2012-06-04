//
//  CategoriesViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-5.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicShareEngine.h"

/**
 探索界面
 */
@interface CategoriesViewController : UITableViewController
{
    PicShareEngine *_engine;
    NSOperationQueue *oprationq;
    BOOL isLoadingData;
}

@property (nonatomic,copy) NSArray *categories;
@end
