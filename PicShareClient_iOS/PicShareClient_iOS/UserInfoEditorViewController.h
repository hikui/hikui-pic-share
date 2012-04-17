//
//  UserInfoEditorViewController.h
//  PicShareClient_iOS
//
//  Created by zoom on 12-4-17.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "SingleTextInputViewController.h"
@interface UserInfoEditorViewController : UITableViewController <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationBarDelegate,SingleTextInputDelegate>
@property (nonatomic,retain) User *user;
@property (nonatomic,retain) SingleTextInputViewController *stivc;
@property (nonatomic,retain) UIImagePickerController *picker;

@end
