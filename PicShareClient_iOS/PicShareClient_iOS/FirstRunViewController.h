//
//  FirstRunViewController.h
//  PicShareClient_iOS
//
//  Created by 和光 缪 on 12-5-9.
//  Copyright (c) 2012年 Shanghai University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstRunViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,retain) IBOutlet UITextField *loginUsername;
@property (nonatomic,retain) IBOutlet UITextField *loginPassword;
@property (nonatomic,retain) IBOutlet UITextField *regUsername;
@property (nonatomic,retain) IBOutlet UITextField *regPassword;
@property (nonatomic,retain) IBOutlet UITextField *regPasswordConfirm;
@property (nonatomic,retain) IBOutlet UITextField *regEmail;
@property (nonatomic,retain) IBOutlet UIView *regView;

- (IBAction)regNewButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)regButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;

@end
