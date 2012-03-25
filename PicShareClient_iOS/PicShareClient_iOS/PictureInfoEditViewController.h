//
//  PictureInfoEditViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-24.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardPickerViewController.h"
#import "PictureDescriptionComposerViewController.h"

@interface PictureInfoEditViewController : UITableViewController
    <BoardPickerDelegate,PictureDescriptionComposerDelegate>

@property (nonatomic,retain) Board *board;
@property (nonatomic,copy) NSString *descriptionText;
@property (readwrite) CGPoint locationPoint;

@end
