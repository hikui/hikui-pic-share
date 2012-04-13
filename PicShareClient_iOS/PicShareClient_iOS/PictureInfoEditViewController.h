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

typedef enum _Type{
    REPIN,
    CREATE,
}Type;

@interface PictureInfoEditViewController : UITableViewController
    <BoardPickerDelegate,PictureDescriptionComposerDelegate>

@property (nonatomic,retain) Board *board;
@property (nonatomic,copy) NSString *descriptionText;
@property (readwrite) CGPoint locationPoint;
@property (nonatomic,retain) UIImage *uploadImage;
@property (nonatomic,retain) PictureStatus *repinPs;
@property Type type;
@property (nonatomic,retain) PictureDescriptionComposerViewController *pdcvc;
@property (nonatomic,retain) BoardPickerViewController *bpvc;



@end
