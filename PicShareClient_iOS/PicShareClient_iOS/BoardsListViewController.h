//
//  BoardsListViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-5.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PicShareEngine.h"

typedef enum TheType{
    categoryDetail,
    userBoards
} TheType;


@interface BoardsListViewController : UITableViewController
{
    PicShareEngine *_engine;
    NSOperationQueue *_oprationq;
    UIActivityIndicatorView *_indicator;
    BOOL isLoadingData;
}

@property (nonatomic,copy)NSArray *boards;
@property (readwrite) TheType type;
@property (readwrite) NSInteger contentId;

- (id)initWithType:(TheType) aType AndId:(NSInteger)anId;

@end
