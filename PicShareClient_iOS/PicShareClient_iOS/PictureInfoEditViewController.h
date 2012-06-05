//
//  PictureInfoEditViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-3-24.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardPickerViewController.h"
#import "SingleTextInputViewController.h"

typedef enum _Type{
    REPIN,
    CREATE,
}Type;

@interface PictureInfoEditViewController : UITableViewController
    <BoardPickerDelegate,SingleTextInputDelegate>

@property (nonatomic,retain) Board *board;
@property (nonatomic,copy) NSString *descriptionText;
@property (readwrite) CGPoint locationPoint; //!<未使用
@property (nonatomic,retain) UIImage *uploadImage;
@property (nonatomic,retain) PictureStatus *repinPs; //!<如果是repin，则为要repin的PictureStatus
@property Type type;
@property (nonatomic,retain) SingleTextInputViewController *pdcvc; //!<Description的输入界面
@property (nonatomic,retain) BoardPickerViewController *bpvc; //!<选取属于哪个Board



@end
