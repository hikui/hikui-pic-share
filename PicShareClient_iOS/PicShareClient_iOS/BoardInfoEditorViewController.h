//
//  BoardInfoEditorViewController.h
//  PicShareClient_iOS
//
//  Created by 缪和光 on 12-4-5.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Board.h"

@interface BoardInfoEditorViewController : UITableViewController <UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic) NSInteger boardId;  //if new a board, this value should less than 0
@property (nonatomic,retain) Board *board;
@property (nonatomic,retain) IBOutlet UITableViewCell *boardNameCell;
@property (nonatomic,retain) IBOutlet UITableViewCell *categoryCell;
@property (nonatomic,retain) IBOutlet UITextField *boardNameTF;
@property (nonatomic,retain) IBOutlet UIPickerView *categoryPicker;
@property (nonatomic,retain) NSArray *categories;



@end
